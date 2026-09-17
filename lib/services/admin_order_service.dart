import 'dart:convert';

import 'package:http/http.dart' as http;

class AdminOrderService {
  static const String _baseUrl =
      'http://10.0.2.2:5151/api';

  // ============================================================
  // TÜM SİPARİŞLERİ GETİR
  // ============================================================

  static Future<List<Map<String, dynamic>>> getAllOrders() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/orders/admin'),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Siparişler alınamadı. HTTP ${response.statusCode}',
      );
    }

    final List<dynamic> data =
        jsonDecode(response.body) as List<dynamic>;

    return data
        .map(
          (item) =>
              Map<String, dynamic>.from(item as Map),
        )
        .toList();
  }

  // ============================================================
  // TEK SİPARİŞİ GETİR
  // ============================================================

  static Future<Map<String, dynamic>> getOrder(
    int orderId,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$_baseUrl/orders/admin/$orderId',
      ),
    );

    if (response.statusCode != 200) {
      String message =
          'Sipariş alınamadı. HTTP ${response.statusCode}';

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

    return Map<String, dynamic>.from(
      jsonDecode(response.body) as Map,
    );
  }

  // ============================================================
  // SİPARİŞ DURUMUNU GÜNCELLE
  // ============================================================

  static Future<Map<String, dynamic>> updateOrderStatus({
    required int orderId,
    required String status,
    String? cargoCompany,
    String? trackingNumber,
  }) async {
    final response = await http.put(
      Uri.parse(
        '$_baseUrl/orders/$orderId/status',
      ),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'status': status,
        'cargoCompany': cargoCompany,
        'trackingNumber': trackingNumber,
      }),
    );

    if (response.statusCode != 200) {
      String message =
          'Sipariş güncellenemedi. HTTP ${response.statusCode}';

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

    return Map<String, dynamic>.from(
      jsonDecode(response.body) as Map,
    );
  }
}