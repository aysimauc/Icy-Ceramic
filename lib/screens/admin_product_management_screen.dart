import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/admin_product_management_service.dart';
import '../services/product_api_service.dart';

class AdminProductManagementScreen extends StatefulWidget {
  const AdminProductManagementScreen({super.key});

  @override
  State<AdminProductManagementScreen> createState() =>
      _AdminProductManagementScreenState();
}

class _AdminProductManagementScreenState
    extends State<AdminProductManagementScreen> {
  List<Product> _products = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final products = await ProductApiService.getProducts();

      if (!mounted) return;

      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage =
            'Ürünler yüklenemedi. Backend bağlantısını kontrol edin.';
      });
    }
  }

  List<Product> get _filteredProducts {
    final query = _searchText.trim().toLowerCase();

    if (query.isEmpty) return _products;

    return _products.where((product) {
      return product.name.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> _showEditProductDialog(Product product) async {
    final nameController = TextEditingController(text: product.name);
    final priceController = TextEditingController(
      text: product.price.toStringAsFixed(2),
    );
    final descriptionController =
        TextEditingController(text: product.description);
    final imageController = TextEditingController(text: product.image);

    String? errorText;
    bool isSaving = false;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future<void> save() async {
              final name = nameController.text.trim();
              final price = double.tryParse(
                priceController.text.trim().replaceAll(',', '.'),
              );
              final description = descriptionController.text.trim();
              final image = imageController.text.trim();

              if (name.isEmpty) {
                setDialogState(() {
                  errorText = 'Ürün adı boş bırakılamaz.';
                });
                return;
              }

              if (price == null || price < 0) {
                setDialogState(() {
                  errorText = 'Geçerli bir fiyat girin.';
                });
                return;
              }

              if (image.isEmpty) {
                setDialogState(() {
                  errorText = 'Ürün görsel yolu boş bırakılamaz.';
                });
                return;
              }

              setDialogState(() {
                isSaving = true;
                errorText = null;
              });

              try {
                await AdminProductManagementService.updateProduct(
                  productId: int.parse(product.id),
                  name: name,
                  price: price,
                  description: description,
                  image: image,
                );

                if (!mounted) return;

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      backgroundColor: Color(0xFF66564E),
                      content: Text(
                        'Ürün bilgileri başarıyla güncellendi.',
                        style: TextStyle(fontSize: 11),
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  );

                await _loadProducts();
              } catch (e) {
                setDialogState(() {
                  isSaving = false;
                  errorText = e.toString().replaceFirst(
                        'Exception: ',
                        '',
                      );
                });
              }
            }

            return AlertDialog(
              backgroundColor: const Color(0xFFFBF9F5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              title: const Text(
                'Ürünü Düzenle',
                style: TextStyle(
                  color: Color(0xFF383431),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildField(
                      controller: nameController,
                      label: 'Ürün adı',
                      enabled: !isSaving,
                    ),
                    const SizedBox(height: 12),
                    _buildField(
                      controller: priceController,
                      label: 'Fiyat',
                      keyboardType:
                          const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      enabled: !isSaving,
                    ),
                    const SizedBox(height: 12),
                    _buildField(
                      controller: descriptionController,
                      label: 'Açıklama',
                      maxLines: 4,
                      enabled: !isSaving,
                    ),
                    const SizedBox(height: 12),
                    _buildField(
                      controller: imageController,
                      label: 'Görsel yolu',
                      enabled: !isSaving,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Kategori: ${product.category}',
                      style: const TextStyle(
                        color: Color(0xFF8B827B),
                        fontSize: 11,
                      ),
                    ),
                    if (errorText != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        errorText!,
                        style: const TextStyle(
                          color: Color(0xFF9B6257),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSaving
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: const Text(
                    'Vazgeç',
                    style: TextStyle(
                      color: Color(0xFF8B827B),
                      fontSize: 12,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: isSaving ? null : save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC9A995),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Kaydet',
                          style: TextStyle(fontSize: 12),
                        ),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    imageController.dispose();
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required bool enabled,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: Color(0xFF383431),
        fontSize: 13,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Color(0xFF8B827B),
          fontSize: 12,
        ),
        filled: true,
        fillColor: const Color(0xFFF7F4EE),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5DED4)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5DED4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFC9A995)),
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF9F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5DED4)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              product.image,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 72,
                  height: 72,
                  color: const Color(0xFFF0E7DF),
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    color: Color(0xFFA9826E),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF383431),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  product.category,
                  style: const TextStyle(
                    color: Color(0xFF8B827B),
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${product.price.toStringAsFixed(2)} ₺',
                  style: const TextStyle(
                    color: Color(0xFFA9826E),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'Düzenle',
            onPressed: () => _showEditProductDialog(product),
            icon: const Icon(
              Icons.edit_outlined,
              color: Color(0xFF66564E),
              size: 21,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = _filteredProducts;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F4EE),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF66564E),
            size: 19,
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ürün Yönetimi',
              style: TextStyle(
                color: Color(0xFF383431),
                fontSize: 21,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              'ÜRÜN BİLGİLERİNİ YÖNET',
              style: TextStyle(
                color: Color(0xFF8B827B),
                fontSize: 7,
                letterSpacing: 1.6,
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
          const SizedBox(width: 6),
        ],
      ),
      body: RefreshIndicator(
        color: const Color(0xFFC9A995),
        onRefresh: _loadProducts,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFC9A995),
                  ),
                )
              : _errorMessage != null
                  ? _buildErrorState()
                  : Column(
                      children: [
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              _searchText = value;
                            });
                          },
                          style: const TextStyle(
                            color: Color(0xFF383431),
                            fontSize: 13,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Ürün veya kategori ara...',
                            hintStyle: const TextStyle(
                              color: Color(0xFFB0A69E),
                              fontSize: 12,
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Color(0xFFA9826E),
                              size: 20,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFFBF9F5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: Color(0xFFE5DED4),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: Color(0xFFE5DED4),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: Color(0xFFC9A995),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: products.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Ürün bulunamadı.',
                                    style: TextStyle(
                                      color: Color(0xFF8B827B),
                                      fontSize: 13,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(
                                    parent: BouncingScrollPhysics(),
                                  ),
                                  itemCount: products.length,
                                  itemBuilder: (context, index) {
                                    return _buildProductCard(
                                      products[index],
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 100),
        const Icon(
          Icons.cloud_off_outlined,
          color: Color(0xFFA9826E),
          size: 42,
        ),
        const SizedBox(height: 12),
        Text(
          _errorMessage ?? 'Ürünler yüklenemedi.',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF383431),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: ElevatedButton(
            onPressed: _loadProducts,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC9A995),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Tekrar Dene',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}
