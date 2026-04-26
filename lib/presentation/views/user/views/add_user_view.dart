import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totalx_machine_test/core/constants/app_colors.dart';
import 'package:totalx_machine_test/data/models/user_model.dart';
import 'package:totalx_machine_test/presentation/viewmodels/user_viewmodel.dart';
import 'package:totalx_machine_test/presentation/views/user/widgets/user_form.dart';

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

  Future<void> _save(UserViewModel viewModel) async {
    final age = int.tryParse(_ageController.text.trim());
    if (age == null) throw Exception("Enter valid age");

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
          child: UserForm(
            isEdit: isEdit,
            nameController: _nameController,
            phoneController: _phoneController,
            ageController: _ageController,
            imageController: _imageUrlController,
            isLoading: viewModel.isLoading,
            onSave: () async {
              try {
                await _save(viewModel);

                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isEdit ? "User Updated" : "User Added"),
                  ),
                );

                Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(e.toString())));
              }
            },
          ),
        ),
      ),
    );
  }
}
