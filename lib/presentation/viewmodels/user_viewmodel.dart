import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  bool isFetchingMore = false;
  bool hasMore = true;

  final List<UserModel> _users = [];
  DocumentSnapshot? _lastDocument;

  String searchQuery = '';
  AgeFilter ageFilter = AgeFilter.all;

  List<UserModel> get users {
    List<UserModel> result = [..._users];

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

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  Future<void> fetchInitialUsers() async {
    isLoading = true;
    hasMore = true;
    _lastDocument = null;
    _users.clear();
    notifyListeners();

    try {
      final snapshot = await _userService.fetchUsers();

      if (snapshot.docs.isNotEmpty) {
        _lastDocument = snapshot.docs.last;
        _users.addAll(
          snapshot.docs.map((doc) => UserModel.fromMap(doc.data())),
        );
      }

      if (snapshot.docs.length < 10) hasMore = false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMoreUsers() async {
    if (isFetchingMore || !hasMore) return;

    isFetchingMore = true;
    notifyListeners();

    try {
      final snapshot = await _userService.fetchUsers(
        lastDocument: _lastDocument,
      );

      if (snapshot.docs.isNotEmpty) {
        _lastDocument = snapshot.docs.last;
        _users.addAll(
          snapshot.docs.map((doc) => UserModel.fromMap(doc.data())),
        );
      }

      if (snapshot.docs.length < 10) hasMore = false;
    } finally {
      isFetchingMore = false;
      notifyListeners();
    }
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
        name: name,
        phone: phone,
        age: age,
        imageUrl: imageUrl,
        createdAt: DateTime.now(),
      );

      await _userService.addUser(user);
      selectedImage = null;
      await fetchInitialUsers();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteUser(String userId) async {
    await _userService.deleteUser(userId);
    _users.removeWhere((user) => user.id == userId);
    notifyListeners();
  }
}s