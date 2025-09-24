import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:structure/features/auth/ui/screens/login_test_screen.dart';

// MARK: - Refactored code with a single comprehensive test
void main() {
  Future<void> pumpLoginScreen(WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginTestScreen()));
    await tester.pumpAndSettle();
  }
  testWidgets('full login screen interaction', (tester) async {
    await pumpLoginScreen(tester);

    // Enter email
    const email = 'test@example.com';
    await tester.enterText(find.byKey(const Key('login_email_field')), email);

    // Enter password
    const password = 'myPassword';
    await tester.enterText(find.byKey(const Key('login_password_field')), password);

    // Tap login
    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pump();

    // Verify text is present
    expect(find.text(email), findsOneWidget);
    expect(find.text(password), findsOneWidget);
  });

}

// MARK: - Original code with separate tests for each interaction
// void main() {
//   // A helper to pump the login screen
//   Future<void> pumpLoginScreen(WidgetTester tester) async {
//     await tester.pumpWidget(const MaterialApp(home: LoginTestScreen()));
//     await tester.pumpAndSettle();
//   }
//
//   group('LoginTestScreen Widget Tests', () {
//     testWidgets('enter email into email field', (tester) async {
//       await pumpLoginScreen(tester);
//
//       const email = 'test@example.com';
//       final emailFieldFinder = find.byKey(const Key('login_email_field'));
//
//       expect(emailFieldFinder, findsOneWidget);
//
//       await tester.enterText(emailFieldFinder, email);
//       await tester.pump();
//
//       expect(find.text(email), findsOneWidget);
//     });
//
//     testWidgets('enter password into password field', (tester) async {
//       await pumpLoginScreen(tester);
//
//       const password = 'myPassword';
//       final passwordFieldFinder = find.byKey(const Key('login_password_field'));
//
//       expect(passwordFieldFinder, findsOneWidget);
//
//       await tester.enterText(passwordFieldFinder, password);
//       await tester.pump();
//
//       expect(find.text(password), findsOneWidget);
//     });
//
//     testWidgets('tap on Login Button', (tester) async {
//       await pumpLoginScreen(tester);
//
//       final buttonFinder = find.byKey(const Key('login_button'));
//       expect(buttonFinder, findsOneWidget);
//
//       await tester.tap(buttonFinder);
//       await tester.pump();
//
//       // Add an assertion if tapping should cause UI change or navigation
//       // e.g. expect(find.text('Loading...'), findsOneWidget);
//     });
//   });
// }
