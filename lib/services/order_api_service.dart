import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class OrderApiService {
  // Android Emulator bilgisayarın localhost'una
  // 10.0.2.2 üzerinden erişir.
  static const String _baseUrl =
      'http://10.0.2.2:5151/api';

  // ============================================================
  // SİPARİŞ OLUŞTUR
  // ============================================================

  static Future<Map<String, dynamic>> createOrder({
    required int userId,
    required String paymentMethod,
    required String address,
    required double total,
    required List<Product> products,
    required Map<String, int> quantities,
  }) async {
    final items = products
        .map((product) {
          return {
            'productId': int.parse(product.id),
            'quantity': quantities[product.id] ?? 0,
          };
        })
        .where((item) {
          return (item['quantity'] as int) > 0;
        })
        .toList();

    if (items.isEmpty) {
      throw Exception(
        'Sipariş oluşturmak için sepetinizde ürün bulunmalıdır.',
      );
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/orders'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'userId': userId,
        'paymentMethod': paymentMethod,
        'address': address,
        'total': total,
        'items': items,
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
          'Sipariş oluşturulamadı.',
    );
  }

  // ============================================================
  // KULLANICININ SİPARİŞLERİNİ GETİR
  // ============================================================

  static Future<List<Map<String, dynamic>>> getUserOrders(
    int userId,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$_baseUrl/orders/user/$userId',
      ),
    );

    if (response.statusCode != 200) {
      final Map<String, dynamic> data =
          response.body.isNotEmpty
              ? jsonDecode(response.body)
                  as Map<String, dynamic>
              : {};

      throw Exception(
        data['message']?.toString() ??
            'Siparişler alınamadı.',
      );
    }

    final List<dynamic> data =
        response.body.isNotEmpty
            ? jsonDecode(response.body)
                as List<dynamic>
            : [];

    return data
        .map(
          (item) =>
              item as Map<String, dynamic>,
        )
        .toList();
  }
}