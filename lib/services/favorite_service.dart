import 'dart:async';

import '../models/product.dart';
import '../services/auth_session_service.dart';
import '../services/product_api_service.dart';
import 'favorite_api_service.dart';

class FavoriteService {
  static final List<Product> _favorites = [];

  static bool _isLoaded = false;

  // ============================================================
  // FAVORİLER
  // ============================================================

  static List<Product> get favorites {
    return List.unmodifiable(_favorites);
  }

  // ============================================================
  // FAVORİ Mİ?
  // ============================================================

  static bool isFavorite(Product product) {
    return _favorites.any(
      (item) => item.id == product.id,
    );
  }

  // ============================================================
  // SQL SERVER'DAN FAVORİLERİ YÜKLE
  // ============================================================

  static Future<void> loadFavorites() async {
    final userId = AuthSessionService.userId;

    if (userId == null) {
      _favorites.clear();
      _isLoaded = false;
      return;
    }

    try {
      final favoriteProductIds =
          await FavoriteApiService
              .getFavoriteProductIds(userId);

      final products =
          await ProductApiService.getProducts();

      _favorites.clear();

      for (final product in products) {
        final productId =
            int.tryParse(product.id);

        if (productId != null &&
            favoriteProductIds.contains(
              productId,
            )) {
          _favorites.add(product);
        }
      }

      _isLoaded = true;
    } catch (_) {
      // API ulaşılamazsa mevcut yerel listeyi
      // koruyoruz.
    }
  }

  // ============================================================
  // FAVORİ DURUMUNU YENİDEN YÜKLE
  // ============================================================

  static Future<void> refresh() async {
    await loadFavorites();
  }

  // ============================================================
  // FAVORİ EKLE / ÇIKAR
  // ============================================================

  static void toggleFavorite(Product product) {
    final userId = AuthSessionService.userId;

    if (userId == null) {
      return;
    }

    final index = _favorites.indexWhere(
      (item) => item.id == product.id,
    );

    if (index >= 0) {
      // Önce ekrandaki durumu anında değiştir.
      _favorites.removeAt(index);

      // Sonra SQL Server'dan sil.
      unawaited(
        _removeFromServer(
          userId: userId,
          product: product,
        ),
      );
    } else {
      // Önce ekrana anında yansıt.
      _favorites.add(product);

      // Sonra SQL Server'a kaydet.
      unawaited(
        _addToServer(
          userId: userId,
          product: product,
        ),
      );
    }
  }

  // ============================================================
  // SERVER'A EKLE
  // ============================================================

  static Future<void> _addToServer({
    required int userId,
    required Product product,
  }) async {
    final productId =
        int.tryParse(product.id);

    if (productId == null) {
      return;
    }

    try {
      await FavoriteApiService.addFavorite(
        userId: userId,
        productId: productId,
      );
    } catch (_) {
      // API başarısız olursa yerel durumu geri al.
      _favorites.removeWhere(
        (item) => item.id == product.id,
      );
    }
  }

  // ============================================================
  // SERVER'DAN SİL
  // ============================================================

  static Future<void> _removeFromServer({
    required int userId,
    required Product product,
  }) async {
    final productId =
        int.tryParse(product.id);

    if (productId == null) {
      return;
    }

    try {
      await FavoriteApiService.removeFavorite(
        userId: userId,
        productId: productId,
      );
    } catch (_) {
      // API başarısız olursa favoriyi geri getir.
      if (!isFavorite(product)) {
        _favorites.add(product);
      }
    }
  }

  // ============================================================
  // FAVORİDEN DOĞRUDAN SİL
  // ============================================================

  static void removeFavorite(Product product) {
    final userId = AuthSessionService.userId;

    if (userId == null) {
      return;
    }

    final index = _favorites.indexWhere(
      (item) => item.id == product.id,
    );

    if (index < 0) {
      return;
    }

    _favorites.removeAt(index);

    unawaited(
      _removeFromServer(
        userId: userId,
        product: product,
      ),
    );
  }

  // ============================================================
  // TEMİZLE
  // ============================================================

  static void clear() {
    _favorites.clear();
    _isLoaded = false;
  }

  static bool get isLoaded => _isLoaded;
}