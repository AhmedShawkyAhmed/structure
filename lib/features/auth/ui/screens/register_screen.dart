import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:structure/core/di/service_locator.dart';
import 'package:structure/core/routing/app_routes.dart';
import 'package:structure/core/shared/widgets/error_widget.dart';
import 'package:structure/features/auth/cubit/auth_cubit.dart';
import 'package:structure/features/auth/cubit/auth_state.dart';
import 'package:structure/features/auth/data/requests/register_request.dart';
import 'package:structure/features/localization/generated/app_localizations.dart';
import 'package:ui_kit/ui_kit.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  AuthCubit authCubit = AuthCubit(serviceLocator());
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
              Navigator.pushNamed(context, AppRoutes.home.path);
            },
          );
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).registerFeatureTitle),
          ),
          body: Column(
            children: [
              const Text('Login Screen'),

              DefaultTextField(
                controller: _firstNameController,
                hintText: 'First Name',
              ),
              DefaultTextField(
                controller: _lastNameController,
                hintText: 'Last Name',
              ),
              DefaultTextField(
                controller: _emailController,
                hintText: 'Email Address',
              ),
              DefaultTextField(
                controller: _phoneNumberController,
                hintText: 'Phone Number',
              ),
              DefaultTextField(
                controller: _passwordController,
                hintText: 'Password',
                password: true,
              ),
              DefaultTextField(
                controller: _confirmPasswordController,
                hintText: 'Confirm Password',
                password: true,
              ),

              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    loading: () => const CircularProgressIndicator(),
                    orElse: () => DefaultButton(
                      title: 'Register',
                      onTap: () {
                        authCubit.register(
                          request: RegisterRequest(
                            firstName: _firstNameController.text,
                            lastName: _lastNameController.text,
                            email: _emailController.text,
                            phoneNumber: _phoneNumberController.text,
                            gender: 'male',
                            password: _passwordController.text,
                            confirmPassword: _confirmPasswordController.text,
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
