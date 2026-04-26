import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/user_model.dart';
import '../../../viewmodels/auth_viewmodel.dart';
import '../../../viewmodels/user_viewmodel.dart';
import '../../user/add_user_view.dart';
import '../widgets/home_header.dart';
import '../widgets/home_search_sort_bar.dart';
import '../widgets/sort_bottom_sheet.dart';
import '../widgets/user_list_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  void _openAddUser(BuildContext context, {UserModel? user}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddUserView(user: user)),
    );
  }

  void _showSortSheet(BuildContext context, UserViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => SortBottomSheet(viewModel: viewModel),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.read<AuthViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<UserViewModel>(
          builder: (context, viewModel, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeHeader(onLogout: authViewModel.signOut),

                HomeSearchSortBar(
                  onSearchChanged: viewModel.updateSearch,
                  onSortTap: () => _showSortSheet(context, viewModel),
                ),

                Expanded(
                  child: UserListView(
                    viewModel: viewModel,
                    onEditUser: (user) => _openAddUser(context, user: user),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        onPressed: () => _openAddUser(context),
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }
}
