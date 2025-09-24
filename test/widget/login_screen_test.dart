import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:structure/features/auth/ui/screens/login_test_screen.dart';

void main() {
  testWidgets('enter email into email field', (tester) async {
    // Arrange: pump the LoginScreen inside a MaterialApp
    await tester.pumpWidget(const MaterialApp(home: LoginTestScreen()));

    // Act: type email into the field identified by the Key 'login_email_field'
    const email = 'test@example.com';
    final emailFieldFinder = find.byKey(const Key('login_email_field'));

    // ensure the field exists
    expect(
      emailFieldFinder,
      findsOneWidget,
      reason: 'Email field must be present',
    );

    // enter text
    await tester.enterText(emailFieldFinder, email);
    await tester.pump(); // rebuild after text input

    // Assert: the entered text is visible in the widget tree
    expect(find.text(email), findsOneWidget);
  });

  testWidgets('enter password into password field', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginTestScreen()));

    const password = 'myPassword';
    final passwordFieldFinder = find.byKey(const Key('login_password_field'));

    expect(
      passwordFieldFinder,
      findsOneWidget,
      reason: 'Password field must be present',
    );

    await tester.enterText(passwordFieldFinder, password);
    await tester.pump();
    expect(find.text(password), findsOneWidget);
  });

  testWidgets('Tap on Login Button', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginTestScreen()));

    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pump();
  });
}
