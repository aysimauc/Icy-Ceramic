import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ProductApiService {
  static const String _baseUrl =
      'http://10.0.2.2:5151/api';

  static String _convertImagePath(String image) {
    String fileName = image.trim();

    if (fileName.startsWith('assets/products/')) {
      return fileName;
    }

    fileName = fileName.replaceAll(
      'assets/products/',
      '',
    );

    fileName = fileName.replaceAll(
      'assets\\products\\',
      '',
    );

    return 'assets/products/$fileName';
  }

  static Future<List<Product>> getProducts() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/products'),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Ürünler alınamadı. HTTP ${response.statusCode}',
      );
    }

    final List<dynamic> data =
        jsonDecode(response.body) as List<dynamic>;

    return data.map((item) {
      return Product(
        id: item['id'].toString(),
        name: item['name'] as String,
        category: item['category'] as String,
        price: (item['price'] as num).toDouble(),
        image: _convertImagePath(
          item['image']?.toString() ?? '',
        ),
        description:
            item['description']?.toString() ?? '',
        stock: (item['stock'] as num?)?.toInt() ?? 0,
      );
    }).toList();
  }
}