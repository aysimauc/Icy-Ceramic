import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class CartService {
  static const String _baseUrl =
      'http://127.0.0.1:5151/api';

  static final List<Product> _items = [];
  static final Map<String, int> _quantities = {};

  // ============================================================
  // GETTERS
  // ============================================================

  static List<Product> get items {
    return List.unmodifiable(_items);
  }

  static int quantity(Product product) {
    return _quantities[product.id] ?? 0;
  }

  static int get itemCount {
    return _items.fold(
      0,
      (total, product) =>
          total + quantity(product),
    );
  }

  static double get totalPrice {
    return _items.fold(
      0,
      (total, product) =>
          total +
          (product.price * quantity(product)),
    );
  }

  static bool contains(Product product) {
    return _items.any(
      (item) => item.id == product.id,
    );
  }

  // ============================================================
  // LOCAL CART
  // ============================================================

  static void addLocal(Product product) {
    if (contains(product)) {
      final currentQuantity =
          quantity(product);

      if (currentQuantity < product.stock) {
        _quantities[product.id] =
            currentQuantity + 1;
      }

      return;
    }

    _items.add(product);
    _quantities[product.id] = 1;
  }

  static void setLocalQuantity(
    Product product,
    int quantity,
  ) {
    if (quantity <= 0) {
      removeLocal(product);
      return;
    }

    if (!contains(product)) {
      _items.add(product);
    }

    final safeQuantity =
        quantity > product.stock
            ? product.stock
            : quantity;

    if (safeQuantity <= 0) {
      removeLocal(product);
      return;
    }

    _quantities[product.id] =
        safeQuantity;
  }

  static void removeLocal(Product product) {
    _items.removeWhere(
      (item) => item.id == product.id,
    );

    _quantities.remove(product.id);
  }

  static void clearLocal() {
    _items.clear();
    _quantities.clear();
  }

  // ============================================================
  // SQL SERVER CART
  // ============================================================

  /// Kullanıcının SQL Server'daki sepetini getirir.
  ///
  /// Backend sadece ProductId ve Quantity döndürür.
  /// Ürün bilgilerini mevcut Product listesinden bulup
  /// Flutter sepetine ekliyoruz.
  static Future<void> loadFromApi({
    required int userId,
    required List<Product> products,
  }) async {
    final response = await http.get(
      Uri.parse(
        '$_baseUrl/cart/user/$userId',
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Sepet alınamadı. HTTP ${response.statusCode}',
      );
    }

    final List<dynamic> data =
        jsonDecode(response.body)
            as List<dynamic>;

    clearLocal();

    for (final item in data) {
      final productId =
          item['productId'].toString();

      final quantity =
          (item['quantity'] as num).toInt();

      Product? product;

      for (final currentProduct
          in products) {
        if (currentProduct.id ==
            productId) {
          product = currentProduct;
          break;
        }
      }

      if (product == null) {
        continue;
      }

      if (quantity <= 0 ||
          product.stock <= 0) {
        continue;
      }

      final safeQuantity =
          quantity > product.stock
              ? product.stock
              : quantity;

      _items.add(product);

      _quantities[product.id] =
          safeQuantity;
    }
  }

  /// Mevcut ürünün miktarını SQL Server'a kaydeder.
  static Future<void> saveToApi({
    required int userId,
    required Product product,
    required int quantity,
  }) async {
    if (quantity <= 0) {
      await removeFromApi(
        userId: userId,
        product: product,
      );
      return;
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/cart'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'userId': userId,
        'productId':
            int.parse(product.id),
        'quantity': quantity,
      }),
    );

    if (response.statusCode != 200) {
      String message =
          'Sepet güncellenemedi.';

      try {
        final body =
            jsonDecode(response.body);

        if (body is Map &&
            body['message'] != null) {
          message =
              body['message'].toString();
        }
      } catch (_) {}

      throw Exception(message);
    }
  }

  /// Ürünü SQL Server sepetinden siler.
  static Future<void> removeFromApi({
    required int userId,
    required Product product,
  }) async {
    final response = await http.delete(
      Uri.parse(
        '$_baseUrl/cart/$userId/${product.id}',
      ),
    );

    if (response.statusCode != 200 &&
        response.statusCode != 404) {
      throw Exception(
        'Ürün sepetten silinemedi. '
        'HTTP ${response.statusCode}',
      );
    }
  }

  /// Kullanıcının SQL Server'daki tüm sepetini temizler.
  static Future<void> clearFromApi({
    required int userId,
  }) async {
    final response = await http.delete(
      Uri.parse(
        '$_baseUrl/cart/user/$userId',
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Sepet temizlenemedi. '
        'HTTP ${response.statusCode}',
      );
    }

    clearLocal();
  }

  // ============================================================
  // ADD
  // ============================================================

  static Future<void> add(
    Product product, {
    int? userId,
  }) async {
    final currentQuantity =
        quantity(product);

    if (currentQuantity >= product.stock) {
      return;
    }

    final newQuantity =
        currentQuantity + 1;

    setLocalQuantity(
      product,
      newQuantity,
    );

    if (userId != null) {
      try {
        await saveToApi(
          userId: userId,
          product: product,
          quantity: newQuantity,
        );
      } catch (error) {
        // API kaydı başarısız olursa
        // local sepeti eski haline getir.
        if (currentQuantity <= 0) {
          removeLocal(product);
        } else {
          setLocalQuantity(
            product,
            currentQuantity,
          );
        }

        rethrow;
      }
    }
  }

  // ============================================================
  // INCREASE
  // ============================================================

  static Future<void> increase(
    Product product, {
    int? userId,
  }) async {
    final currentQuantity =
        quantity(product);

    if (currentQuantity >= product.stock) {
      return;
    }

    final newQuantity =
        currentQuantity + 1;

    setLocalQuantity(
      product,
      newQuantity,
    );

    if (userId != null) {
      try {
        await saveToApi(
          userId: userId,
          product: product,
          quantity: newQuantity,
        );
      } catch (error) {
        setLocalQuantity(
          product,
          currentQuantity,
        );

        rethrow;
      }
    }
  }

  // ============================================================
  // DECREASE
  // ============================================================

  static Future<void> decrease(
    Product product, {
    int? userId,
  }) async {
    final currentQuantity =
        quantity(product);

    if (currentQuantity <= 0) {
      return;
    }

    if (currentQuantity == 1) {
      await remove(
        product,
        userId: userId,
      );
      return;
    }

    final newQuantity =
        currentQuantity - 1;

    setLocalQuantity(
      product,
      newQuantity,
    );

    if (userId != null) {
      try {
        await saveToApi(
          userId: userId,
          product: product,
          quantity: newQuantity,
        );
      } catch (error) {
        setLocalQuantity(
          product,
          currentQuantity,
        );

        rethrow;
      }
    }
  }

  // ============================================================
  // REMOVE
  // ============================================================

  static Future<void> remove(
    Product product, {
    int? userId,
  }) async {
    final wasInCart =
        contains(product);

    if (!wasInCart) {
      return;
    }

    final oldQuantity =
        quantity(product);

    removeLocal(product);

    if (userId != null) {
      try {
        await removeFromApi(
          userId: userId,
          product: product,
        );
      } catch (error) {
        // API silme işlemi başarısız olursa
        // local sepeti geri getir.
        _items.add(product);
        _quantities[product.id] =
            oldQuantity;

        rethrow;
      }
    }
  }

  // ============================================================
  // CLEAR
  // ============================================================

  static Future<void> clear({
    int? userId,
  }) async {
    if (userId != null) {
      await clearFromApi(
        userId: userId,
      );
      return;
    }

    clearLocal();
  }
}