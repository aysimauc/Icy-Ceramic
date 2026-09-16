import 'package:flutter/material.dart';

import '../services/auth_session_service.dart';
import '../services/order_api_service.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderNumber;

  const OrderDetailScreen({
    super.key,
    required this.orderNumber,
  });

  @override
  State<OrderDetailScreen> createState() =>
      _OrderDetailScreenState();
}

class _OrderDetailScreenState
    extends State<OrderDetailScreen> {
  Map<String, dynamic>? _order;

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadOrder();
  }

  // ============================================================
  // SİPARİŞİ API'DEN GETİR
  // ============================================================

  Future<void> _loadOrder() async {
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
              'Sipariş detayını görmek için giriş yapmalısın.';
        });
        return;
      }

      final orders =
          await OrderApiService.getUserOrders(userId);

      Map<String, dynamic>? foundOrder;

      for (final order in orders) {
        final number =
            order['orderNumber']?.toString() ??
                order['number']?.toString() ??
                order['id']?.toString();

        if (number == widget.orderNumber) {
          foundOrder = order;
          break;
        }
      }

      if (!mounted) {
        return;
      }

      if (foundOrder == null) {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'Sipariş bulunamadı.';
        });
        return;
      }

      setState(() {
        _order = foundOrder;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage =
            _cleanErrorMessage(e);
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

  DateTime _parseDate() {
    final order = _order;

    if (order == null) {
      return DateTime.now();
    }

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

  String _orderNumber() {
    final order = _order;

    if (order == null) {
      return widget.orderNumber;
    }

    return order['orderNumber']?.toString() ??
        order['number']?.toString() ??
        order['id']?.toString() ??
        widget.orderNumber;
  }

  // ============================================================
  // TOPLAM
  // ============================================================

  double _orderTotal() {
    final order = _order;

    if (order == null) {
      return 0;
    }

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

  String _orderStatus() {
    final order = _order;

    if (order == null) {
      return 'Hazırlanıyor';
    }

    return order['status']?.toString() ??
        'Hazırlanıyor';
  }

  // ============================================================
  // ÖDEME
  // ============================================================

  String _paymentMethod() {
    final order = _order;

    if (order == null) {
      return 'Belirtilmedi';
    }

    return order['paymentMethod']?.toString() ??
        'Belirtilmedi';
  }

  // ============================================================
  // ADRES
  // ============================================================

  String _address() {
    final order = _order;

    if (order == null) {
      return 'Belirtilmedi';
    }

    return order['address']?.toString() ??
        'Belirtilmedi';
  }

  // ============================================================
  // KARGO FİRMASI
  // ============================================================

  String _cargoCompany() {
    final order = _order;

    if (order == null) {
      return 'Belirtilmedi';
    }

    return order['cargoCompany']?.toString() ??
        'Belirtilmedi';
  }

  // ============================================================
  // TAKİP NUMARASI
  // ============================================================

  String _trackingNumber() {
    final order = _order;

    if (order == null) {
      return 'Henüz oluşturulmadı';
    }

    return order['trackingNumber']?.toString() ??
        'Henüz oluşturulmadı';
  }

  // ============================================================
  // DURUM INDEX
  // ============================================================

  int statusIndex(
    String status,
  ) {
    final normalized =
        status.trim().toLowerCase();

    if (normalized.contains(
      'sipariş alındı',
    )) {
      return 0;
    }

    if (normalized.contains(
      'hazırlanıyor',
    )) {
      return 1;
    }

    if (normalized.contains(
      'kargoya',
    )) {
      return 2;
    }

    if (normalized.contains(
      'teslim',
    )) {
      return 3;
    }

    return 1;
  }

  // ============================================================
  // EKRAN
  // ============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    if (_isLoading) {
      return _loadingScreen();
    }

    if (_errorMessage != null ||
        _order == null) {
      return _errorScreen();
    }

    return _buildOrderDetail();
  }

  // ============================================================
  // LOADING
  // ============================================================

  Widget _loadingScreen() {
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
          'Sipariş Detayı',
          style: TextStyle(
            color:
                Color(0xFF383431),
            fontSize: 18,
            fontWeight:
                FontWeight.w500,
          ),
        ),
      ),

      body: const Center(
        child: CircularProgressIndicator(
          color:
              Color(0xFFA9826E),
          strokeWidth: 2,
        ),
      ),
    );
  }

  // ============================================================
  // HATA EKRANI
  // ============================================================

  Widget _errorScreen() {
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
          'Sipariş Detayı',
          style: TextStyle(
            color:
                Color(0xFF383431),
            fontSize: 18,
            fontWeight:
                FontWeight.w500,
          ),
        ),
      ),

      body: Center(
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
                  Icons.receipt_long_outlined,
                  color:
                      Color(0xFFA9826E),
                  size: 34,
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              Text(
                _errorMessage ??
                    'Sipariş bulunamadı.',
                textAlign:
                    TextAlign.center,
                style:
                    const TextStyle(
                  color:
                      Color(0xFF66564E),
                  fontSize: 15,
                  height: 1.5,
                ),
              ),

              const SizedBox(
                height: 18,
              ),

              TextButton(
                onPressed:
                    _loadOrder,
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
      ),
    );
  }

  // ============================================================
  // SİPARİŞ DETAYI
  // ============================================================

  Widget _buildOrderDetail() {
    final orderNumber =
        _orderNumber();

    final total =
        _orderTotal();

    final status =
        _orderStatus();

    final paymentMethod =
        _paymentMethod();

    final address =
        _address();

    final cargoCompany =
        _cargoCompany();

    final trackingNumber =
        _trackingNumber();

    final currentIndex =
        statusIndex(status);

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
          'Sipariş Detayı',
          style: TextStyle(
            color:
                Color(0xFF383431),
            fontSize: 18,
            fontWeight:
                FontWeight.w500,
          ),
        ),
      ),

      body: RefreshIndicator(
        color:
            const Color(0xFFA9826E),
        backgroundColor:
            const Color(0xFFFBF9F5),
        onRefresh: _loadOrder,

        child: ListView(
          padding:
              const EdgeInsets.fromLTRB(
            20,
            8,
            20,
            30,
          ),

          physics:
              const AlwaysScrollableScrollPhysics(
            parent:
                BouncingScrollPhysics(),
          ),

          children: [
            // ==================================================
            // SİPARİŞ NUMARASI
            // ==================================================

            Container(
              padding:
                  const EdgeInsets.all(
                18,
              ),

              decoration:
                  BoxDecoration(
                color:
                    const Color(0xFFFBF9F5),
                borderRadius:
                    BorderRadius.circular(
                  18,
                ),
                border: Border.all(
                  color:
                      const Color(0xFFE5DED4),
                ),
              ),

              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,

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
                          .receipt_long_outlined,
                      color:
                          Color(0xFFA9826E),
                      size: 22,
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
                        const Text(
                          'Sipariş Numarası',
                          style:
                              TextStyle(
                            color:
                                Color(
                              0xFF9B9189,
                            ),
                            fontSize: 9,
                          ),
                        ),

                        const SizedBox(
                          height: 4,
                        ),

                        Text(
                          orderNumber,
                          style:
                              const TextStyle(
                            color:
                                Color(
                              0xFF66564E,
                            ),
                            fontSize: 13,
                            fontWeight:
                                FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .end,

                    children: [
                      const Text(
                        'Toplam',
                        style:
                            TextStyle(
                          color:
                              Color(
                            0xFF9B9189,
                          ),
                          fontSize: 9,
                        ),
                      ),

                      const SizedBox(
                        height: 4,
                      ),

                      Text(
                        '₺${total.toStringAsFixed(0)}',
                        style:
                            const TextStyle(
                          color:
                              Color(
                            0xFFA9826E,
                          ),
                          fontSize: 15,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 22,
            ),

            // ==================================================
            // SİPARİŞ DURUMU
            // ==================================================

            const Text(
              'Sipariş Durumu',
              style: TextStyle(
                color:
                    Color(0xFF383431),
                fontSize: 17,
                fontWeight:
                    FontWeight.w500,
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            Container(
              padding:
                  const EdgeInsets.fromLTRB(
                18,
                20,
                18,
                20,
              ),

              decoration:
                  BoxDecoration(
                color:
                    const Color(0xFFFBF9F5),
                borderRadius:
                    BorderRadius.circular(
                  18,
                ),
                border: Border.all(
                  color:
                      const Color(0xFFE5DED4),
                ),
              ),

              child: Column(
                children: [
                  _timelineItem(
                    title:
                        'Sipariş Alındı',
                    subtitle:
                        'Siparişin başarıyla oluşturuldu.',
                    icon:
                        Icons.check_rounded,
                    active:
                        currentIndex >= 0,
                    completed:
                        currentIndex > 0,
                    isLast: false,
                  ),

                  _timelineItem(
                    title:
                        'Hazırlanıyor',
                    subtitle:
                        'Siparişin özenle hazırlanıyor.',
                    icon:
                        Icons.inventory_2_outlined,
                    active:
                        currentIndex >= 1,
                    completed:
                        currentIndex > 1,
                    isLast: false,
                  ),

                  _timelineItem(
                    title:
                        'Kargoya Verildi',
                    subtitle:
                        'Siparişin kargo firmasına teslim edildi.',
                    icon:
                        Icons.local_shipping_outlined,
                    active:
                        currentIndex >= 2,
                    completed:
                        currentIndex > 2,
                    isLast: false,
                  ),

                  _timelineItem(
                    title:
                        'Teslim Edildi',
                    subtitle:
                        'Siparişin sana ulaştı.',
                    icon:
                        Icons.home_outlined,
                    active:
                        currentIndex >= 3,
                    completed: false,
                    isLast: true,
                  ),
                ],
              ),
            ),

            // ==================================================
            // KARGO BİLGİLERİ
            // ==================================================

            if (status ==
                    'Kargoya Verildi' ||
                status ==
                    'Teslim Edildi') ...[
              const SizedBox(
                height: 22,
              ),

              const Text(
                'Kargo Bilgileri',
                style: TextStyle(
                  color:
                      Color(0xFF383431),
                  fontSize: 17,
                  fontWeight:
                      FontWeight.w500,
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              Container(
                padding:
                    const EdgeInsets.all(
                  17,
                ),

                decoration:
                    BoxDecoration(
                  color:
                      const Color(
                    0xFFFBF9F5,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    17,
                  ),
                  border: Border.all(
                    color:
                        const Color(
                      0xFFE5DED4,
                    ),
                  ),
                ),

                child: Column(
                  children: [
                    _detailRow(
                      'Kargo Firması',
                      cargoCompany,
                      Icons
                          .local_shipping_outlined,
                    ),

                    const SizedBox(
                      height: 13,
                    ),

                    _detailRow(
                      'Takip Numarası',
                      trackingNumber,
                      Icons
                          .confirmation_number_outlined,
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(
              height: 22,
            ),

            // ==================================================
            // TESLİMAT BİLGİLERİ
            // ==================================================

            const Text(
              'Teslimat Bilgileri',
              style: TextStyle(
                color:
                    Color(0xFF383431),
                fontSize: 17,
                fontWeight:
                    FontWeight.w500,
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            Container(
              padding:
                  const EdgeInsets.all(
                17,
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
                  _detailRow(
                    'Sipariş Tarihi',
                    formatDate(
                      _parseDate(),
                    ),
                    Icons
                        .calendar_today_outlined,
                  ),

                  const SizedBox(
                    height: 13,
                  ),

                  _detailRow(
                    'Ödeme',
                    paymentMethod,
                    Icons
                        .credit_card_outlined,
                  ),

                  const SizedBox(
                    height: 13,
                  ),

                  _detailRow(
                    'Adres',
                    address,
                    Icons
                        .location_on_outlined,
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            // ==================================================
            // MEVCUT DURUM
            // ==================================================

            Container(
              padding:
                  const EdgeInsets.all(
                16,
              ),

              decoration:
                  BoxDecoration(
                color:
                    const Color(0xFFF1E9E1),
                borderRadius:
                    BorderRadius.circular(
                  16,
                ),
              ),

              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color:
                        Color(0xFFA9826E),
                    size: 20,
                  ),

                  const SizedBox(
                    width: 10,
                  ),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [
                        const Text(
                          'Güncel Durum',
                          style:
                              TextStyle(
                            color:
                                Color(
                              0xFF9B9189,
                            ),
                            fontSize: 9,
                          ),
                        ),

                        const SizedBox(
                          height: 3,
                        ),

                        Text(
                          status,
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
                      ],
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

  // ============================================================
  // ZAMAN ÇİZELGESİ
  // ============================================================

  Widget _timelineItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool active,
    required bool completed,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        SizedBox(
          width: 38,

          child: Column(
            children: [
              AnimatedContainer(
                duration:
                    const Duration(
                  milliseconds: 200,
                ),

                width: 34,
                height: 34,

                decoration:
                    BoxDecoration(
                  color: active
                      ? const Color(
                          0xFFEFE5DC,
                        )
                      : const Color(
                          0xFFF5F1EB,
                        ),
                  shape:
                      BoxShape.circle,
                  border: Border.all(
                    color: active
                        ? const Color(
                            0xFFC9A995,
                          )
                        : const Color(
                            0xFFE2DBD2,
                          ),
                  ),
                ),

                child: Icon(
                  completed
                      ? Icons.check_rounded
                      : icon,

                  color: active
                      ? const Color(
                          0xFFA9826E,
                        )
                      : const Color(
                          0xFFC1B8AF,
                        ),

                  size: 17,
                ),
              ),

              if (!isLast)
                Container(
                  width: 1,
                  height: 43,
                  color: active
                      ? const Color(
                          0xFFD8C6B8,
                        )
                      : const Color(
                          0xFFE5DED4,
                        ),
                ),
            ],
          ),
        ),

        const SizedBox(
          width: 10,
        ),

        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.only(
              top: 2,
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  title,
                  style:
                      TextStyle(
                    color: active
                        ? const Color(
                            0xFF66564E,
                          )
                        : const Color(
                            0xFFB0A69E,
                          ),
                    fontSize: 12,
                    fontWeight: active
                        ? FontWeight.w500
                        : FontWeight.w400,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  subtitle,
                  style:
                      TextStyle(
                    color: active
                        ? const Color(
                            0xFF9B9189,
                          )
                        : const Color(
                            0xFFC1B8AF,
                          ),
                    fontSize: 9,
                    height: 1.4,
                  ),
                ),

                SizedBox(
                  height:
                      isLast ? 0 : 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // DETAY SATIRI
  // ============================================================

  Widget _detailRow(
    String title,
    String value,
    IconData icon,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Container(
          width: 34,
          height: 34,

          decoration:
              const BoxDecoration(
            color:
                Color(0xFFEFE5DC),
            shape:
                BoxShape.circle,
          ),

          child: Icon(
            icon,
            color:
                const Color(0xFFA9826E),
            size: 17,
          ),
        ),

        const SizedBox(
          width: 10,
        ),

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
                      Color(0xFF9B9189),
                  fontSize: 9,
                ),
              ),

              const SizedBox(
                height: 3,
              ),

              Text(
                value,
                style:
                    const TextStyle(
                  color:
                      Color(0xFF66564E),
                  fontSize: 11,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}