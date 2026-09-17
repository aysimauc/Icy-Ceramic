import 'dart:convert';

import 'package:http/http.dart' as http;

class AdminProductManagementService {
  static const String _baseUrl =
      'http://10.0.2.2:5151/api';

  static Future<void> updateProduct({
    required int productId,
    required String name,
    required double price,
    required String description,
    required String image,
  }) async {
    final response = await http.put(
      Uri.parse(
        '$_baseUrl/products/$productId',
      ),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name.trim(),
        'price': price,
        'description': description.trim(),
        'image': image.trim(),
      }),
    );

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      String message =
          'Ürün güncellenemedi. HTTP ${response.statusCode}';

      try {
        final data =
            jsonDecode(response.body)
                as Map<String, dynamic>;

        if (data['message'] != null) {
          message =
              data['message'].toString();
        }
      } catch (_) {}

      throw Exception(message);
    }
  }
}