import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:structure/core/di/service_locator.dart';
import 'package:structure/core/routing/app_routes.dart';
import 'package:structure/core/shared/widgets/error_widget.dart';
import 'package:structure/features/auth/cubit/auth_cubit.dart';
import 'package:structure/features/auth/cubit/auth_state.dart';
import 'package:structure/features/auth/data/requests/register_request.dart';
import 'package:structure/features/localization/generated/app_localizations.dart';

import '../widgets/auth_form_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthCubit _authCubit = AuthCubit(serviceLocator());
  final _form = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    for (final controller in [
      _firstName,
      _lastName,
      _email,
      _phone,
      _password,
      _confirm,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (!_form.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() => _submitting = true);
    _authCubit.register(
      request: RegisterRequest(
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        email: _email.text.trim(),
        phoneNumber: _phone.text.trim(),
        gender: 'male',
        password: _password.text,
        confirmPassword: _confirm.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return BlocProvider(
      create: (_) => _authCubit,
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) => state.whenOrNull<void>(
          error: (error) {
            setState(() => _submitting = false);
            DefaultException.showNetworkError(error);
          },
          success: (_) {
            setState(() => _submitting = false);
            Navigator.pushReplacementNamed(context, AppRoutes.home.path);
          },
        ),
        child: Scaffold(
          appBar: AppBar(title: Text(l.registerFeatureTitle)),
          body: AutofillGroup(
            child: Form(
              key: _form,
              child: AuthPageBody(
                title: l.createAccountTitle,
                subtitle: l.createAccountSubtitle,
                icon: Icons.person_add_alt_rounded,
                fields: [
                  AuthInput(
                    controller: _firstName,
                    label: l.firstNameLabel,
                    icon: Icons.person_outline_rounded,
                    enabled: !_submitting,
                    autofillHints: const [AutofillHints.givenName],
                  ),
                  const SizedBox(height: 18),
                  AuthInput(
                    controller: _lastName,
                    label: l.lastNameLabel,
                    icon: Icons.person_outline_rounded,
                    enabled: !_submitting,
                    autofillHints: const [AutofillHints.familyName],
                  ),
                  const SizedBox(height: 18),
                  AuthInput(
                    controller: _email,
                    label: l.emailLabel,
                    icon: Icons.mail_outline_rounded,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    enabled: !_submitting,
                    validator: (value) => validateEmail(value, l),
                  ),
                  const SizedBox(height: 18),
                  AuthInput(
                    controller: _phone,
                    label: l.phoneLabel,
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    autofillHints: const [AutofillHints.telephoneNumber],
                    enabled: !_submitting,
                  ),
                  const SizedBox(height: 18),
                  AuthInput(
                    controller: _password,
                    label: l.passwordLabel,
                    icon: Icons.lock_outline_rounded,
                    password: true,
                    autofillHints: const [AutofillHints.newPassword],
                    enabled: !_submitting,
                  ),
                  const SizedBox(height: 18),
                  AuthInput(
                    controller: _confirm,
                    label: l.confirmPasswordLabel,
                    icon: Icons.lock_outline_rounded,
                    password: true,
                    enabled: !_submitting,
                    textInputAction: TextInputAction.done,
                    validator: (value) => value == null || value.isEmpty
                        ? l.fieldRequired
                        : value != _password.text
                        ? l.passwordMismatch
                        : null,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _submitting ? null : _submit,
                    child: _submitting
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l.registerFeatureTitle),
                  ),
                ],
                footer: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(l.haveAccount),
                    TextButton(
                      onPressed: _submitting
                          ? null
                          : () => Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.login.path,
                            ),
                      child: Text(l.loginFeatureTitle),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
