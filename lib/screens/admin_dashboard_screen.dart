import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/cart_service.dart';
import '../services/product_api_service.dart';
import 'admin_stock_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState
    extends State<AdminDashboardScreen> {
  List<Product> _products = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
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
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage =
            'Dashboard verileri yüklenemedi.';
      });
    }
  }

  int get _totalStock {
    return _products.fold(
      0,
      (total, product) =>
          total + product.stock,
    );
  }

  int get _outOfStockCount {
    return _products
        .where(
          (product) => product.stock <= 0,
        )
        .length;
  }

  int get _lowStockCount {
    return _products
        .where(
          (product) =>
              product.stock > 0 &&
              product.stock <= 5,
        )
        .length;
  }

  int get _categoryCount {
    return _products
        .map(
          (product) => product.category,
        )
        .toSet()
        .length;
  }

  void _goToStore() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const HomeScreen(),
      ),
    );
  }

  void _goToStockManagement() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const AdminStockScreen(),
      ),
    ).then((_) {
      if (mounted) {
        _loadDashboard();
      }
    });
  }

  void _logout() {
    CartService.clearLocal();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const LoginScreen(),
      ),
      (route) => false,
    );
  }

  void _showLogoutDialog() {
    showDialog<void>(
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
          title: const Text(
            'Çıkış Yap',
            style: TextStyle(
              color: Color(0xFF383431),
              fontSize: 18,
              fontWeight:
                  FontWeight.w500,
            ),
          ),
          content: const Text(
            'Yönetim panelinden çıkış yapmak istediğinize emin misiniz?',
            style: TextStyle(
              color: Color(0xFF8B827B),
              fontSize: 12,
              height: 1.4,
            ),
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
                Navigator.pop(
                  dialogContext,
                );
                _logout();
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
                'Çıkış Yap',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ],
        );
      },
    );
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
              'ICY',
              style: TextStyle(
                color: Color(0xFF66564E),
                fontSize: 24,
                fontStyle:
                    FontStyle.italic,
                fontWeight:
                    FontWeight.w400,
                letterSpacing: 1,
              ),
            ),
            Text(
              'YÖNETİM PANELİ',
              style: TextStyle(
                color: Color(0xFF8B827B),
                fontSize: 8,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _loadDashboard,
            tooltip: 'Yenile',
            icon: const Icon(
              Icons.refresh_outlined,
              color: Color(0xFF66564E),
            ),
          ),
          const SizedBox(width: 2),
          IconButton(
            onPressed:
                _showLogoutDialog,
            tooltip: 'Çıkış Yap',
            icon: const Icon(
              Icons.logout_outlined,
              color: Color(0xFF66564E),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        color:
            const Color(0xFFC9A995),
        onRefresh: _loadDashboard,
        child: SingleChildScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(
            parent:
                BouncingScrollPhysics(),
          ),
          padding:
              const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            30,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                'Hoş Geldiniz 👋',
                style: TextStyle(
                  color:
                      Color(0xFF383431),
                  fontSize: 25,
                  fontWeight:
                      FontWeight.w400,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Mağazanızın genel durumunu buradan takip edebilirsiniz.',
                style: TextStyle(
                  color:
                      Color(0xFF8B827B),
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(
                      vertical: 40,
                    ),
                    child:
                        CircularProgressIndicator(
                      color:
                          Color(0xFFC9A995),
                    ),
                  ),
                )
              else if (_errorMessage != null)
                _buildErrorCard()
              else ...[
                _buildStatistics(),
                const SizedBox(height: 28),
                const Text(
                  'Yönetim',
                  style: TextStyle(
                    color:
                        Color(0xFF383431),
                    fontSize: 19,
                    fontWeight:
                        FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 14),
                _buildManagementCard(
                  icon: Icons
                      .inventory_2_outlined,
                  title: 'Ürünler',
                  description:
                      'Mağazadaki ürünleri ve ürün bilgilerini görüntüleyin.',
                  value:
                      '${_products.length} ürün',
                  onTap: () {
                    _showComingSoon(
                      'Ürün Yönetimi',
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildManagementCard(
                  icon: Icons
                      .warehouse_outlined,
                  title: 'Stok Yönetimi',
                  description:
                      'Ürün stoklarını görüntüleyin ve stok miktarlarını güncelleyin.',
                  value:
                      '$_totalStock adet stok',
                  onTap:
                      _goToStockManagement,
                ),
                const SizedBox(height: 12),
                _buildManagementCard(
                  icon: Icons
                      .receipt_long_outlined,
                  title: 'Siparişler',
                  description:
                      'Müşteri siparişlerinin yönetileceği bölüm.',
                  value: 'Yakında',
                  onTap: () {
                    _showComingSoon(
                      'Sipariş Yönetimi',
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildManagementCard(
                  icon: Icons.people_outline,
                  title: 'Kullanıcılar',
                  description:
                      'Müşteri hesapları ve kullanıcı bilgileri.',
                  value: 'Yakında',
                  onTap: () {
                    _showComingSoon(
                      'Kullanıcı Yönetimi',
                    );
                  },
                ),
                const SizedBox(height: 28),
                const Text(
                  'Stok Durumu',
                  style: TextStyle(
                    color:
                        Color(0xFF383431),
                    fontSize: 19,
                    fontWeight:
                        FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 14),
                _buildStockStatusCard(),
                const SizedBox(height: 28),
                _buildStoreButton(),
                const SizedBox(height: 12),
                _buildLogoutButton(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatistics() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.55,
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(),
      children: [
        _buildStatCard(
          icon:
              Icons.shopping_bag_outlined,
          title: 'Ürün',
          value:
              '${_products.length}',
        ),
        _buildStatCard(
          icon:
              Icons.category_outlined,
          title: 'Kategori',
          value:
              '$_categoryCount',
        ),
        _buildStatCard(
          icon:
              Icons.inventory_2_outlined,
          title: 'Toplam Stok',
          value:
              '$_totalStock',
        ),
        _buildStatCard(
          icon:
              Icons.warning_amber_outlined,
          title: 'Kritik Stok',
          value:
              '$_lowStockCount',
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
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
      padding:
          const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            icon,
            size: 22,
            color:
                const Color(0xFFA9826E),
          ),
          Text(
            value,
            style: const TextStyle(
              color:
                  Color(0xFF383431),
              fontSize: 23,
              fontWeight:
                  FontWeight.w500,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color:
                  Color(0xFF8B827B),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManagementCard({
    required IconData icon,
    required String title,
    required String description,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding:
            const EdgeInsets.all(16),
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
            Container(
              width: 48,
              height: 48,
              decoration:
                  BoxDecoration(
                color:
                    const Color(0xFFF0E7DF),
                borderRadius:
                    BorderRadius.circular(
                  14,
                ),
              ),
              child: Icon(
                icon,
                color:
                    const Color(0xFFA9826E),
                size: 23,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style:
                        const TextStyle(
                      color:
                          Color(0xFF383431),
                      fontSize: 14,
                      fontWeight:
                          FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    description,
                    style:
                        const TextStyle(
                      color:
                          Color(0xFF8B827B),
                      fontSize: 10,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              value,
              style:
                  const TextStyle(
                color:
                    Color(0xFFA9826E),
                fontSize: 10,
                fontWeight:
                    FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right,
              color:
                  Color(0xFFB0A69E),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockStatusCard() {
    return Container(
      width: double.infinity,
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
      child: Column(
        children: [
          _buildStockRow(
            icon:
                Icons.inventory_2_outlined,
            title: 'Toplam stok',
            value:
                '$_totalStock adet',
          ),
          const Divider(
            color:
                Color(0xFFE5DED4),
            height: 24,
          ),
          _buildStockRow(
            icon:
                Icons.warning_amber_outlined,
            title: 'Kritik stok',
            value:
                '$_lowStockCount ürün',
          ),
          const Divider(
            color:
                Color(0xFFE5DED4),
            height: 24,
          ),
          _buildStockRow(
            icon: Icons
                .remove_shopping_cart_outlined,
            title: 'Stokta olmayan',
            value:
                '$_outOfStockCount ürün',
          ),
        ],
      ),
    );
  }

  Widget _buildStockRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color:
              const Color(0xFFA9826E),
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style:
                const TextStyle(
              color:
                  Color(0xFF66564E),
              fontSize: 12,
            ),
          ),
        ),
        Text(
          value,
          style:
              const TextStyle(
            color:
                Color(0xFF383431),
            fontSize: 12,
            fontWeight:
                FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStoreButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: _goToStore,
        icon: const Icon(
          Icons.storefront_outlined,
          size: 20,
        ),
        label: const Text(
          'Mağazaya Git',
          style: TextStyle(
            fontSize: 13,
            fontWeight:
                FontWeight.w500,
          ),
        ),
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
                BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton.icon(
        onPressed:
            _showLogoutDialog,
        icon: const Icon(
          Icons.logout_outlined,
          size: 19,
        ),
        label: const Text(
          'Çıkış Yap',
          style: TextStyle(
            fontSize: 12,
            fontWeight:
                FontWeight.w500,
          ),
        ),
        style:
            OutlinedButton.styleFrom(
          foregroundColor:
              const Color(0xFF66564E),
          side: const BorderSide(
            color:
                Color(0xFFC9A995),
          ),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Container(
      width: double.infinity,
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
      child: Column(
        children: [
          const Icon(
            Icons.cloud_off_outlined,
            color:
                Color(0xFFA9826E),
            size: 40,
          ),
          const SizedBox(height: 12),
          Text(
            _errorMessage ??
                'Veriler yüklenemedi.',
            textAlign:
                TextAlign.center,
            style:
                const TextStyle(
              color:
                  Color(0xFF383431),
              fontSize: 14,
              fontWeight:
                  FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed:
                _loadDashboard,
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
              'Tekrar Dene',
              style:
                  TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(
    String title,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor:
              const Color(0xFF66564E),
          content: Text(
            '$title bölümü bir sonraki adımda bağlanacak.',
            style:
                const TextStyle(
              fontSize: 11,
            ),
          ),
          duration:
              const Duration(seconds: 2),
        ),
      );
  }
}