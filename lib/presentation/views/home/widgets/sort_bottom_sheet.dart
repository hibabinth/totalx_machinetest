import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../viewmodels/user_viewmodel.dart';

class SortBottomSheet extends StatelessWidget {
  final UserViewModel viewModel;

  const SortBottomSheet({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.sort,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
          _SortOptionTile(
            title: AppStrings.all,
            value: AgeFilter.all,
            groupValue: viewModel.ageFilter,
            onChanged: viewModel.updateAgeFilter,
          ),
          _SortOptionTile(
            title: AppStrings.below60,
            value: AgeFilter.younger,
            groupValue: viewModel.ageFilter,
            onChanged: viewModel.updateAgeFilter,
          ),
          _SortOptionTile(
            title: AppStrings.above60,
            value: AgeFilter.older,
            groupValue: viewModel.ageFilter,
            onChanged: viewModel.updateAgeFilter,
          ),
        ],
      ),
    );
  }
}

class _SortOptionTile extends StatelessWidget {
  final String title;
  final AgeFilter value;
  final AgeFilter groupValue;
  final ValueChanged<AgeFilter> onChanged;

  const _SortOptionTile({
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile<AgeFilter>(
      value: value,
      groupValue: groupValue,
      activeColor: Colors.blue,
      title: Text(title),
      onChanged: (value) {
        if (value == null) return;

        onChanged(value);
        Navigator.pop(context);
      },
    );
  }
}
