import 'package:flutter/material.dart';

import '../services/admin_order_service.dart';

class AdminOrderDetailScreen extends StatefulWidget {
  final int orderId;

  const AdminOrderDetailScreen({
    super.key,
    required this.orderId,
  });

  @override
  State<AdminOrderDetailScreen> createState() =>
      _AdminOrderDetailScreenState();
}

class _AdminOrderDetailScreenState
    extends State<AdminOrderDetailScreen> {
  bool _isLoading = true;
  bool _isUpdating = false;

  String? _errorMessage;

  Map<String, dynamic>? _order;

  String _selectedStatus = 'Hazırlanıyor';

  final TextEditingController _cargoController =
      TextEditingController();

  final TextEditingController _trackingController =
      TextEditingController();

  final List<String> _statuses = [
    'Hazırlanıyor',
    'Kargoya Verildi',
    'Teslim Edildi',
    'İptal Edildi',
  ];

  @override
  void initState() {
    super.initState();
    _loadOrder();
  }

  @override
  void dispose() {
    _cargoController.dispose();
    _trackingController.dispose();
    super.dispose();
  }

  // ============================================================
  // SİPARİŞİ GETİR
  // ============================================================

  Future<void> _loadOrder() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final order =
          await AdminOrderService.getOrder(
        widget.orderId,
      );

      if (!mounted) return;

      final status =
          order['status']?.toString() ??
              'Hazırlanıyor';

      setState(() {
        _order = order;

        _selectedStatus =
            _statuses.contains(status)
                ? status
                : 'Hazırlanıyor';

        _cargoController.text =
            order['cargoCompany']
                    ?.toString() ??
                '';

        _trackingController.text =
            order['trackingNumber']
                    ?.toString() ??
                '';

        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;

        _errorMessage =
            e.toString().replaceFirst(
                  'Exception: ',
                  '',
                );
      });
    }
  }

  // ============================================================
  // SİPARİŞİ GÜNCELLE
  // ============================================================

  Future<void> _updateOrder() async {
    if (_order == null) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _isUpdating = true;
    });

    try {
      await AdminOrderService.updateOrderStatus(
        orderId: widget.orderId,
        status: _selectedStatus,
        cargoCompany:
            _cargoController.text.trim().isEmpty
                ? null
                : _cargoController.text.trim(),
        trackingNumber:
            _trackingController.text.trim().isEmpty
                ? null
                : _trackingController.text.trim(),
      );

      if (!mounted) return;

      setState(() {
        _isUpdating = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Sipariş başarıyla güncellendi.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isUpdating = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst(
                  'Exception: ',
                  '',
                ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  // ============================================================
  // FİYAT
  // ============================================================

  String _formatPrice(dynamic value) {
    final price =
        (value as num?)?.toDouble() ?? 0;

    return '${price.toStringAsFixed(2)} ₺';
  }

  // ============================================================
  // TARİH
  // ============================================================

  String _formatDate(dynamic value) {
    if (value == null) {
      return '-';
    }

    try {
      final date =
          DateTime.parse(
            value.toString(),
          ).toLocal();

      final day =
          date.day.toString().padLeft(2, '0');

      final month =
          date.month.toString().padLeft(2, '0');

      final year =
          date.year.toString();

      final hour =
          date.hour.toString().padLeft(2, '0');

      final minute =
          date.minute.toString().padLeft(2, '0');

      return '$day.$month.$year  $hour:$minute';
    } catch (_) {
      return value.toString();
    }
  }

  // ============================================================
  // DURUM RENGİ
  // ============================================================

  Color _statusColor(String status) {
    switch (status) {
      case 'Hazırlanıyor':
        return Colors.orange.shade700;

      case 'Kargoya Verildi':
        return Colors.blue.shade700;

      case 'Teslim Edildi':
        return Colors.green.shade700;

      case 'İptal Edildi':
        return Colors.red.shade700;

      default:
        return Colors.grey.shade700;
    }
  }

  // ============================================================
  // DURUM İKONU
  // ============================================================

  IconData _statusIcon(String status) {
    switch (status) {
      case 'Hazırlanıyor':
        return Icons.inventory_2_outlined;

      case 'Kargoya Verildi':
        return Icons.local_shipping_outlined;

      case 'Teslim Edildi':
        return Icons.check_circle_outline;

      case 'İptal Edildi':
        return Icons.cancel_outlined;

      default:
        return Icons.info_outline;
    }
  }

  // ============================================================
  // BİLGİ KARTI
  // ============================================================

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.brown.shade100,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: const Color(0xFF8B6F5A),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A3728),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }

  // ============================================================
  // SATIR
  // ============================================================

  Widget _buildInfoRow(
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A3728),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ÜRÜN SATIRI
  // ============================================================

  Widget _buildProductItem(
    Map<String, dynamic> item,
  ) {
    final productName =
        item['productName']?.toString() ??
            'Ürün';

    final quantity =
        (item['quantity'] as num?)?.toInt() ??
            0;

    final unitPrice =
        item['unitPrice'];

    final totalPrice =
        item['totalPrice'];

    return Container(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F7F2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.brown.shade100,
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.local_cafe_outlined,
              color: Colors.brown.shade500,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  maxLines: 2,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4A3728),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$quantity adet × ${_formatPrice(unitPrice)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _formatPrice(totalPrice),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A3728),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DURUM SEÇİMİ
  // ============================================================

  Widget _buildStatusSelector() {
    final statusColor =
        _statusColor(_selectedStatus);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: statusColor.withOpacity(0.25),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedStatus,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: statusColor,
          ),
          items: _statuses.map(
            (status) {
              return DropdownMenuItem<String>(
                value: status,
                child: Row(
                  children: [
                    Icon(
                      _statusIcon(status),
                      size: 20,
                      color: _statusColor(status),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color:
                            _statusColor(status),
                      ),
                    ),
                  ],
                ),
              );
            },
          ).toList(),
          onChanged: _isUpdating
              ? null
              : (value) {
                  if (value == null) return;

                  setState(() {
                    _selectedStatus = value;
                  });
                },
        ),
      ),
    );
  }

  // ============================================================
  // YÜKLENİYOR
  // ============================================================

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  // ============================================================
  // HATA
  // ============================================================

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 60,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 16),
            const Text(
              'Sipariş yüklenemedi.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ??
                  'Bilinmeyen bir hata oluştu.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _loadOrder,
              icon: const Icon(Icons.refresh),
              label: const Text('Tekrar Dene'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF8B6F5A),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ANA İÇERİK
  // ============================================================

  Widget _buildContent() {
    if (_order == null) {
      return const SizedBox();
    }

    final order = _order!;

    final orderNumber =
        order['orderNumber']?.toString() ?? '-';

    final userId =
        order['userId']?.toString() ?? '-';

    final address =
        order['address']?.toString() ?? '-';

    final paymentMethod =
        order['paymentMethod']?.toString() ?? '-';

    final status =
        order['status']?.toString() ?? '-';

    final total =
        order['total'];

    final createdAt =
        order['createdAt'];

    final items =
        order['items'] as List<dynamic>? ?? [];

    return RefreshIndicator(
      onRefresh: _loadOrder,
      child: ListView(
        physics:
            const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          16,
          10,
          16,
          35,
        ),
        children: [
          // ======================================================
          // SİPARİŞ BAŞLIĞI
          // ======================================================

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF8B6F5A),
              borderRadius:
                  BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sipariş',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  orderNumber,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      _statusIcon(status),
                      size: 18,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      status,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ======================================================
          // SİPARİŞ BİLGİLERİ
          // ======================================================

          _buildInfoCard(
            title: 'Sipariş Bilgileri',
            icon: Icons.receipt_long_outlined,
            child: Column(
              children: [
                _buildInfoRow(
                  'Sipariş No',
                  orderNumber,
                ),
                _buildInfoRow(
                  'Müşteri ID',
                  userId,
                ),
                _buildInfoRow(
                  'Sipariş Tarihi',
                  _formatDate(createdAt),
                ),
                _buildInfoRow(
                  'Ödeme',
                  paymentMethod,
                ),
                _buildInfoRow(
                  'Toplam',
                  _formatPrice(total),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ======================================================
          // ÜRÜNLER
          // ======================================================

          _buildInfoCard(
            title: 'Sipariş Ürünleri',
            icon: Icons.shopping_bag_outlined,
            child: Column(
              children: [
                if (items.isEmpty)
                  Text(
                    'Siparişte ürün bulunmuyor.',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  )
                else
                  ...items.map(
                    (item) =>
                        _buildProductItem(
                      Map<String, dynamic>.from(
                        item as Map,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ======================================================
          // TESLİMAT ADRESİ
          // ======================================================

          _buildInfoCard(
            title: 'Teslimat Adresi',
            icon: Icons.location_on_outlined,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F7F2),
                borderRadius:
                    BorderRadius.circular(14),
              ),
              child: Text(
                address,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Color(0xFF4A3728),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ======================================================
          // SİPARİŞ DURUMU
          // ======================================================

          _buildInfoCard(
            title: 'Sipariş Durumu',
            icon: Icons.sync_alt_rounded,
            child: _buildStatusSelector(),
          ),

          const SizedBox(height: 16),

          // ======================================================
          // KARGO
          // ======================================================

          _buildInfoCard(
            title: 'Kargo Bilgileri',
            icon: Icons.local_shipping_outlined,
            child: Column(
              children: [
                TextField(
                  controller: _cargoController,
                  enabled: !_isUpdating,
                  decoration: InputDecoration(
                    labelText: 'Kargo Firması',
                    hintText:
                        'Örn. Yurtiçi Kargo',
                    prefixIcon: const Icon(
                      Icons.local_shipping_outlined,
                    ),
                    filled: true,
                    fillColor:
                        const Color(0xFFF9F7F2),
                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        14,
                      ),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller:
                      _trackingController,
                  enabled: !_isUpdating,
                  decoration: InputDecoration(
                    labelText: 'Takip Numarası',
                    hintText:
                        'Örn. 123456789',
                    prefixIcon: const Icon(
                      Icons.qr_code_2_outlined,
                    ),
                    filled: true,
                    fillColor:
                        const Color(0xFFF9F7F2),
                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        14,
                      ),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // ======================================================
          // GÜNCELLE BUTONU
          // ======================================================

          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed:
                  _isUpdating
                      ? null
                      : _updateOrder,
              icon: _isUpdating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child:
                          CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.save_outlined,
                    ),
              label: Text(
                _isUpdating
                    ? 'Güncelleniyor...'
                    : 'Siparişi Güncelle',
              ),
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF8B6F5A),
                foregroundColor:
                    Colors.white,
                disabledBackgroundColor:
                    Colors.brown.shade200,
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                ),
                textStyle:
                    const TextStyle(
                  fontSize: 15,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF7F4EE),
      appBar: AppBar(
        title: const Text(
          'Sipariş Detayı',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor:
            const Color(0xFFF7F4EE),
        foregroundColor:
            const Color(0xFF4A3728),
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Yenile',
            onPressed:
                _isLoading ||
                        _isUpdating
                    ? null
                    : _loadOrder,
            icon: const Icon(
              Icons.refresh_rounded,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoading()
          : _errorMessage != null
              ? _buildError()
              : _buildContent(),
    );
  }
}