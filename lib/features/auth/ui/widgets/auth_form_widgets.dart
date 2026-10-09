import 'package:flutter/material.dart';

import '../../../../core/shared/widgets/app_ui.dart';
import '../../../localization/generated/app_localizations.dart';

class AuthPageBody extends StatelessWidget {
  const AuthPageBody({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.fields,
    required this.footer,
    super.key,
  });
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Widget> fields;
  final Widget footer;

  @override
  Widget build(BuildContext context) => AppPageBody(
    maxWidth: 560,
    children: [
      AppIconBadge(icon: icon, size: 64),
      const SizedBox(height: 24),
      Text(title, style: Theme.of(context).textTheme.headlineLarge),
      const SizedBox(height: 10),
      Text(subtitle),
      const SizedBox(height: 30),
      AppSectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: fields,
        ),
      ),
      const SizedBox(height: 20),
      footer,
    ],
  );
}

class AuthInput extends StatefulWidget {
  const AuthInput({
    required this.controller,
    required this.label,
    required this.icon,
    this.password = false,
    this.keyboardType,
    this.autofillHints,
    this.validator,
    this.enabled = true,
    this.textInputAction = TextInputAction.next,
    super.key,
  });
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool password;
  final TextInputType? keyboardType;
  final List<String>? autofillHints;
  final FormFieldValidator<String>? validator;
  final bool enabled;
  final TextInputAction textInputAction;

  @override
  State<AuthInput> createState() => _AuthInputState();
}

class _AuthInputState extends State<AuthInput> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return TextFormField(
      controller: widget.controller,
      enabled: widget.enabled,
      obscureText: widget.password && !_visible,
      enableSuggestions: !widget.password,
      autocorrect: !widget.password,
      keyboardType: widget.keyboardType,
      autofillHints: widget.autofillHints,
      textInputAction: widget.textInputAction,
      validator:
          widget.validator ??
          (value) =>
              value == null || value.trim().isEmpty ? l.fieldRequired : null,
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: Icon(widget.icon, size: 20),
        suffixIcon: widget.password
            ? IconButton(
                tooltip: _visible ? l.hidePassword : l.showPassword,
                onPressed: () => setState(() => _visible = !_visible),
                icon: Icon(
                  _visible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                ),
              )
            : null,
      ),
    );
  }
}

String? validateEmail(String? value, AppLocalizations l) =>
    value == null ||
        !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value.trim())
    ? l.emailRequired
    : null;
