import 'dart:convert';

import 'package:http/http.dart' as http;

class AdminProductService {
  static const String _baseUrl =
      'http://10.0.2.2:5151/api';

  static Future<void> updateStock({
    required int productId,
    required int stock,
  }) async {
    if (stock < 0) {
      throw Exception(
        'Stok miktarı 0\'dan küçük olamaz.',
      );
    }

    final response = await http.put(
      Uri.parse(
        '$_baseUrl/products/$productId/stock',
      ),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'stock': stock,
      }),
    );

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      String message =
          'Stok güncellenemedi.';

      try {
        final data =
            jsonDecode(response.body);

        if (data is Map &&
            data['message'] != null) {
          message =
              data['message'].toString();
        }
      } catch (_) {}

      throw Exception(message);
    }
  }
}