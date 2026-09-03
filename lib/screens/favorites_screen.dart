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
  void openProductDetail(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ProductDetailScreen(
          product: product,
        ),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  void removeFavorite(Product product) {
    FavoriteService.removeFavorite(
      product,
    );

    setState(() {});
  }

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
            size: 18,
          ),
        ),

        title: const Text(
          'Favorilerim',
          style: TextStyle(
            color: Color(0xFF383431),
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),

      body: favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration:
                        const BoxDecoration(
                      color: Color(0xFFEFE5DC),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      color: Color(0xFFA9826E),
                      size: 30,
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'Henüz favorin yok',
                    style: TextStyle(
                      color: Color(0xFF66564E),
                      fontSize: 16,
                      fontWeight:
                          FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Beğendiğin ürünleri burada\nsaklayabilirsin.',
                    textAlign:
                        TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF9B9189),
                      fontSize: 11,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding:
                  const EdgeInsets.fromLTRB(
                20,
                8,
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

              itemCount: favorites.length,

              itemBuilder:
                  (context, index) {
                final product =
                    favorites[index];

                return GestureDetector(
                  onTap: () {
                    openProductDetail(
                      product,
                    );
                  },

                  child: Container(
                    decoration:
                        BoxDecoration(
                      color:
                          const Color(
                        0xFFFBF9F5,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        16,
                      ),
                      border: Border.all(
                        color:
                            const Color(
                          0xFFE5DED4,
                        ),
                      ),
                    ),

                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius
                                        .vertical(
                                  top:
                                      Radius.circular(
                                    16,
                                  ),
                                ),
                                child:
                                    Image.asset(
                                  product.image,
                                  width:
                                      double.infinity,
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
                                        child:
                                            Icon(
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

                            Padding(
                              padding:
                                  const EdgeInsets
                                      .all(11),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  Text(
                                    product.name,
                                    maxLines: 2,
                                    overflow:
                                        TextOverflow
                                            .ellipsis,
                                    style:
                                        const TextStyle(
                                      color:
                                          Color(
                                        0xFF66564E,
                                      ),
                                      fontSize: 12,
                                      fontWeight:
                                          FontWeight
                                              .w500,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 6,
                                  ),

                                  Text(
                                    product.category,
                                    style:
                                        const TextStyle(
                                      color:
                                          Color(
                                        0xFF9B9189,
                                      ),
                                      fontSize: 9,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 6,
                                  ),

                                  Text(
                                    '₺${product.price.toStringAsFixed(0)}',
                                    style:
                                        const TextStyle(
                                      color:
                                          Color(
                                        0xFFA9826E,
                                      ),
                                      fontSize: 13,
                                      fontWeight:
                                          FontWeight
                                              .w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        Positioned(
                          top: 8,
                          right: 8,
                          child: Material(
                            color: const Color(
                              0xFFFBF9F5,
                            ),
                            shape:
                                const CircleBorder(),
                            child: IconButton(
                              onPressed: () {
                                removeFavorite(
                                  product,
                                );
                              },
                              icon:
                                  const Icon(
                                Icons.favorite,
                                color: Color(
                                  0xFFA9826E,
                                ),
                                size: 18,
                              ),
                              constraints:
                                  const BoxConstraints(
                                minWidth: 36,
                                minHeight: 36,
                              ),
                              padding:
                                  EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}