import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ProductApiService {
  // Android Emulator üzerinden bilgisayarımızdaki
  // ASP.NET Core backend'e erişmek için 10.0.2.2 kullanıyoruz.
  static const String _baseUrl =
      'http://10.0.2.2:5151/api';

  static Future<List<Product>> getProducts() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/products'),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Ürünler alınamadı. HTTP ${response.statusCode}',
      );
    }

    final List<dynamic> data = jsonDecode(
      response.body,
    );

    return data.map((item) {
      return Product(
        id: item['id'].toString(),
        name: item['name'] as String,
        category: item['category'] as String,
        price: (item['price'] as num).toDouble(),
        image: item['image'] as String,
        description: item['description'] as String,
        stock: item['stock'] as int,
      );
    }).toList();
  }
}