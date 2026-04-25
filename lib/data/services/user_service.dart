import 'package:firebase_database/firebase_database.dart';

import '../models/user_model.dart';

class UserService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref('users');

  Future<void> addUser(UserModel user) async {
    await _db.child(user.id).set(user.toMap());
  }

  Future<void> updateUser(UserModel user) async {
    await _db.child(user.id).update(user.toMap());
  }

  Stream<List<UserModel>> getUsers() {
    return _db.onValue.map((event) {
      final data = event.snapshot.value;

      if (data == null) return [];

      final map = Map<String, dynamic>.from(data as dynamic);

      final users = map.values
          .map((e) => UserModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();

      users.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return users;
    });
  }

  Future<void> deleteUser(String id) async {
    await _db.child(id).remove();
  }
}
