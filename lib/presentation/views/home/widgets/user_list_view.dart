import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../data/models/user_model.dart';
import '../../../viewmodels/user_viewmodel.dart';
import 'user_card.dart';

class UserListView extends StatelessWidget {
  final UserViewModel viewModel;
  final ValueChanged<UserModel> onEditUser;

  const UserListView({
    super.key,
    required this.viewModel,
    required this.onEditUser,
  });

  List<UserModel> _filterUsers(
    List<UserModel> users,
    String searchQuery,
    AgeFilter ageFilter,
  ) {
    var result = [...users];

    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();

      result = result.where((user) {
        return user.name.toLowerCase().contains(query) ||
            user.phone.contains(query);
      }).toList();
    }

    if (ageFilter == AgeFilter.younger) {
      result = result.where((user) => user.age < 60).toList();
    } else if (ageFilter == AgeFilter.older) {
      result = result.where((user) => user.age >= 60).toList();
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            AppStrings.userList,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),

        const SizedBox(height: 6),

        Expanded(
          child: StreamBuilder<List<UserModel>>(
            stream: viewModel.getUsersStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              }

              final users = snapshot.data ?? [];

              final filteredUsers = _filterUsers(
                users,
                viewModel.searchQuery,
                viewModel.ageFilter,
              );

              if (filteredUsers.isEmpty) {
                return const Center(child: Text(AppStrings.noUsers));
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];

                  return UserCard(
                    user: user,
                    onEdit: () => onEditUser(user),
                    onDelete: () => viewModel.deleteUser(user.id),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
