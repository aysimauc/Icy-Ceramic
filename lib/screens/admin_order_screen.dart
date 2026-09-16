import 'package:flutter/material.dart';

import '../services/admin_order_service.dart';
import 'admin_order_detail_screen.dart';

class AdminOrderScreen extends StatefulWidget {
  const AdminOrderScreen({super.key});

  @override
  State<AdminOrderScreen> createState() =>
      _AdminOrderScreenState();
}

class _AdminOrderScreenState
    extends State<AdminOrderScreen> {
  bool _isLoading = true;
  String? _errorMessage;

  List<Map<String, dynamic>> _orders = [];

  String _selectedFilter = 'Tümü';

  final List<String> _filters = [
    'Tümü',
    'Hazırlanıyor',
    'Kargoya Verildi',
    'Teslim Edildi',
    'İptal Edildi',
  ];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  // ============================================================
  // SİPARİŞLERİ GETİR
  // ============================================================

  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final orders =
          await AdminOrderService.getAllOrders();

      if (!mounted) return;

      setState(() {
        _orders = orders;
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
  // FİLTRELENMİŞ SİPARİŞLER
  // ============================================================

  List<Map<String, dynamic>> get _filteredOrders {
    if (_selectedFilter == 'Tümü') {
      return _orders;
    }

    return _orders.where((order) {
      return order['status']?.toString() ==
          _selectedFilter;
    }).toList();
  }

  // ============================================================
  // RENK
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
          DateTime.parse(value.toString()).toLocal();

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
  // SİPARİŞ KARTI
  // ============================================================

  Widget _buildOrderCard(
    Map<String, dynamic> order,
  ) {
    final orderNumber =
        order['orderNumber']?.toString() ?? '-';

    final status =
        order['status']?.toString() ?? '-';

    final userId =
        order['userId']?.toString() ?? '-';

    final total =
        order['total'];

    final createdAt =
        order['createdAt'];

    final items =
        order['items'] as List<dynamic>? ?? [];

    final statusColor =
        _statusColor(status);

    return Card(
      margin: const EdgeInsets.only(
        bottom: 14,
      ),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(18),
        side: BorderSide(
          color: Colors.brown.shade100,
        ),
      ),
      child: InkWell(
        borderRadius:
            BorderRadius.circular(18),
        onTap: () async {
          final updated =
              await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  AdminOrderDetailScreen(
                orderId:
                    (order['id'] as num).toInt(),
              ),
            ),
          );

          if (updated == true) {
            _loadOrders();
          }
        },
        child: Padding(
          padding:
              const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // ------------------------------------------------
              // ÜST SATIR
              // ------------------------------------------------

              Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          orderNumber,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight:
                                FontWeight.bold,
                            color:
                                Color(0xFF4A3728),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Müşteri ID: $userId',
                          style:
                              TextStyle(
                            fontSize: 13,
                            color: Colors
                                .grey
                                .shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // DURUM
                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    decoration:
                        BoxDecoration(
                      color: statusColor
                          .withOpacity(0.10),
                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),
                    ),
                    child: Row(
                      mainAxisSize:
                          MainAxisSize.min,
                      children: [
                        Icon(
                          _statusIcon(status),
                          size: 16,
                          color:
                              statusColor,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          status,
                          style:
                              TextStyle(
                            fontSize: 12,
                            fontWeight:
                                FontWeight.w600,
                            color:
                                statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 16,
              ),

              // ------------------------------------------------
              // BİLGİLER
              // ------------------------------------------------

              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      Icons.shopping_bag_outlined,
                      '${items.length} ürün',
                    ),
                  ),
                  Expanded(
                    child: _buildInfoItem(
                      Icons.calendar_today_outlined,
                      _formatDate(
                        createdAt,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 14,
              ),

              Divider(
                height: 1,
                color:
                    Colors.brown.shade100,
              ),

              const SizedBox(
                height: 14,
              ),

              // ------------------------------------------------
              // ALT SATIR
              // ------------------------------------------------

              Row(
                children: [
                  const Text(
                    'Toplam',
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          Color(0xFF6B5A4A),
                    ),
                  ),

                  const Spacer(),

                  Text(
                    _formatPrice(total),
                    style:
                        const TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                      color:
                          Color(0xFF4A3728),
                    ),
                  ),

                  const SizedBox(
                    width: 10,
                  ),

                  Icon(
                    Icons
                        .arrow_forward_ios_rounded,
                    size: 15,
                    color:
                        Colors.brown.shade400,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // BİLGİ ELEMANI
  // ============================================================

  Widget _buildInfoItem(
    IconData icon,
    String text,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 17,
          color:
              Colors.brown.shade400,
        ),
        const SizedBox(
          width: 7,
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color:
                  Colors.grey.shade700,
            ),
            overflow:
                TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // FİLTRELER
  // ============================================================

  Widget _buildFilters() {
    return SizedBox(
      height: 45,
      child: ListView.separated(
        scrollDirection:
            Axis.horizontal,
        itemCount:
            _filters.length,
        separatorBuilder:
            (_, __) =>
                const SizedBox(width: 8),
        itemBuilder:
            (context, index) {
          final filter =
              _filters[index];

          final selected =
              _selectedFilter ==
                  filter;

          return ChoiceChip(
            label: Text(filter),
            selected: selected,
            onSelected: (_) {
              setState(() {
                _selectedFilter =
                    filter;
              });
            },
            selectedColor:
                const Color(0xFFC9A995),
            backgroundColor:
                Colors.white,
            labelStyle: TextStyle(
              fontSize: 12,
              fontWeight:
                  selected
                      ? FontWeight.w600
                      : FontWeight.normal,
              color: selected
                  ? Colors.white
                  : const Color(
                      0xFF5C4939,
                    ),
            ),
            side: BorderSide(
              color: selected
                  ? const Color(
                      0xFFC9A995,
                    )
                  : Colors.brown.shade100,
            ),
            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(
                14,
              ),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // BOŞ DURUM
  // ============================================================

  Widget _buildEmptyState() {
    String message;

    if (_selectedFilter == 'Tümü') {
      message =
          'Henüz sipariş bulunmuyor.';
    } else {
      message =
          '$_selectedFilter durumunda sipariş bulunmuyor.';
    }

    return Center(
      child: Padding(
        padding:
            const EdgeInsets.only(
          top: 80,
        ),
        child: Column(
          children: [
            Icon(
              Icons
                  .shopping_bag_outlined,
              size: 64,
              color:
                  Colors.brown.shade200,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              message,
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color:
                    Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HATA
  // ============================================================

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 60,
              color:
                  Colors.red.shade300,
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Siparişler yüklenemedi.',
              style: TextStyle(
                fontSize: 17,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              _errorMessage ??
                  'Bilinmeyen bir hata oluştu.',
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color:
                    Colors.grey.shade600,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(
              onPressed:
                  _loadOrders,
              icon: const Icon(
                Icons.refresh,
              ),
              label:
                  const Text('Tekrar Dene'),
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(
                  0xFF8B6F5A,
                ),
                foregroundColor:
                    Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final filteredOrders =
        _filteredOrders;

    return Scaffold(
      backgroundColor:
          const Color(0xFFF7F4EE),
      appBar: AppBar(
        title: const Text(
          'Sipariş Yönetimi',
          style: TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),
        backgroundColor:
            const Color(0xFFF7F4EE),
        foregroundColor:
            const Color(0xFF4A3728),
        elevation: 0,
        actions: [
          IconButton(
            tooltip:
                'Yenile',
            onPressed:
                _isLoading
                    ? null
                    : _loadOrders,
            icon:
                const Icon(
              Icons.refresh_rounded,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh:
            _loadOrders,
        child: _isLoading
            ? const Center(
                child:
                    CircularProgressIndicator(),
              )
            : _errorMessage != null
                ? _buildErrorState()
                : ListView(
                    physics:
                        const AlwaysScrollableScrollPhysics(),
                    padding:
                        const EdgeInsets.fromLTRB(
                      16,
                      8,
                      16,
                      30,
                    ),
                    children: [
                      // ------------------------------------------
                      // BAŞLIK
                      // ------------------------------------------

                      const Text(
                        'Siparişler',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight:
                              FontWeight.bold,
                          color:
                              Color(0xFF4A3728),
                        ),
                      ),

                      const SizedBox(
                        height: 6,
                      ),

                      Text(
                        '${_orders.length} toplam sipariş',
                        style:
                            TextStyle(
                          fontSize: 13,
                          color: Colors
                              .grey
                              .shade600,
                        ),
                      ),

                      const SizedBox(
                        height: 18,
                      ),

                      // ------------------------------------------
                      // FİLTRELER
                      // ------------------------------------------

                      _buildFilters(),

                      const SizedBox(
                        height: 20,
                      ),

                      // ------------------------------------------
                      // SİPARİŞLER
                      // ------------------------------------------

                      if (filteredOrders.isEmpty)
                        _buildEmptyState()
                      else
                        ...filteredOrders.map(
                          _buildOrderCard,
                        ),
                    ],
                  ),
      ),
    );
  }
}