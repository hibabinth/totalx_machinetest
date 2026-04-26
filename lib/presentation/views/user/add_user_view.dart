import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/user_model.dart';
import '../../viewmodels/user_viewmodel.dart';

class AddUserView extends StatefulWidget {
  final UserModel? user;

  const AddUserView({super.key, this.user});

  @override
  State<AddUserView> createState() => _AddUserViewState();
}

class _AddUserViewState extends State<AddUserView> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  final _imageUrlController = TextEditingController();

  bool get isEdit => widget.user != null;

  @override
  void initState() {
    super.initState();

    if (isEdit) {
      _nameController.text = widget.user!.name;
      _phoneController.text = widget.user!.phone;
      _ageController.text = widget.user!.age.toString();
      _imageUrlController.text = widget.user!.imageUrl;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveUser(UserViewModel viewModel) async {
    final age = int.tryParse(_ageController.text.trim());

    if (age == null) {
      throw Exception("Enter valid age");
    }

    if (isEdit) {
      await viewModel.updateUser(
        id: widget.user!.id,
        name: _nameController.text,
        phone: _phoneController.text,
        age: age,
        imageUrl: _imageUrlController.text,
        createdAt: widget.user!.createdAt,
      );
    } else {
      await viewModel.addUser(
        name: _nameController.text,
        phone: _phoneController.text,
        age: age,
        imageUrl: _imageUrlController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<UserViewModel>();

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.3),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    isEdit ? "Edit User" : "Add A New User",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.blue.shade100,
                  backgroundImage: _imageUrlController.text.trim().isNotEmpty
                      ? NetworkImage(_imageUrlController.text.trim())
                      : null,
                  child: _imageUrlController.text.trim().isEmpty
                      ? const Icon(Icons.person, size: 50)
                      : null,
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: AppStrings.name,
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: AppStrings.phone,
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: _ageController,
                  decoration: const InputDecoration(
                    labelText: AppStrings.age,
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(
                    labelText: AppStrings.imageUrl,
                    hintText: 'Paste direct image URL',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.url,
                  onChanged: (_) => setState(() {}),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                          foregroundColor: AppColors.primary,
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(AppStrings.cancel),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: viewModel.isLoading
                            ? null
                            : () async {
                                try {
                                  await _saveUser(viewModel);

                                  if (!context.mounted) return;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        isEdit ? "User Updated" : "User Added",
                                      ),
                                    ),
                                  );

                                  Navigator.pop(context);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())),
                                  );
                                }
                              },
                        child: viewModel.isLoading
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.white,
                                ),
                              )
                            : Text(isEdit ? "Update" : AppStrings.save),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
