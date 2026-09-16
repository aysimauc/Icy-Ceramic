import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/admin_product_service.dart';
import '../services/product_api_service.dart';

class AdminStockScreen extends StatefulWidget {
  const AdminStockScreen({super.key});

  @override
  State<AdminStockScreen> createState() =>
      _AdminStockScreenState();
}

class _AdminStockScreenState
    extends State<AdminStockScreen> {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];

  bool _isLoading = true;
  String? _errorMessage;

  final TextEditingController _searchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    _searchController.addListener(
      _filterProducts,
    );

    _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final products =
          await ProductApiService.getProducts();

      if (!mounted) {
        return;
      }

      setState(() {
        _products = products;
        _filteredProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage =
            'Ürünler yüklenemedi.';
      });
    }
  }

  void _filterProducts() {
    final query =
        _searchController.text.trim().toLowerCase();

    setState(() {
      if (query.isEmpty) {
        _filteredProducts = _products;
        return;
      }

      _filteredProducts = _products.where((product) {
        return product.name
                .toLowerCase()
                .contains(query) ||
            product.category
                .toLowerCase()
                .contains(query);
      }).toList();
    });
  }

  Future<void> _editStock(
    Product product,
  ) async {
    final controller =
        TextEditingController(
      text: product.stock.toString(),
    );

    final newStock =
        await showDialog<int>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor:
              const Color(0xFFFBF9F5),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(18),
          ),
          title: Text(
            'Stok Güncelle',
            style: const TextStyle(
              color: Color(0xFF383431),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          content: Column(
            mainAxisSize:
                MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: const TextStyle(
                  color: Color(0xFF66564E),
                  fontSize: 13,
                  fontWeight:
                      FontWeight.w500,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: controller,
                autofocus: true,
                keyboardType:
                    TextInputType.number,
                decoration:
                    InputDecoration(
                  labelText:
                      'Yeni stok miktarı',
                  hintText: 'Örn. 25',
                  filled: true,
                  fillColor:
                      const Color(0xFFF7F4EE),
                  labelStyle:
                      const TextStyle(
                    color:
                        Color(0xFF8B827B),
                    fontSize: 12,
                  ),
                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                      12,
                    ),
                    borderSide:
                        const BorderSide(
                      color:
                          Color(0xFFE5DED4),
                    ),
                  ),
                  enabledBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                      12,
                    ),
                    borderSide:
                        const BorderSide(
                      color:
                          Color(0xFFE5DED4),
                    ),
                  ),
                  focusedBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                      12,
                    ),
                    borderSide:
                        const BorderSide(
                      color:
                          Color(0xFFC9A995),
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child: const Text(
                'Vazgeç',
                style: TextStyle(
                  color:
                      Color(0xFF8B827B),
                  fontSize: 12,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final value =
                    int.tryParse(
                  controller.text.trim(),
                );

                if (value == null ||
                    value < 0) {
                  ScaffoldMessenger.of(
                    dialogContext,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Geçerli bir stok miktarı girin.',
                      ),
                    ),
                  );
                  return;
                }

                Navigator.pop(
                  dialogContext,
                  value,
                );
              },
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFFC9A995),
                foregroundColor:
                    Colors.white,
                elevation: 0,
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    10,
                  ),
                ),
              ),
              child: const Text(
                'Güncelle',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (newStock == null ||
        newStock == product.stock) {
      return;
    }

    await _updateStock(
      product,
      newStock,
    );
  }

  Future<void> _changeStock(
    Product product,
    int amount,
  ) async {
    final newStock =
        product.stock + amount;

    if (newStock < 0) {
      return;
    }

    await _updateStock(
      product,
      newStock,
    );
  }

  Future<void> _updateStock(
    Product product,
    int newStock,
  ) async {
    try {
      await AdminProductService.updateStock(
        productId: int.parse(product.id),
        stock: newStock,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            backgroundColor:
                const Color(0xFF66564E),
            content: Text(
              '${product.name} stok miktarı $newStock olarak güncellendi.',
              style: const TextStyle(
                fontSize: 11,
              ),
            ),
            duration:
                const Duration(seconds: 2),
          ),
        );

      await _loadProducts();
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            backgroundColor:
                const Color(0xFF66564E),
            content: Text(
              e.toString().replaceFirst(
                    'Exception: ',
                    '',
                  ),
              style: const TextStyle(
                fontSize: 11,
              ),
            ),
            duration:
                const Duration(seconds: 3),
          ),
        );
    }
  }

  Color _stockColor(int stock) {
    if (stock <= 0) {
      return const Color(0xFF9B5C55);
    }

    if (stock <= 5) {
      return const Color(0xFFA9826E);
    }

    return const Color(0xFF6F806D);
  }

  String _stockText(int stock) {
    if (stock <= 0) {
      return 'Stokta yok';
    }

    if (stock <= 5) {
      return 'Kritik stok';
    }

    return 'Stok yeterli';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF7F4EE),
      appBar: AppBar(
        backgroundColor:
            const Color(0xFFF7F4EE),
        elevation: 0,
        centerTitle: false,
        title: const Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              'Stok Yönetimi',
              style: TextStyle(
                color: Color(0xFF383431),
                fontSize: 20,
                fontWeight:
                    FontWeight.w400,
              ),
            ),
            Text(
              'ÜRÜN STOKLARINI YÖNET',
              style: TextStyle(
                color: Color(0xFF8B827B),
                fontSize: 7,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _loadProducts,
            tooltip: 'Yenile',
            icon: const Icon(
              Icons.refresh_outlined,
              color: Color(0xFF66564E),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        color:
            const Color(0xFFC9A995),
        onRefresh: _loadProducts,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFFC9A995),
        ),
      );
    }

    if (_errorMessage != null) {
      return ListView(
        physics:
            const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 150),
          Center(
            child: Column(
              children: [
                const Icon(
                  Icons.cloud_off_outlined,
                  color:
                      Color(0xFFA9826E),
                  size: 42,
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  _errorMessage!,
                  style:
                      const TextStyle(
                    color:
                        Color(0xFF383431),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed:
                      _loadProducts,
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(
                      0xFFC9A995,
                    ),
                    foregroundColor:
                        Colors.white,
                    elevation: 0,
                  ),
                  child:
                      const Text(
                    'Tekrar Dene',
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return ListView(
      padding:
          const EdgeInsets.fromLTRB(
        20,
        12,
        20,
        30,
      ),
      physics:
          const AlwaysScrollableScrollPhysics(
        parent:
            BouncingScrollPhysics(),
      ),
      children: [
        _buildSummaryCard(),
        const SizedBox(height: 18),
        _buildSearchField(),
        const SizedBox(height: 18),
        if (_filteredProducts.isEmpty)
          _buildEmptyState()
        else
          ..._filteredProducts.map(
            _buildProductCard,
          ),
      ],
    );
  }

  Widget _buildSummaryCard() {
    final totalStock =
        _products.fold<int>(
      0,
      (total, product) =>
          total + product.stock,
    );

    final criticalCount =
        _products.where(
      (product) =>
          product.stock > 0 &&
          product.stock <= 5,
    ).length;

    final outOfStock =
        _products.where(
      (product) =>
          product.stock <= 0,
    ).length;

    return Container(
      padding:
          const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color:
            const Color(0xFFFBF9F5),
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color:
              const Color(0xFFE5DED4),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryItem(
              Icons.inventory_2_outlined,
              'Toplam',
              '$totalStock',
            ),
          ),
          Container(
            height: 42,
            width: 1,
            color:
                const Color(0xFFE5DED4),
          ),
          Expanded(
            child: _buildSummaryItem(
              Icons.warning_amber_outlined,
              'Kritik',
              '$criticalCount',
            ),
          ),
          Container(
            height: 42,
            width: 1,
            color:
                const Color(0xFFE5DED4),
          ),
          Expanded(
            child: _buildSummaryItem(
              Icons.remove_shopping_cart_outlined,
              'Yok',
              '$outOfStock',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    IconData icon,
    String title,
    String value,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color:
              const Color(0xFFA9826E),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            color:
                Color(0xFF383431),
            fontSize: 18,
            fontWeight:
                FontWeight.w500,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            color:
                Color(0xFF8B827B),
            fontSize: 9,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller:
          _searchController,
      decoration:
          InputDecoration(
        hintText:
            'Ürün veya kategori ara...',
        hintStyle:
            const TextStyle(
          color:
              Color(0xFFB0A69E),
          fontSize: 12,
        ),
        prefixIcon:
            const Icon(
          Icons.search,
          color:
              Color(0xFFA9826E),
          size: 20,
        ),
        suffixIcon:
            _searchController
                    .text
                    .isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _searchController
                          .clear();
                    },
                    icon:
                        const Icon(
                      Icons.close,
                      color:
                          Color(0xFF8B827B),
                      size: 18,
                    ),
                  )
                : null,
        filled: true,
        fillColor:
            const Color(0xFFFBF9F5),
        border:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            14,
          ),
          borderSide:
              const BorderSide(
            color:
                Color(0xFFE5DED4),
          ),
        ),
        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            14,
          ),
          borderSide:
              const BorderSide(
            color:
                Color(0xFFE5DED4),
          ),
        ),
        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            14,
          ),
          borderSide:
              const BorderSide(
            color:
                Color(0xFFC9A995),
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(
    Product product,
  ) {
    final stockColor =
        _stockColor(product.stock);

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),
      padding:
          const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color:
            const Color(0xFFFBF9F5),
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color:
              const Color(0xFFE5DED4),
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius:
                BorderRadius.circular(
              12,
            ),
            child: Image.asset(
              product.image,
              width: 68,
              height: 68,
              fit: BoxFit.cover,
              errorBuilder:
                  (
                context,
                error,
                stackTrace,
              ) {
                return Container(
                  width: 68,
                  height: 68,
                  color:
                      const Color(
                    0xFFF0E7DF,
                  ),
                  child:
                      const Icon(
                    Icons
                        .image_not_supported_outlined,
                    color:
                        Color(0xFFA9826E),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow:
                      TextOverflow.ellipsis,
                  style:
                      const TextStyle(
                    color:
                        Color(0xFF383431),
                    fontSize: 13,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  product.category,
                  style:
                      const TextStyle(
                    color:
                        Color(0xFF8B827B),
                    fontSize: 10,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 7,
                        vertical: 4,
                      ),
                      decoration:
                          BoxDecoration(
                        color:
                            stockColor.withOpacity(
                          0.10,
                        ),
                        borderRadius:
                            BorderRadius
                                .circular(
                          8,
                        ),
                      ),
                      child: Text(
                        _stockText(
                          product.stock,
                        ),
                        style:
                            TextStyle(
                          color:
                              stockColor,
                          fontSize: 9,
                          fontWeight:
                              FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              Text(
                '${product.stock}',
                style:
                    TextStyle(
                  color:
                      stockColor,
                  fontSize: 22,
                  fontWeight:
                      FontWeight.w500,
                ),
              ),
              const Text(
                'adet',
                style: TextStyle(
                  color:
                      Color(0xFF8B827B),
                  fontSize: 9,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  _buildSmallButton(
                    icon: Icons.remove,
                    onPressed:
                        product.stock > 0
                            ? () =>
                                _changeStock(
                                  product,
                                  -1,
                                )
                            : null,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  _buildSmallButton(
                    icon: Icons.add,
                    onPressed:
                        () =>
                            _changeStock(
                              product,
                              1,
                            ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              TextButton(
                onPressed: () =>
                    _editStock(
                  product,
                ),
                style:
                    TextButton.styleFrom(
                  minimumSize:
                      const Size(
                    0,
                    28,
                  ),
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 6,
                  ),
                  tapTargetSize:
                      MaterialTapTargetSize
                          .shrinkWrap,
                ),
                child:
                    const Text(
                  'Düzenle',
                  style:
                      TextStyle(
                    color:
                        Color(0xFFA9826E),
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: 30,
      height: 30,
      child: IconButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        icon: Icon(
          icon,
          size: 16,
        ),
        color:
            const Color(0xFF66564E),
        style: IconButton.styleFrom(
          backgroundColor:
              const Color(0xFFF0E7DF),
          disabledForegroundColor:
              const Color(0xFFD0C7C0),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        vertical: 50,
      ),
      child: const Column(
        children: [
          Icon(
            Icons.search_off_outlined,
            color: Color(0xFFA9826E),
            size: 40,
          ),
          SizedBox(height: 12),
          Text(
            'Ürün bulunamadı.',
            style: TextStyle(
              color: Color(0xFF383431),
              fontSize: 14,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Arama kriterinizi değiştirmeyi deneyin.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF8B827B),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}