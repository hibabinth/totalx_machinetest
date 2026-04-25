import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/user_model.dart';
import '../../data/services/user_service.dart';

enum AgeFilter { all, younger, older }

class UserViewModel extends ChangeNotifier {
  final UserService _userService = UserService();

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

  Future<void> addUser({
    required String name,
    required String phone,
    required int age,
    required String imageUrl,
  }) async {
    if (name.trim().isEmpty) throw Exception('Name is required');
    if (phone.trim().isEmpty) throw Exception('Phone is required');
    if (imageUrl.trim().isEmpty) throw Exception('Image URL is required');

    isLoading = true;
    notifyListeners();

    try {
      final user = UserModel(
        id: const Uuid().v4(),
        name: name.trim(),
        phone: phone.trim(),
        age: age,
        imageUrl: imageUrl.trim(),
        createdAt: DateTime.now(),
      );

      await _userService.addUser(user);
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

  Future<void> updateUser({
    required String id,
    required String name,
    required String phone,
    required int age,
    required String imageUrl,
    required DateTime createdAt,
  }) async {
    if (name.trim().isEmpty) throw Exception('Name is required');
    if (phone.trim().isEmpty) throw Exception('Phone is required');

    isLoading = true;
    notifyListeners();

    try {
      final user = UserModel(
        id: id,
        name: name.trim(),
        phone: phone.trim(),
        age: age,
        imageUrl: imageUrl.trim(),
        createdAt: createdAt,
      );

      await _userService.updateUser(user);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
