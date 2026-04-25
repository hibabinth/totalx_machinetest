import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/user_model.dart';
import '../../data/services/user_service.dart';

class UserViewModel extends ChangeNotifier {
  final UserService _userService = UserService();
  final ImagePicker _picker = ImagePicker();

  File? selectedImage;
  bool isLoading = false;

  // ✅ Pick Image
  Future<void> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  // ✅ Add User
  Future<void> addUser({
    required String name,
    required String phone,
    required int age,
  }) async {
    if (selectedImage == null) {
      throw Exception('Please select an image');
    }

    try {
      isLoading = true;
      notifyListeners();

      final String userId = const Uuid().v4();

      final String imageUrl = await _userService.uploadUserImage(
        selectedImage!,
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
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
