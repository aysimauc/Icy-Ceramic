import 'package:flutter/material.dart';
import '../models/product_data.dart';
import '../models/product.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() =>
      _ProductListScreenState();
}

class _ProductListScreenState
    extends State<ProductListScreen> {
  String selectedCategory = 'Tümü';
  String searchText = '';

  final List<String> categories = [
    'Tümü',
    'Kupa',
    'Takı',
    'Tabak',
    'Ayraç',
    'Tablo',
  ];

  List<Product> get filteredProducts {
    return products.where((product) {
      final categoryMatches =
          selectedCategory == 'Tümü' ||
          product.category == selectedCategory;

      final searchMatches =
          product.name
              .toLowerCase()
              .contains(searchText.toLowerCase());

      return categoryMatches && searchMatches;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EE),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F4EE),
        elevation: 0,

        centerTitle: true,

        title: const Text(
          'Ürünler',
          style: TextStyle(
            color: Color(0xFF383431),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            // ─────────────────────────
            // ARAMA
            // ─────────────────────────

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

                  borderRadius:
                      BorderRadius.circular(13),

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

            // ─────────────────────────
            // KATEGORİLER
            // ─────────────────────────

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
                      duration:
                          const Duration(milliseconds: 200),

                      margin: const EdgeInsets.only(
                        right: 8,
                      ),

                      padding:
                          const EdgeInsets.symmetric(
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

                            fontWeight:
                                isSelected
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

            // ─────────────────────────
            // ÜRÜNLER
            // ─────────────────────────

            Expanded(
              child: filteredProducts.isEmpty
                  ? const Center(
                      child: Text(
                        'Aradığınız ürün bulunamadı.',
                        style: TextStyle(
                          color: Color(0xFF8B827B),
                          fontSize: 12,
                        ),
                      ),
                    )
                  : GridView.builder(
                      padding:
                          const EdgeInsets.fromLTRB(
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

                      itemCount: filteredProducts.length,

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

// ─────────────────────────────────────
// ÜRÜN KARTI
// ─────────────────────────────────────

class _ProductCard extends StatelessWidget {
  final Product product;

  const _ProductCard({
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Product Detail ekranını
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
            // Ürün görseli
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
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(11),

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
                      color: Color(0xFF66564E),
                      fontSize: 12,
                      fontWeight:
                          FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 6),

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
