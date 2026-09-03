import '../models/product.dart';

class CartService {
  static final List<Product> _items = [];
  static final Map<String, int> _quantities = {};

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

  static void add(Product product) {
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

  static void increase(Product product) {
    final currentQuantity =
        quantity(product);

    if (currentQuantity < product.stock) {
      _quantities[product.id] =
          currentQuantity + 1;
    }
  }

  static void decrease(Product product) {
    final currentQuantity =
        quantity(product);

    if (currentQuantity <= 1) {
      remove(product);
      return;
    }

    _quantities[product.id] =
        currentQuantity - 1;
  }

  static void remove(Product product) {
    _items.removeWhere(
      (item) => item.id == product.id,
    );

    _quantities.remove(product.id);
  }

  static void clear() {
    _items.clear();
    _quantities.clear();
  }
}