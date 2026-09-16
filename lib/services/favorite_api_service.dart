import 'dart:convert';

import 'package:http/http.dart' as http;

class FavoriteApiService {
  // Android Emulator için bilgisayarın localhost adresi:
  static const String _baseUrl =
      'http://10.0.2.2:5151/api';

  // ============================================================
  // KULLANICININ FAVORİLERİNİ GETİR
  // ============================================================

  static Future<List<int>> getFavoriteProductIds(
    int userId,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$_baseUrl/favorites/user/$userId',
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Favoriler alınamadı. HTTP ${response.statusCode}',
      );
    }

    final List<dynamic> data =
        jsonDecode(response.body) as List<dynamic>;

    return data
        .map(
          (item) =>
              int.parse(item['productId'].toString()),
        )
        .toList();
  }

  // ============================================================
  // FAVORİYE EKLE
  // ============================================================

  static Future<void> addFavorite({
    required int userId,
    required int productId,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/favorites'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'userId': userId,
        'productId': productId,
      }),
    );

    if (response.statusCode != 200 &&
        response.statusCode != 201) {
      String message =
          'Ürün favorilere eklenemedi.';

      if (response.body.isNotEmpty) {
        try {
          final data =
              jsonDecode(response.body)
                  as Map<String, dynamic>;

          message =
              data['message']?.toString() ??
                  message;
        } catch (_) {}
      }

      throw Exception(message);
    }
  }

  // ============================================================
  // FAVORİDEN ÇIKAR
  // ============================================================

  static Future<void> removeFavorite({
    required int userId,
    required int productId,
  }) async {
    final response = await http.delete(
      Uri.parse(
        '$_baseUrl/favorites/$userId/$productId',
      ),
    );

    if (response.statusCode != 200 &&
        response.statusCode != 204) {
      String message =
          'Ürün favorilerden çıkarılamadı.';

      if (response.body.isNotEmpty) {
        try {
          final data =
              jsonDecode(response.body)
                  as Map<String, dynamic>;

          message =
              data['message']?.toString() ??
                  message;
        } catch (_) {}
      }

      throw Exception(message);
    }
  }

  // ============================================================
  // FAVORİ Mİ?
  // ============================================================

  static Future<bool> isFavorite({
    required int userId,
    required int productId,
  }) async {
    final response = await http.get(
      Uri.parse(
        '$_baseUrl/favorites/user/$userId/contains/$productId',
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Favori durumu alınamadı. '
        'HTTP ${response.statusCode}',
      );
    }

    final data =
        jsonDecode(response.body)
            as Map<String, dynamic>;

    return data['isFavorite'] == true;
  }
}