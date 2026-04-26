import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback onLogout;

  const HomeHeader({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82,
      width: double.infinity,
      color: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: AppColors.white, size: 18),
          const SizedBox(width: 4),
          const Text(
            AppStrings.location,
            style: TextStyle(color: AppColors.white, fontSize: 15),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.white),
            onPressed: onLogout,
          ),
        ],
      ),
    );
  }
}
