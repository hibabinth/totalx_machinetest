import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/user_viewmodel.dart';
import '../user/add_user_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<UserViewModel>().fetchInitialUsers();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<UserViewModel>().fetchMoreUsers();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.read<AuthViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nilambur'),
        actions: [
          IconButton(
            onPressed: () => authViewModel.signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Consumer<UserViewModel>(
        builder: (context, viewModel, _) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  onChanged: viewModel.updateSearch,
                  decoration: InputDecoration(
                    hintText: 'Search by name or phone',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('All'),
                      selected: viewModel.ageFilter == AgeFilter.all,
                      onSelected: (_) =>
                          viewModel.updateAgeFilter(AgeFilter.all),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Age below 60'),
                      selected: viewModel.ageFilter == AgeFilter.younger,
                      onSelected: (_) =>
                          viewModel.updateAgeFilter(AgeFilter.younger),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Age above 60'),
                      selected: viewModel.ageFilter == AgeFilter.older,
                      onSelected: (_) =>
                          viewModel.updateAgeFilter(AgeFilter.older),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: viewModel.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(12),
                        itemCount:
                            viewModel.users.length +
                            (viewModel.isFetchingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == viewModel.users.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          final user = viewModel.users[index];

                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(user.imageUrl),
                              ),
                              title: Text(user.name),
                              subtitle: Text(
                                'Phone: ${user.phone}\nAge: ${user.age}',
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  viewModel.deleteUser(user.id);
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
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
