import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import 'user_avatar_preview.dart';
import 'user_text_field.dart';
import 'user_form_actions.dart';

class UserForm extends StatelessWidget {
  final bool isEdit;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController ageController;
  final TextEditingController imageController;
  final bool isLoading;
  final VoidCallback onSave;

  const UserForm({
    super.key,
    required this.isEdit,
    required this.nameController,
    required this.phoneController,
    required this.ageController,
    required this.imageController,
    required this.isLoading,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              isEdit ? "Edit User" : "Add A New User",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 20),

          UserAvatarPreview(imageController: imageController),

          const SizedBox(height: 20),

          UserTextField(controller: nameController, label: AppStrings.name),

          const SizedBox(height: 12),

          UserTextField(
            controller: phoneController,
            label: AppStrings.phone,
            keyboardType: TextInputType.phone,
          ),

          const SizedBox(height: 12),

          UserTextField(
            controller: ageController,
            label: AppStrings.age,
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 12),

          UserTextField(
            controller: imageController,
            label: AppStrings.imageUrl,
            hint: 'Paste direct image URL',
            keyboardType: TextInputType.url,
          ),

          const SizedBox(height: 20),

          UserFormActions(isLoading: isLoading, isEdit: isEdit, onSave: onSave),
        ],
      ),
    );
  }
}
