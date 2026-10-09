import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:structure/core/di/service_locator.dart';
import 'package:structure/core/routing/app_routes.dart';
import 'package:structure/core/shared/widgets/error_widget.dart';
import 'package:structure/features/auth/cubit/auth_cubit.dart';
import 'package:structure/features/auth/cubit/auth_state.dart';
import 'package:structure/features/auth/data/requests/login_request.dart';
import 'package:structure/features/localization/generated/app_localizations.dart';

import '../widgets/auth_form_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthCubit _authCubit = AuthCubit(serviceLocator());
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_form.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() => _submitting = true);
    _authCubit.login(
      request: LoginRequest(
        email: _email.text.trim(),
        password: _password.text,
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
          appBar: AppBar(title: Text(l.loginFeatureTitle)),
          body: AutofillGroup(
            child: Form(
              key: _form,
              child: AuthPageBody(
                title: l.welcomeBack,
                subtitle: l.loginSubtitle,
                icon: Icons.waving_hand_outlined,
                fields: [
                  AuthInput(
                    key: const Key('login_email_field'),
                    controller: _email,
                    label: l.emailLabel,
                    icon: Icons.mail_outline_rounded,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.username],
                    enabled: !_submitting,
                    validator: (value) => validateEmail(value, l),
                  ),
                  const SizedBox(height: 18),
                  AuthInput(
                    key: const Key('login_password_field'),
                    controller: _password,
                    label: l.passwordLabel,
                    icon: Icons.lock_outline_rounded,
                    password: true,
                    autofillHints: const [AutofillHints.password],
                    enabled: !_submitting,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    key: const Key('login_button'),
                    onPressed: _submitting ? null : _submit,
                    child: _submitting
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l.loginFeatureTitle),
                  ),
                ],
                footer: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(l.noAccount),
                    TextButton(
                      onPressed: _submitting
                          ? null
                          : () => Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.register.path,
                            ),
                      child: Text(l.registerFeatureTitle),
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
