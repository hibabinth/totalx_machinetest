import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totalx_machine_test/data/models/user_model.dart';

import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/user_viewmodel.dart';
import '../user/add_user_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

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

  void _showSortSheet(BuildContext context, UserViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sort',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 14),
              RadioListTile<AgeFilter>(
                value: AgeFilter.all,
                groupValue: viewModel.ageFilter,
                activeColor: Colors.blue,
                title: const Text('All'),
                onChanged: (value) {
                  viewModel.updateAgeFilter(value!);
                  Navigator.pop(context);
                },
              ),
              RadioListTile<AgeFilter>(
                value: AgeFilter.younger,
                groupValue: viewModel.ageFilter,
                activeColor: Colors.blue,
                title: const Text('Age: Below 60'),
                onChanged: (value) {
                  viewModel.updateAgeFilter(value!);
                  Navigator.pop(context);
                },
              ),
              RadioListTile<AgeFilter>(
                value: AgeFilter.older,
                groupValue: viewModel.ageFilter,
                activeColor: Colors.blue,
                title: const Text('Age: Above 60'),
                onChanged: (value) {
                  viewModel.updateAgeFilter(value!);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.read<AuthViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      body: SafeArea(
        child: Consumer<UserViewModel>(
          builder: (context, viewModel, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 82,
                  width: double.infinity,
                  color: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Nilambur',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.logout, color: Colors.white),
                        onPressed: () => authViewModel.signOut(),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 42,
                          child: TextField(
                            onChanged: viewModel.updateSearch,
                            decoration: InputDecoration(
                              hintText: 'search by name',
                              hintStyle: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 13,
                              ),
                              prefixIcon: const Icon(Icons.search, size: 20),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.zero,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(28),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(28),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => _showSortSheet(context, viewModel),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 38,
                          width: 38,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.sort,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: Text(
                    'Users Lists',
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
                        return const Center(child: Text('No users found'));
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        itemCount: filteredUsers.length,
                        itemBuilder: (context, index) {
                          final user = filteredUsers[index];
                          final imageUrl = user.imageUrl.trim();

                          return GestureDetector(
                            onDoubleTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddUserView(user: user),
                                ),
                              );
                            },
                            child: Card(
                              color: Colors.white,
                              elevation: 1.5,
                              margin: const EdgeInsets.only(bottom: 9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                leading: CircleAvatar(
                                  radius: 28,
                                  backgroundColor: Colors.grey.shade300,
                                  backgroundImage: imageUrl.isNotEmpty
                                      ? NetworkImage(imageUrl)
                                      : null,
                                  child: imageUrl.isEmpty
                                      ? Text(
                                          user.name.isNotEmpty
                                              ? user.name[0].toUpperCase()
                                              : '?',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : null,
                                ),
                                title: Text(
                                  user.name,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                subtitle: Text(
                                  'Age: ${user.age}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, size: 20),
                                  onPressed: () {
                                    viewModel.deleteUser(user.id);
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddUserView()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
