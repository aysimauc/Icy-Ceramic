import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

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

                  borderRadius: BorderRadius.circular(14),

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

                    contentPadding: EdgeInsets.symmetric(
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
                    onPressed: () {},
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

              SizedBox(
                height: 92,

                child: ListView(
                  scrollDirection: Axis.horizontal,

                  children: [
                    _categoryItem(
                      icon: Icons.local_cafe_outlined,
                      title: 'Kupa',
                    ),

                    _categoryItem(
                      icon: Icons.auto_awesome,
                      title: 'Takı',
                    ),

                    _categoryItem(
                      icon: Icons.circle_outlined,
                      title: 'Tabak',
                    ),

                    _categoryItem(
                      icon: Icons.bookmark_border,
                      title: 'Ayraç',
                    ),

                    _categoryItem(
                      icon: Icons.photo_outlined,
                      title: 'Tablo',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

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
                    onPressed: () {},
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
              // ÜRÜN GRID
              // ─────────────────────────────

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Expanded(
                    child: _productCard(
                      imagePath: 'assets/tablo.png',
                      title: 'Çiçekli Seramik Tablo',
                      price: '₺890',
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _productPlaceholderCard(
                      title: 'Yakında',
                      subtitle: 'Yeni ürün',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // İkinci satır
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Expanded(
                    child: _productPlaceholderCard(
                      title: 'Yakında',
                      subtitle: 'Yeni koleksiyon',
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _productPlaceholderCard(
                      title: 'Yakında',
                      subtitle: 'El emeği ürün',
                    ),
                  ),
                ],
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
    required IconData icon,
    required String title,
  }) {
    return Container(
      width: 72,

      margin: const EdgeInsets.only(right: 12),

      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,

            decoration: BoxDecoration(
              color: const Color(0xFFFBF9F5),

              shape: BoxShape.circle,

              border: Border.all(
                color: const Color(0xFFE5DED4),
              ),
            ),

            child: Icon(
              icon,
              color: const Color(0xFF796C64),
              size: 23,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF66564E),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // GERÇEK ÜRÜN KARTI
  // ─────────────────────────────────────────

  Widget _productCard({
    required String imagePath,
    required String title,
    required String price,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFBF9F5),

        borderRadius: BorderRadius.circular(16),

        border: Border.all(
          color: const Color(0xFFE5DED4),
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),

            child: AspectRatio(
              aspectRatio: 1,

              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    color: Color(0xFF66564E),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  price,

                  style: const TextStyle(
                    color: Color(0xFFA9826E),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // GEÇİCİ ÜRÜN KARTI
  // ─────────────────────────────────────────

  Widget _productPlaceholderCard({
    required String title,
    required String subtitle,
  }) {
    return Container(
      height: 210,

      decoration: BoxDecoration(
        color: const Color(0xFFF1ECE4),

        borderRadius: BorderRadius.circular(16),

        border: Border.all(
          color: const Color(0xFFE5DED4),
        ),
      ),

      child: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            const Icon(
              Icons.spa_outlined,
              color: Color(0xFFC9A995),
              size: 28,
            ),

            const SizedBox(height: 10),

            Text(
              title,

              style: const TextStyle(
                color: Color(0xFF66564E),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              subtitle,

              style: const TextStyle(
                color: Color(0xFF9B9189),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}