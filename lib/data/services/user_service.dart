import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/user_model.dart';

class UserService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref('users');
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload image
  Future<String> uploadUserImage(File file, String userId) async {
    final ref = _storage.ref().child('users/$userId.jpg');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  // Add user
  Future<void> addUser(UserModel user) async {
    await _db.child(user.id).set(user.toMap());
  }

  // Get users stream
  Stream<List<UserModel>> getUsers() {
    return _db.onValue.map((event) {
      final data = event.snapshot.value;

      if (data == null) return [];

      final map = Map<String, dynamic>.from(data as dynamic);

      return map.values
          .map((e) => UserModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    });
  }

  // Delete
  Future<void> deleteUser(String id) async {
    await _db.child(id).remove();
    await _storage.ref().child('users/$id.jpg').delete().catchError((_) {});
  }
}
