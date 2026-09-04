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
      final String imagePath =
          _convertImagePath(item['image']?.toString() ?? '');

      return Product(
        id: item['id'].toString(),
        name: item['name'] as String,
        category: item['category'] as String,
        price: (item['price'] as num).toDouble(),
        image: imagePath,
        description: item['description'] as String,
        stock: item['stock'] as int,
      );
    }).toList();
  }

  // ============================================================
  // API'DEN GELEN GÖRSEL YOLUNU FLUTTER ASSET YOLUNA ÇEVİR
  // ============================================================

  static String _convertImagePath(String image) {
    if (image.isEmpty) {
      return '';
    }

    String path = image.trim();

    // Başındaki / işaretlerini kaldır.
    while (path.startsWith('/')) {
      path = path.substring(1);
    }

    // Eğer tam URL geldiyse sadece dosya adını al.
    if (path.startsWith('http://') ||
        path.startsWith('https://')) {
      try {
        final uri = Uri.parse(path);

        if (uri.pathSegments.isNotEmpty) {
          path = Uri.decodeComponent(
            uri.pathSegments.last,
          );
        }
      } catch (_) {
        // URL çözülemezse mevcut değer kullanılacak.
      }
    }

    // ------------------------------------------------------------
    // ANAHTARLIK İSİM DÜZELTMESİ
    // ------------------------------------------------------------
    //
    // Backend'de "anahtarlik" şeklinde gelen isimleri,
    // Flutter asset klasörümüzdeki "anahtarlık" adına çeviriyoruz.
    //
    // i  -> ı
    //

    path = path.replaceAll(
      'anahtarlik',
      'anahtarlık',
    );

    path = path.replaceAll(
      'Anahtarlik',
      'Anahtarlık',
    );

    // ------------------------------------------------------------
    // ASSET YOLU OLUŞTUR
    // ------------------------------------------------------------

    if (path.startsWith('assets/')) {
      return path;
    }

    if (path.startsWith('products/')) {
      return 'assets/$path';
    }

    // Sadece dosya adı geldiyse products klasörünü ekle.
    if (!path.contains('/')) {
      return 'assets/products/$path';
    }

    // Diğer durumlarda son dosya adını kullan.
    final fileName = path.split('/').last;

    return 'assets/products/$fileName';
  }
}