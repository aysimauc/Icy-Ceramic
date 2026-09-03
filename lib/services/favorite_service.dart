import '../models/product.dart';

class FavoriteService {
  static final List<Product> _favorites = [];

  static List<Product> get favorites {
    return List.unmodifiable(_favorites);
  }

  static bool isFavorite(Product product) {
    return _favorites.any(
      (item) => item.id == product.id,
    );
  }

  static void toggleFavorite(Product product) {
    final index = _favorites.indexWhere(
      (item) => item.id == product.id,
    );

    if (index >= 0) {
      _favorites.removeAt(index);
    } else {
      _favorites.add(product);
    }
  }

  static void removeFavorite(Product product) {
    _favorites.removeWhere(
      (item) => item.id == product.id,
    );
  }
}