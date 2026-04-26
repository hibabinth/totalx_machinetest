import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

class UserFormActions extends StatelessWidget {
  final bool isLoading;
  final bool isEdit;
  final VoidCallback onSave;

  const UserFormActions({
    super.key,
    required this.isLoading,
    required this.isEdit,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
            onPressed: isLoading ? null : onSave,
            child: isLoading
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
    );
  }
}
