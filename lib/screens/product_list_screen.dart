import 'package:flutter/material.dart';
import '../models/product_data.dart';
import '../models/product.dart';

class ProductListScreen extends StatefulWidget {
  final String initialCategory;

  const ProductListScreen({
    super.key,
    this.initialCategory = 'Tümü',
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late String selectedCategory;
  String searchText = '';

  // ============================================================
  // KATEGORİLER
  // ============================================================

  final List<String> categories = [
    'Tümü',
    'Kupa',
    'Tabak',
    'Anahtarlık',
    'Kase',
    'Biblo',
    'Tablo',
    'Kitap Ayracı',
    'Vazo',
  ];

  // ============================================================
  // BAŞLANGIÇ
  // ============================================================

  @override
  void initState() {
    super.initState();

    selectedCategory = categories.contains(widget.initialCategory)
        ? widget.initialCategory
        : 'Tümü';
  }

  // ============================================================
  // FİLTRELENMİŞ ÜRÜNLER
  // ============================================================

  List<Product> get filteredProducts {
    return products.where((product) {
      final categoryMatches =
          selectedCategory == 'Tümü' ||
          product.category == selectedCategory;

      final searchMatches = product.name
          .toLowerCase()
          .contains(searchText.toLowerCase());

      return categoryMatches && searchMatches;
    }).toList();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EE),

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F4EE),
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

        title: Text(
          selectedCategory == 'Tümü'
              ? 'Ürünler'
              : selectedCategory,
          style: const TextStyle(
            color: Color(0xFF383431),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SafeArea(
        child: Column(
          children: [

            // ==================================================
            // ARAMA
            // ==================================================

            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                8,
                20,
                16,
              ),
              child: Container(
                height: 46,

                decoration: BoxDecoration(
                  color: const Color(0xFFFBF9F5),
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    color: const Color(0xFFE5DED4),
                  ),
                ),

                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },

                  decoration: const InputDecoration(
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
                  ),
                ),
              ),
            ),

            // ==================================================
            // KATEGORİLER
            // ==================================================

            SizedBox(
              height: 38,

              child: ListView.builder(
                scrollDirection: Axis.horizontal,

                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),

                itemCount: categories.length,

                itemBuilder: (context, index) {
                  final category = categories[index];

                  final isSelected =
                      selectedCategory == category;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = category;
                      });
                    },

                    child: AnimatedContainer(
                      duration: const Duration(
                        milliseconds: 200,
                      ),

                      margin: const EdgeInsets.only(
                        right: 8,
                      ),

                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),

                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFC9A995)
                            : const Color(0xFFFBF9F5),

                        borderRadius:
                            BorderRadius.circular(20),

                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFFC9A995)
                              : const Color(0xFFE5DED4),
                        ),
                      ),

                      child: Center(
                        child: Text(
                          category,

                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF796C64),

                            fontSize: 10,

                            fontWeight: isSelected
                                ? FontWeight.w500
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 18),

            // ==================================================
            // ÜRÜNLER
            // ==================================================

            Expanded(
              child: filteredProducts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,

                        children: [
                          const Icon(
                            Icons.inventory_2_outlined,
                            color: Color(0xFFB0A69E),
                            size: 42,
                          ),

                          const SizedBox(height: 12),

                          Text(
                            selectedCategory == 'Tümü'
                                ? 'Henüz ürün bulunamadı.'
                                : '$selectedCategory kategorisinde ürün bulunamadı.',

                            textAlign: TextAlign.center,

                            style: const TextStyle(
                              color: Color(0xFF8B827B),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    )

                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        0,
                        20,
                        24,
                      ),

                      physics:
                          const BouncingScrollPhysics(),

                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,

                        crossAxisSpacing: 12,

                        mainAxisSpacing: 16,

                        childAspectRatio: 0.68,
                      ),

                      itemCount:
                          filteredProducts.length,

                      itemBuilder: (context, index) {
                        final product =
                            filteredProducts[index];

                        return _ProductCard(
                          product: product,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// ÜRÜN KARTI
// ============================================================

class _ProductCard extends StatelessWidget {
  final Product product;

  const _ProductCard({
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Ürün detay ekranını
        // daha sonra buraya bağlayacağız.
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

            // ==================================================
            // ÜRÜN GÖRSELİ
            // ==================================================

            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),

                child: Image.asset(
                  product.image,

                  width: double.infinity,

                  fit: BoxFit.cover,

                  // Görsel bulunamazsa uygulama çökmeyecek.
                  errorBuilder:
                      (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFFF1ECE4),

                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: Color(0xFFB0A69E),
                          size: 30,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // ==================================================
            // ÜRÜN BİLGİLERİ
            // ==================================================

            Padding(
              padding: const EdgeInsets.all(11),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  // ÜRÜN ADI
                  Text(
                    product.name,

                    maxLines: 2,

                    overflow:
                        TextOverflow.ellipsis,

                    style: const TextStyle(
                      color: Color(0xFF66564E),
                      fontSize: 12,
                      fontWeight:
                          FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // KATEGORİ
                  Text(
                    product.category,

                    style: const TextStyle(
                      color: Color(0xFF9B9189),
                      fontSize: 9,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // FİYAT
                  Text(
                    '₺${product.price.toStringAsFixed(0)}',

                    style: const TextStyle(
                      color: Color(0xFFA9826E),
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