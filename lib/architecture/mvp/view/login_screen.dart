import 'package:flutter/material.dart';
import 'package:structure/architecture/mvp/model/user_model.dart';
import 'package:structure/architecture/mvp/presenter/login_presenter.dart';

abstract class UserViewContract {
  void displayUser(User user);
}

class UserView extends StatefulWidget {
  final UserPresenter presenter;

  const UserView({super.key, required this.presenter});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> implements UserViewContract {
  String _userName = '';
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    widget.presenter.initView(this);
    widget.presenter.loadUser(); // Load data when the view is initialized
  }

  @override
  void displayUser(User user) {
    setState(() {
      _userName = user.name;
      _userEmail = user.email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MVP User Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Name: $_userName'),
            Text('Email: $_userEmail'),
            ElevatedButton(
              onPressed: () {
                widget.presenter.loadUser(); // Simulate reloading user data
              },
              child: const Text('Reload User'),
            ),
          ],
        ),
      ),
    );
  }
}