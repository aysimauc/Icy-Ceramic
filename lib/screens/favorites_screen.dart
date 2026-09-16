import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/favorite_service.dart';
import 'product_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({
    super.key,
  });

  @override
  State<FavoritesScreen> createState() =>
      _FavoritesScreenState();
}

class _FavoritesScreenState
    extends State<FavoritesScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  // ============================================================
  // FAVORİLERİ YÜKLE
  // ============================================================

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
    });

    await FavoriteService.loadFavorites();

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = false;
    });
  }

  // ============================================================
  // ÜRÜN DETAY
  // ============================================================

  Future<void> _openProductDetail(
    Product product,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ProductDetailScreen(
          product: product,
        ),
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  // ============================================================
  // FAVORİDEN ÇIKAR
  // ============================================================

  void _removeFavorite(Product product) {
    FavoriteService.removeFavorite(product);

    setState(() {});

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor:
              const Color(0xFF66564E),
          content: Text(
            '${product.name} favorilerden çıkarıldı.',
            style: const TextStyle(
              fontSize: 11,
            ),
          ),
          duration:
              const Duration(seconds: 2),
        ),
      );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final favorites =
        FavoriteService.favorites;

    return Scaffold(
      backgroundColor:
          const Color(0xFFF7F4EE),

      appBar: AppBar(
        backgroundColor:
            const Color(0xFFF7F4EE),
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF66564E),
            size: 19,
          ),
        ),

        title: const Text(
          'Favorilerim',
          style: TextStyle(
            color: Color(0xFF383431),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFC9A995),
                  strokeWidth: 2,
                ),
              )
            : favorites.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
                    color:
                        const Color(0xFFA9826E),
                    backgroundColor:
                        const Color(0xFFFBF9F5),
                    onRefresh:
                        _loadFavorites,
                    child: GridView.builder(
                      physics:
                          const BouncingScrollPhysics(
                        parent:
                            AlwaysScrollableScrollPhysics(),
                      ),
                      padding:
                          const EdgeInsets.fromLTRB(
                        20,
                        16,
                        20,
                        30,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 18,
                        childAspectRatio: 0.68,
                      ),
                      itemCount:
                          favorites.length,
                      itemBuilder:
                          (context, index) {
                        final product =
                            favorites[index];

                        return _buildProductCard(
                          product,
                        );
                      },
                    ),
                  ),
      ),
    );
  }

  // ============================================================
  // BOŞ FAVORİLER
  // ============================================================

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 40,
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 78,
              height: 78,
              decoration:
                  const BoxDecoration(
                color: Color(0xFFEFE5DC),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border,
                color: Color(0xFFA9826E),
                size: 34,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Henüz favorin yok',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF383431),
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Beğendiğin ürünleri kalp simgesine '
              'dokunarak favorilerine ekleyebilirsin.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF9B9189),
                fontSize: 11,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ÜRÜN KARTI
  // ============================================================

  Widget _buildProductCard(
    Product product,
  ) {
    return GestureDetector(
      onTap: () {
        _openProductDetail(product);
      },

      child: Container(
        decoration:
            BoxDecoration(
          color: const Color(0xFFFBF9F5),
          borderRadius:
              BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFE5DED4),
          ),
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(
                        top: Radius.circular(18),
                      ),
                      child: Image.asset(
                        product.image,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (
                          context,
                          error,
                          stackTrace,
                        ) {
                          return Container(
                            color:
                                const Color(
                              0xFFF1ECE4,
                            ),
                            child:
                                const Center(
                              child: Icon(
                                Icons
                                    .image_not_supported_outlined,
                                color:
                                    Color(
                                  0xFFB0A69E,
                                ),
                                size: 30,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  Positioned(
                    top: 9,
                    right: 9,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration:
                          const BoxDecoration(
                        color:
                            Color(0xFFF7F4EE),
                        shape:
                            BoxShape.circle,
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          _removeFavorite(
                            product,
                          );
                        },
                        icon: const Icon(
                          Icons.favorite,
                          color:
                              Color(0xFFA9826E),
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                12,
                12,
                12,
                13,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    product.category
                        .toUpperCase(),
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style:
                        const TextStyle(
                      color:
                          Color(0xFF9B9189),
                      fontSize: 8,
                      letterSpacing: 1,
                      fontWeight:
                          FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    product.name,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style:
                        const TextStyle(
                      color:
                          Color(0xFF383431),
                      fontSize: 12,
                      height: 1.3,
                      fontWeight:
                          FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    '₺${product.price.toStringAsFixed(0)}',
                    style:
                        const TextStyle(
                      color:
                          Color(0xFFA9826E),
                      fontSize: 14,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}