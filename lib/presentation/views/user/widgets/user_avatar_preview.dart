import 'package:flutter/material.dart';

class UserAvatarPreview extends StatelessWidget {
  final TextEditingController imageController;

  const UserAvatarPreview({super.key, required this.imageController});

  @override
  Widget build(BuildContext context) {
    final imageUrl = imageController.text.trim();

    return CircleAvatar(
      radius: 45,
      backgroundColor: Colors.blue.shade100,
      backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
      child: imageUrl.isEmpty ? const Icon(Icons.person, size: 50) : null,
    );
  }
}
