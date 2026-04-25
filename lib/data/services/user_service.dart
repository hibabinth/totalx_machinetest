import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  Future<String> uploadUserImage(File imageFile, String userId) async {
    final ref = _storage.ref().child('users/$userId.jpg');
    await ref.putFile(imageFile);
    return ref.getDownloadURL();
  }

  Future<void> addUser(UserModel user) async {
    await _users.doc(user.id).set(user.toMap());
  }

  Future<void> updateUser(UserModel user) async {
    await _users.doc(user.id).update(user.toMap());
  }

  Future<void> deleteUser(String userId) async {
    await _users.doc(userId).delete();
    await _storage.ref().child('users/$userId.jpg').delete().catchError((_) {});
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchUsers({
    DocumentSnapshot? lastDocument,
    int limit = 10,
  }) {
    Query<Map<String, dynamic>> query = _users
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    return query.get();
  }
}
