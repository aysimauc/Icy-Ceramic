import 'package:flutter/material.dart';
import '../models/product_data.dart';
import '../models/product.dart';
import 'product_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Home ekranında öne çıkaracağımız ilk ürünler.
    final featuredProducts = products.take(4).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EE),

      // ─────────────────────────────────────
      // ALT NAVIGATION BAR
      // ─────────────────────────────────────

      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFFFBF9F5),
        indicatorColor: const Color(0xFFE9D9CC),

        selectedIndex: 0,

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),

          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view),
            label: 'Kategoriler',
          ),

          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag),
            label: 'Sepet',
          ),

          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),

      // ─────────────────────────────────────
      // HOME BODY
      // ─────────────────────────────────────

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          padding: const EdgeInsets.fromLTRB(
            20,
            18,
            20,
            24,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // ─────────────────────────────
              // ÜST BAR
              // ─────────────────────────────

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                children: [
                  const Text(
                    'Icy',

                    style: TextStyle(
                      color: Color(0xFF66564E),
                      fontSize: 26,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1,
                    ),
                  ),

                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},

                        icon: const Icon(
                          Icons.notifications_none,
                          color: Color(0xFF66564E),
                          size: 23,
                        ),
                      ),

                      IconButton(
                        onPressed: () {},

                        icon: const Icon(
                          Icons.shopping_bag_outlined,
                          color: Color(0xFF66564E),
                          size: 23,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 4),

              const Text(
                'POUR TOİ',

                style: TextStyle(
                  color: Color(0xFF8B827B),
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 22),

              // ─────────────────────────────
              // ARAMA
              // ─────────────────────────────

              Container(
                height: 48,

                decoration: BoxDecoration(
                  color: const Color(0xFFFBF9F5),

                  borderRadius:
                      BorderRadius.circular(14),

                  border: Border.all(
                    color: const Color(0xFFE5DED4),
                  ),
                ),

                child: const TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,

                    hintText: 'Ürün ara...',

                    hintStyle: TextStyle(
                      color: Color(0xFFB0A69E),
                      fontSize: 12,
                    ),

                    prefixIcon: Icon(
                      Icons.search,
                      color: Color(0xFF796C64),
                      size: 20,
                    ),

                    contentPadding:
                        EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ─────────────────────────────
              // KATEGORİLER
              // ─────────────────────────────

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                children: [
                  const Text(
                    'Kategoriler',

                    style: TextStyle(
                      color: Color(0xFF383431),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ProductListScreen(
                            initialCategory: 'Tümü',
                          ),
                        ),
                      );
                    },

                    child: const Text(
                      'Tümü',

                      style: TextStyle(
                        color: Color(0xFFA9826E),
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // ─────────────────────────────
              // KATEGORİ LİSTESİ
              // ─────────────────────────────

              SizedBox(
                height: 100,

                child: ListView(
                  scrollDirection: Axis.horizontal,

                  children: [
                    // KUPA
                    _categoryItem(
                      context: context,
                      imagePath:
                          'assets/categories/kupa.png',
                      title: 'Kupa',
                    ),

                    // TABAK
                    _categoryItem(
                      context: context,
                      imagePath:
                          'assets/categories/tabak.png',
                      title: 'Tabak',
                    ),

                    // ANAHTARLIK
                    _categoryItem(
                      context: context,
                      imagePath:
                          'assets/categories/anahtarlik.png',
                      title: 'Anahtarlık',
                    ),

                    // KASE
                    _categoryItem(
                      context: context,
                      imagePath:
                          'assets/categories/kase.png',
                      title: 'Kase',
                    ),

                    // BİBLO
                    _categoryItem(
                      context: context,
                      imagePath:
                          'assets/categories/biblo.png',
                      title: 'Biblo',
                    ),

                    // TABLO
                    _categoryItem(
                      context: context,
                      imagePath:
                          'assets/categories/tablo.png',
                      title: 'Tablo',
                    ),

                    // KİTAP AYRACI
                    _categoryItem(
                      context: context,
                      imagePath:
                          'assets/categories/kitap_ayraci.png',
                      title: 'Kitap Ayracı',
                    ),

                    // VAZO
                    _categoryItem(
                      context: context,
                      imagePath:
                          'assets/categories/vazo.png',
                      title: 'Vazo',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ─────────────────────────────
              // ÖNE ÇIKAN ÜRÜNLER
              // ─────────────────────────────

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                children: [
                  const Text(
                    'Öne Çıkanlar',

                    style: TextStyle(
                      color: Color(0xFF383431),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ProductListScreen(
                            initialCategory: 'Tümü',
                          ),
                        ),
                      );
                    },

                    child: const Text(
                      'Tümünü Gör',

                      style: TextStyle(
                        color: Color(0xFFA9826E),
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // ─────────────────────────────
              // GERÇEK ÜRÜNLER
              // ─────────────────────────────

              GridView.builder(
                shrinkWrap: true,

                physics:
                    const NeverScrollableScrollPhysics(),

                itemCount:
                    featuredProducts.length,

                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,

                  crossAxisSpacing: 12,

                  mainAxisSpacing: 16,

                  childAspectRatio: 0.70,
                ),

                itemBuilder: (
                  context,
                  index,
                ) {
                  final product =
                      featuredProducts[index];

                  return _productCard(
                    context: context,
                    product: product,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // KATEGORİ WIDGET'I
  // ─────────────────────────────────────────

  Widget _categoryItem({
    required BuildContext context,
    required String imagePath,
    required String title,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProductListScreen(
              initialCategory: title,
            ),
          ),
        );
      },

      child: Container(
        width: 78,

        margin: const EdgeInsets.only(
          right: 12,
        ),

        child: Column(
          children: [
            Container(
              width: 62,
              height: 62,

              decoration: BoxDecoration(
                color: const Color(0xFFFBF9F5),

                shape: BoxShape.circle,

                border: Border.all(
                  color: const Color(0xFFE5DED4),
                ),
              ),

              child: ClipOval(
                child: Image.asset(
                  imagePath,

                  fit: BoxFit.cover,

                  errorBuilder: (
                    context,
                    error,
                    stackTrace,
                  ) {
                    return const Icon(
                      Icons
                          .image_not_supported_outlined,

                      color:
                          Color(0xFFB0A69E),

                      size: 22,
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 7),

            Text(
              title,

              maxLines: 2,

              overflow:
                  TextOverflow.ellipsis,

              textAlign:
                  TextAlign.center,

              style: const TextStyle(
                color: Color(0xFF66564E),

                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // GERÇEK ÜRÜN KARTI
  // ─────────────────────────────────────────

  Widget _productCard({
    required BuildContext context,
    required Product product,
  }) {
    return GestureDetector(
      onTap: () {
        // Ürün detay ekranını
        // birazdan bağlayacağız.
      },

      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFBF9F5),

          borderRadius:
              BorderRadius.circular(16),

          border: Border.all(
            color: const Color(0xFFE5DED4),
          ),
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            // ─────────────────────────
            // ÜRÜN GÖRSELİ
            // ─────────────────────────

            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),

                child: SizedBox(
                  width: double.infinity,

                  child: Image.asset(
                    product.image,

                    fit: BoxFit.cover,

                    errorBuilder: (
                      context,
                      error,
                      stackTrace,
                    ) {
                      return Container(
                        color:
                            const Color(0xFFF1ECE4),

                        child: const Center(
                          child: Icon(
                            Icons
                                .image_not_supported_outlined,

                            color:
                                Color(0xFFB0A69E),

                            size: 30,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // ─────────────────────────
            // ÜRÜN BİLGİLERİ
            // ─────────────────────────

            Padding(
              padding:
                  const EdgeInsets.all(12),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(
                    product.name,

                    maxLines: 2,

                    overflow:
                        TextOverflow.ellipsis,

                    style: const TextStyle(
                      color:
                          Color(0xFF66564E),

                      fontSize: 12,

                      fontWeight:
                          FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    product.category,

                    style: const TextStyle(
                      color:
                          Color(0xFF9B9189),

                      fontSize: 9,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Text(
                    '₺${product.price.toStringAsFixed(0)}',

                    style: const TextStyle(
                      color:
                          Color(0xFFA9826E),

                      fontSize: 13,

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