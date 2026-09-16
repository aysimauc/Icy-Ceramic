import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthApiService {
  static const String _baseUrl =
      'http://10.0.2.2:5151/api';

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email.trim(),
        'password': password,
      }),
    );

    final Map<String, dynamic> data =
        response.body.isNotEmpty
            ? jsonDecode(response.body)
                as Map<String, dynamic>
            : {};

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(
      data['message']?.toString() ??
          'Giriş yapılamadı.',
    );
  }
}