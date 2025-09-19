import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:structure/architecture/mvvm/viewModel/user_viewmodel.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: Consumer<UserViewModel>(
        builder: (context, userViewModel, child) {
          if (userViewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (userViewModel.user == null) {
            return const Center(child: Text('No user data available.'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${userViewModel.user!.name}', style: const TextStyle(fontSize: 20)),
                  Text('Email: ${userViewModel.user!.email}', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Example of updating user name
                      userViewModel.updateUserName('Jane Doe');
                    },
                    child: const Text('Update Name'),
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Provider.of<UserViewModel>(context, listen: false).loadUser(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}