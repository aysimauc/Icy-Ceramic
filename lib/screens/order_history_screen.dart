import 'package:flutter/material.dart';

import '../services/auth_session_service.dart';
import '../services/order_api_service.dart';
import 'order_detail_screen.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({
    super.key,
  });

  @override
  State<OrderHistoryScreen> createState() =>
      _OrderHistoryScreenState();
}

class _OrderHistoryScreenState
    extends State<OrderHistoryScreen> {
  List<Map<String, dynamic>> _orders = [];

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  // ============================================================
  // SİPARİŞLERİ API'DEN GETİR
  // ============================================================

  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userId = AuthSessionService.userId;

      if (userId == null) {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'Siparişlerini görmek için giriş yapmalısın.';
        });
        return;
      }

      final orders =
          await OrderApiService.getUserOrders(userId);

      if (!mounted) {
        return;
      }

      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage = _cleanErrorMessage(e);
      });
    }
  }

  // ============================================================
  // HATA MESAJI
  // ============================================================

  String _cleanErrorMessage(Object error) {
    final message = error.toString();

    if (message.startsWith('Exception: ')) {
      return message.substring(
        'Exception: '.length,
      );
    }

    return message;
  }

  // ============================================================
  // TARİH
  // ============================================================

  DateTime _parseDate(
    Map<String, dynamic> order,
  ) {
    final value =
        order['date'] ??
        order['createdAt'] ??
        order['orderDate'];

    if (value == null) {
      return DateTime.now();
    }

    return DateTime.tryParse(
          value.toString(),
        ) ??
        DateTime.now();
  }

  String formatDate(
    DateTime date,
  ) {
    final day =
        date.day.toString().padLeft(
              2,
              '0',
            );

    final month =
        date.month.toString().padLeft(
              2,
              '0',
            );

    final year =
        date.year.toString();

    return '$day.$month.$year';
  }

  // ============================================================
  // SİPARİŞ NUMARASI
  // ============================================================

  String _orderNumber(
    Map<String, dynamic> order,
  ) {
    return order['orderNumber']?.toString() ??
        order['number']?.toString() ??
        order['id']?.toString() ??
        'Sipariş';
  }

  // ============================================================
  // TOPLAM
  // ============================================================

  double _orderTotal(
    Map<String, dynamic> order,
  ) {
    final value =
        order['total'] ??
        order['amount'] ??
        0;

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value.toString(),
        ) ??
        0;
  }

  // ============================================================
  // DURUM
  // ============================================================

  String _orderStatus(
    Map<String, dynamic> order,
  ) {
    return order['status']?.toString() ??
        'Hazırlanıyor';
  }

  // ============================================================
  // ÖDEME YÖNTEMİ
  // ============================================================

  String _paymentMethod(
    Map<String, dynamic> order,
  ) {
    return order['paymentMethod']?.toString() ??
        'Ödeme bilgisi yok';
  }

  // ============================================================
  // ADRES
  // ============================================================

  String _address(
    Map<String, dynamic> order,
  ) {
    return order['address']?.toString() ??
        'Adres bilgisi yok';
  }

  // ============================================================
  // EKRAN
  // ============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
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
            color:
                Color(0xFF66564E),
            size: 19,
          ),
        ),

        title: const Text(
          'Siparişlerim',
          style: TextStyle(
            color:
                Color(0xFF383431),
            fontSize: 18,
            fontWeight:
                FontWeight.w500,
          ),
        ),
      ),

      body: _buildBody(),
    );
  }

  // ============================================================
  // BODY
  // ============================================================

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFFA9826E),
          strokeWidth: 2,
        ),
      );
    }

    if (_errorMessage != null) {
      return _errorState();
    }

    if (_orders.isEmpty) {
      return _emptyOrders();
    }

    return RefreshIndicator(
      color: const Color(0xFFA9826E),
      backgroundColor:
          const Color(0xFFFBF9F5),
      onRefresh: _loadOrders,
      child: ListView.builder(
        padding:
            const EdgeInsets.fromLTRB(
          20,
          10,
          20,
          24,
        ),
        physics:
            const AlwaysScrollableScrollPhysics(
          parent:
              BouncingScrollPhysics(),
        ),
        itemCount:
            _orders.length,
        itemBuilder:
            (context, index) {
          final order =
              _orders[index];

          return _orderCard(
            context,
            order,
          );
        },
      ),
    );
  }

  // ============================================================
  // SİPARİŞ KARTI
  // ============================================================

  Widget _orderCard(
    BuildContext context,
    Map<String, dynamic> order,
  ) {
    final orderNumber =
        _orderNumber(order);

    final total =
        _orderTotal(order);

    final date =
        _parseDate(order);

    final status =
        _orderStatus(order);

    final paymentMethod =
        _paymentMethod(order);

    final address =
        _address(order);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                OrderDetailScreen(
              orderNumber:
                  orderNumber,
            ),
          ),
        );
      },

      child: Container(
        margin:
            const EdgeInsets.only(
          bottom: 12,
        ),

        padding:
            const EdgeInsets.all(
          16,
        ),

        decoration:
            BoxDecoration(
          color:
              const Color(0xFFFBF9F5),

          borderRadius:
              BorderRadius.circular(
            17,
          ),

          border: Border.all(
            color:
                const Color(0xFFE5DED4),
          ),
        ),

        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,

                  decoration:
                      const BoxDecoration(
                    color:
                        Color(0xFFEFE5DC),
                    shape:
                        BoxShape.circle,
                  ),

                  child:
                      const Icon(
                    Icons
                        .inventory_2_outlined,
                    color:
                        Color(0xFFA9826E),
                    size: 20,
                  ),
                ),

                const SizedBox(
                  width: 12,
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [
                      Text(
                        orderNumber,
                        style:
                            const TextStyle(
                          color:
                              Color(
                            0xFF66564E,
                          ),
                          fontSize: 12,
                          fontWeight:
                              FontWeight.w500,
                        ),
                      ),

                      const SizedBox(
                        height: 4,
                      ),

                      Text(
                        formatDate(date),
                        style:
                            const TextStyle(
                          color:
                              Color(
                            0xFF9B9189,
                          ),
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),

                Text(
                  '₺${total.toStringAsFixed(0)}',
                  style:
                      const TextStyle(
                    color:
                        Color(0xFFA9826E),
                    fontSize: 14,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),

                const SizedBox(
                  width: 5,
                ),

                const Icon(
                  Icons.chevron_right,
                  color:
                      Color(0xFFB0A69E),
                  size: 19,
                ),
              ],
            ),

            const Padding(
              padding:
                  EdgeInsets.symmetric(
                vertical: 13,
              ),
              child: Divider(
                color:
                    Color(0xFFE5DED4),
                height: 1,
              ),
            ),

            Row(
              children: [
                Icon(
                  _statusIcon(status),
                  color:
                      _statusColor(status),
                  size: 15,
                ),

                const SizedBox(
                  width: 6,
                ),

                Text(
                  status,
                  style:
                      TextStyle(
                    color:
                        _statusColor(
                      status,
                    ),
                    fontSize: 10,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),

                const Spacer(),

                Flexible(
                  child: Text(
                    paymentMethod,
                    textAlign:
                        TextAlign.right,
                    overflow:
                        TextOverflow.ellipsis,
                    style:
                        const TextStyle(
                      color:
                          Color(0xFF9B9189),
                      fontSize: 9,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 10,
            ),

            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color:
                      Color(0xFFB0A69E),
                  size: 14,
                ),

                const SizedBox(
                  width: 5,
                ),

                Expanded(
                  child: Text(
                    address,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style:
                        const TextStyle(
                      color:
                          Color(0xFF9B9189),
                      fontSize: 9,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 10,
            ),

            const Align(
              alignment:
                  Alignment.centerRight,

              child: Text(
                'Sipariş detayını görüntüle →',
                style: TextStyle(
                  color:
                      Color(0xFFA9826E),
                  fontSize: 9,
                  fontWeight:
                      FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // DURUM İKONU
  // ============================================================

  IconData _statusIcon(
    String status,
  ) {
    final normalized =
        status.trim().toLowerCase();

    if (normalized.contains('kargo')) {
      return Icons.local_shipping_outlined;
    }

    if (normalized.contains('teslim')) {
      return Icons.check_circle_outline;
    }

    if (normalized.contains('hazır')) {
      return Icons.inventory_2_outlined;
    }

    if (normalized.contains('iptal')) {
      return Icons.cancel_outlined;
    }

    return Icons.schedule_outlined;
  }

  // ============================================================
  // DURUM RENGİ
  // ============================================================

  Color _statusColor(
    String status,
  ) {
    final normalized =
        status.trim().toLowerCase();

    if (normalized.contains('kargo')) {
      return const Color(0xFF9B806D);
    }

    if (normalized.contains('teslim')) {
      return const Color(0xFF8A9A7B);
    }

    if (normalized.contains('hazır')) {
      return const Color(0xFFA9826E);
    }

    if (normalized.contains('iptal')) {
      return const Color(0xFFB07D72);
    }

    return const Color(0xFF9B9189);
  }

  // ============================================================
  // HATA EKRANI
  // ============================================================

  Widget _errorState() {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 40,
        ),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            Container(
              width: 76,
              height: 76,

              decoration:
                  const BoxDecoration(
                color:
                    Color(0xFFEFE5DC),
                shape:
                    BoxShape.circle,
              ),

              child: const Icon(
                Icons.cloud_off_outlined,
                color:
                    Color(0xFFA9826E),
                size: 34,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            const Text(
              'Siparişler yüklenemedi',
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                color:
                    Color(0xFF66564E),
                fontSize: 17,
                fontWeight:
                    FontWeight.w500,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              _errorMessage ??
                  'Bir hata oluştu.',
              textAlign:
                  TextAlign.center,
              style:
                  const TextStyle(
                color:
                    Color(0xFF9B9189),
                fontSize: 11,
                height: 1.5,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            TextButton(
              onPressed: _loadOrders,
              style:
                  TextButton.styleFrom(
                foregroundColor:
                    const Color(
                  0xFFA9826E,
                ),
              ),
              child: const Text(
                'Tekrar Dene',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight:
                      FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // BOŞ SİPARİŞ EKRANI
  // ============================================================

  Widget _emptyOrders() {
    return RefreshIndicator(
      color:
          const Color(0xFFA9826E),
      onRefresh: _loadOrders,

      child: ListView(
        physics:
            const AlwaysScrollableScrollPhysics(
          parent:
              BouncingScrollPhysics(),
        ),

        children: [
          SizedBox(
            height:
                MediaQuery.of(context)
                        .size
                        .height *
                    0.32,
          ),

          Padding(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 40,
            ),

            child: Column(
              children: [
                Container(
                  width: 76,
                  height: 76,

                  decoration:
                      const BoxDecoration(
                    color:
                        Color(0xFFEFE5DC),
                    shape:
                        BoxShape.circle,
                  ),

                  child:
                      const Icon(
                    Icons
                        .inventory_2_outlined,
                    color:
                        Color(0xFFA9826E),
                    size: 34,
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                const Text(
                  'Henüz siparişin yok',
                  style: TextStyle(
                    color:
                        Color(0xFF66564E),
                    fontSize: 17,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                const Text(
                  'Verdiğin siparişler burada\nlistelenecek.',
                  textAlign:
                      TextAlign.center,
                  style: TextStyle(
                    color:
                        Color(0xFF9B9189),
                    fontSize: 11,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}