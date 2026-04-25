import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/user_model.dart';
import '../../data/services/user_service.dart';

enum AgeFilter { all, younger, older }

class UserViewModel extends ChangeNotifier {
  final UserService _userService = UserService();
  final ImagePicker _picker = ImagePicker();

  File? selectedImage;
  bool isLoading = false;

  List<UserModel> allUsers = [];

  String searchQuery = '';
  AgeFilter ageFilter = AgeFilter.all;

  List<UserModel> get users {
    List<UserModel> result = [...allUsers];

    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();

      result = result.where((user) {
        return user.name.toLowerCase().contains(query) ||
            user.phone.contains(query);
      }).toList();
    }

    if (ageFilter == AgeFilter.younger) {
      result = result.where((user) => user.age < 60).toList();
    } else if (ageFilter == AgeFilter.older) {
      result = result.where((user) => user.age >= 60).toList();
    }

    return result;
  }

  Stream<List<UserModel>> getUsersStream() {
    return _userService.getUsers();
  }

  void setUsers(List<UserModel> users) {
    allUsers = users;
    notifyListeners();
  }

  void updateSearch(String value) {
    searchQuery = value;
    notifyListeners();
  }

  void updateAgeFilter(AgeFilter filter) {
    ageFilter = filter;
    notifyListeners();
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  Future<void> addUser({
    required String name,
    required String phone,
    required int age,
  }) async {
    if (name.trim().isEmpty) throw Exception('Name is required');
    if (phone.trim().isEmpty) throw Exception('Phone is required');
    if (selectedImage == null) throw Exception('Please select an image');

    isLoading = true;
    notifyListeners();

    try {
      final userId = const Uuid().v4();

      final imageUrl = await _userService.uploadUserImage(
        selectedImage!,
        userId,
      );

      final user = UserModel(
        id: userId,
        name: name.trim(),
        phone: phone.trim(),
        age: age,
        imageUrl: imageUrl,
        createdAt: DateTime.now(),
      );

      await _userService.addUser(user);

      selectedImage = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteUser(String userId) async {
    await _userService.deleteUser(userId);
    allUsers.removeWhere((user) => user.id == userId);
    notifyListeners();
  }
}
