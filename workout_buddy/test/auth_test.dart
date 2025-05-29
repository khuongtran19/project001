import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workout_buddy/screens/login_screen.dart'; // Adjust path as needed

// Replicate the email validation from your login screen
bool validateEmail(String email) {
  return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
}

void main() {
  test('Email validation rejects malformed emails', () {
    expect(validateEmail('test@test.com'), true);
    expect(validateEmail('invalid-email'), false);
    expect(validateEmail('missing@dot'), false);
  });

  testWidgets('Login shows error for short passwords', (tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));

    // Enter valid email first
    await tester.enterText(find.byType(TextField).at(0), 'test@test.com');

    // Enter invalid short password
    await tester.enterText(find.byType(TextField).at(1), '123');

    // Tap login button
    await tester.tap(find.byType(ElevatedButton).first);
    await tester.pump(); // Trigger frame update

    // Verify error message appears
    expect(find.text('Password must be 6+ characters'), findsOneWidget);
  });

  testWidgets('Valid email format passes validation', (tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: LoginScreen())));

    final emailField = find.byType(TextField).first;
    await tester.enterText(emailField, 'valid@email.com');
    await tester.tap(find.text('Login with Email'));
    await tester.pump();

    expect(find.text('Please enter a valid email'), findsNothing);
  });
}
