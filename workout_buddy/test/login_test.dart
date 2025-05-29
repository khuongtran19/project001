import 'package:flutter_test/flutter_test.dart';
import 'package:workout_buddy/utils/token_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // Initialize SharedPreferences for testing
  TestWidgetsFlutterBinding.ensureInitialized();

  // Email validation helper
  bool validateEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  group('Token Storage Tests', () {
    test('Saves and retrieves tokens', () async {
      // Set mock values
      SharedPreferences.setMockInitialValues({
        'access_token': 'test_access',
        'refresh_token': 'test_refresh',
      });

      // Test retrieval
      final token = await TokenStorage.getRefreshToken();
      expect(token, 'test_refresh');
    });

    test('Saves new tokens', () async {
      SharedPreferences.setMockInitialValues({});

      await TokenStorage.saveTokens('new_access', 'new_refresh');
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('refresh_token'), 'new_refresh');
    });

    test('Handles missing tokens', () async {
      SharedPreferences.setMockInitialValues({});
      final token = await TokenStorage.getRefreshToken();
      expect(token, isNull);
    });
  });

  group('Email Validation Tests', () {
    test('Valid emails pass', () {
      expect(validateEmail('user@example.com'), isTrue);
      expect(validateEmail('first.last@domain.co'), isTrue);
    });

    test('Invalid emails fail', () {
      expect(validateEmail('plainstring'), isFalse);
      expect(validateEmail('missing@dot'), isFalse);
    });
  });
}
