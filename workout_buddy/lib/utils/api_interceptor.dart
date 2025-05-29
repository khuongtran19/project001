// lib/utils/api_interceptor.dart
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_storage.dart';

class ApiClient {
  static const String baseUrl =
      'https://workoutbuddy.com'; // Initialize with your backend URL

  Future<http.Response> getWithToken(String path) async {
    final accessToken = await TokenStorage.getAccessToken();
    return await http.get(
      Uri.parse('$baseUrl$path'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );
  }

  Future<http.Response> postWithToken(String path, dynamic body) async {
    final accessToken = await TokenStorage.getAccessToken();
    return await http.post(
      Uri.parse('$baseUrl$path'),
      body: jsonEncode(body),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );
  }

  Future<http.Response> refreshToken() async {
    final refreshToken = await TokenStorage.getRefreshToken();
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/refresh-token'),
      body: jsonEncode({'refreshToken': refreshToken}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final newAccessToken = jsonDecode(response.body)['accessToken'];
      await TokenStorage.saveTokens(newAccessToken, refreshToken!);
    }
    return response;
  }
}
