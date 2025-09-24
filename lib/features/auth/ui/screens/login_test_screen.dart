import 'package:core_utils/core_utils.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class LoginTestScreen extends StatefulWidget {
  const LoginTestScreen({super.key});

  @override
  State<LoginTestScreen> createState() => _LoginTestScreenState();
}

class _LoginTestScreenState extends State<LoginTestScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text('Login Screen'),

          DefaultTextField(
            key: const Key('login_email_field'),
            controller: _emailController,
            hintText: 'Email',
          ),
          DefaultTextField(
            key: const Key('login_password_field'),
            controller: _passwordController,
            hintText: 'Password',
            password: true,
          ),

          DefaultButton(
            key: const Key('login_button'),
            title: 'Login',
            onTap: () {
              AppLogs.successLog('Login button tapped');
            },
          ),
        ],
      ),
    );
  }
}
