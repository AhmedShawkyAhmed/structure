import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:structure/core/di/service_locator.dart';
import 'package:structure/core/routing/app_routes.dart';
import 'package:structure/core/shared/widgets/error_widget.dart';
import 'package:structure/features/auth/cubit/auth_cubit.dart';
import 'package:structure/features/auth/cubit/auth_state.dart';
import 'package:structure/features/auth/data/requests/login_request.dart';
import 'package:ui_kit/ui_kit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthCubit authCubit = AuthCubit(serviceLocator());
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
    return BlocProvider(
      create: (context) => authCubit,
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          state.whenOrNull(
            error: (error) {
              DefaultException.showNetworkError(error);
            },
            success: (data) {
              Navigator.pushNamed(context, AppRoutes.login.path);
            },
          );
        },
        child: Scaffold(
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

              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    loading: () => const CircularProgressIndicator(),
                    orElse: () => DefaultButton(
                      key: const Key('login_button'),
                      title: 'Login',
                      onTap: () {
                        authCubit.login(
                          request: LoginRequest(
                            email: _emailController.text,
                            password: _passwordController.text,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
