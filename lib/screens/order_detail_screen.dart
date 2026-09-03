import 'package:flutter/material.dart';
import '../services/order_service.dart';

class OrderDetailScreen
    extends StatelessWidget {
  final String orderNumber;

  const OrderDetailScreen({
    super.key,
    required this.orderNumber,
  });

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

  int statusIndex(
    String status,
  ) {
    switch (status) {
      case 'Sipariş Alındı':
        return 0;

      case 'Hazırlanıyor':
        return 1;

      case 'Kargoya Verildi':
        return 2;

      case 'Teslim Edildi':
        return 3;

      default:
        return 1;
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final order =
        OrderService.getOrder(
      orderNumber,
    );

    if (order == null) {
      return Scaffold(
        backgroundColor:
            const Color(0xFFF7F4EE),

        appBar: AppBar(
          backgroundColor:
              const Color(0xFFF7F4EE),
          elevation: 0,
          title:
              const Text(
            'Sipariş Detayı',
            style: TextStyle(
              color:
                  Color(0xFF383431),
              fontSize: 18,
            ),
          ),
        ),

        body: const Center(
          child: Text(
            'Sipariş bulunamadı.',
            style: TextStyle(
              color:
                  Color(0xFF796C64),
            ),
          ),
        ),
      );
    }

    final currentIndex =
        statusIndex(
      order.status,
    );

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

      body: ListView(
        padding:
            const EdgeInsets.fromLTRB(
          20,
          8,
          20,
          30,
        ),
        physics:
            const BouncingScrollPhysics(),

        children: [
          // =================================================
          // SİPARİŞ NUMARASI
          // =================================================

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
                        order.orderNumber,
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
                      '₺${order.total.toStringAsFixed(0)}',
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

          // =================================================
          // SİPARİŞ DURUMU
          // =================================================

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
                  completed:
                      false,
                  isLast: true,
                ),
              ],
            ),
          ),

          // =================================================
          // KARGO BİLGİLERİ
          // =================================================

          if (order.status ==
                  'Kargoya Verildi' ||
              order.status ==
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
                    order.cargoCompany ??
                        'Belirtilmedi',
                    Icons
                        .local_shipping_outlined,
                  ),

                  const SizedBox(
                    height: 13,
                  ),

                  _detailRow(
                    'Takip Numarası',
                    order.trackingNumber ??
                        'Henüz oluşturulmadı',
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

          // =================================================
          // TESLİMAT BİLGİLERİ
          // =================================================

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
                    order.date,
                  ),
                  Icons
                      .calendar_today_outlined,
                ),

                const SizedBox(
                  height: 13,
                ),

                _detailRow(
                  'Ödeme',
                  order.paymentMethod,
                  Icons
                      .credit_card_outlined,
                ),

                const SizedBox(
                  height: 13,
                ),

                _detailRow(
                  'Adres',
                  order.address,
                  Icons
                      .location_on_outlined,
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 24,
          ),

          // =================================================
          // MEVCUT DURUM
          // =================================================

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
                        order.status,
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
    );
  }

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
                  style: TextStyle(
                    color: active
                        ? const Color(
                            0xFF66564E,
                          )
                        : const Color(
                            0xFFB0A69E,
                          ),
                    fontSize: 12,
                    fontWeight:
                        active
                            ? FontWeight.w500
                            : FontWeight.w400,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  subtitle,
                  style: TextStyle(
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
                CrossAxisAlignment
                    .start,
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