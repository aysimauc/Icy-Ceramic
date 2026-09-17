import 'dart:convert';

import 'package:http/http.dart' as http;

class AdminUserService {
  static const String _baseUrl =
      'http://10.0.2.2:5151/api';

  // ============================================================
  // TÜM KULLANICILARI GETİR
  // GET: /api/users/admin
  // ============================================================

  static Future<List<Map<String, dynamic>>> getUsers() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/users/admin'),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Kullanıcılar alınamadı. HTTP ${response.statusCode}',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! List) {
      throw Exception(
        'Kullanıcı verileri beklenen formatta değil.',
      );
    }

    return decoded
        .map<Map<String, dynamic>>(
          (item) => Map<String, dynamic>.from(
            item as Map,
          ),
        )
        .toList();
  }

  // ============================================================
  // TEK KULLANICIYI GETİR
  // GET: /api/users/admin/{id}
  // ============================================================

  static Future<Map<String, dynamic>> getUser(
    int userId,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$_baseUrl/users/admin/$userId',
      ),
    );

    if (response.statusCode != 200) {
      final message =
          _getErrorMessage(response.body);

      throw Exception(message);
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map) {
      throw Exception(
        'Kullanıcı verisi beklenen formatta değil.',
      );
    }

    return Map<String, dynamic>.from(
      decoded,
    );
  }

  // ============================================================
  // KULLANICI ROLÜNÜ GÜNCELLE
  // PUT: /api/users/{id}/role
  // ============================================================

  static Future<Map<String, dynamic>>
      updateUserRole({
    required int userId,
    required String role,
  }) async {
    final response = await http.put(
      Uri.parse(
        '$_baseUrl/users/$userId/role',
      ),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'role': role,
      }),
    );

    if (response.statusCode != 200) {
      final message =
          _getErrorMessage(response.body);

      throw Exception(message);
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map) {
      throw Exception(
        'Sunucudan beklenen cevap alınamadı.',
      );
    }

    return Map<String, dynamic>.from(
      decoded,
    );
  }

  // ============================================================
  // HATA MESAJI
  // ============================================================

  static String _getErrorMessage(
    String responseBody,
  ) {
    try {
      final decoded =
          jsonDecode(responseBody);

      if (decoded is Map &&
          decoded['message'] != null) {
        return decoded['message']
            .toString();
      }
    } catch (_) {
      // JSON değilse aşağıdaki genel mesaj kullanılır.
    }

    return 'İşlem sırasında bir hata oluştu.';
  }
}