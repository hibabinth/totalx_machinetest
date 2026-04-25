import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // ✅ Upload Image
  Future<String> uploadUserImage(File imageFile) async {
    final String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    final Reference ref = _storage.ref().child('users').child('$fileName.jpg');

    final UploadTask uploadTask = ref.putFile(imageFile);

    await uploadTask.whenComplete(() {});

    final String downloadUrl = await ref.getDownloadURL();

    return downloadUrl;
  }

  // ✅ Add user to Firestore
  Future<void> addUser(UserModel user) async {
    await _firestore.collection('users').doc(user.id).set(user.toMap());
  }

  // ✅ Get users
  Stream<List<UserModel>> getUsers() {
    return _firestore
        .collection('users')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => UserModel.fromMap(doc.data()))
              .toList(),
        );
  }
}
