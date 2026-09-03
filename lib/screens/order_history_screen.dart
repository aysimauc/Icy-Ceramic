import 'package:flutter/material.dart';
import '../services/order_service.dart';
import 'order_detail_screen.dart';

class OrderHistoryScreen
    extends StatelessWidget {
  const OrderHistoryScreen({
    super.key,
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

  @override
  Widget build(
    BuildContext context,
  ) {
    final orders =
        OrderService.orders;

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

      body: orders.isEmpty
          ? _emptyOrders()
          : ListView.builder(
              padding:
                  const EdgeInsets.fromLTRB(
                20,
                10,
                20,
                24,
              ),
              physics:
                  const BouncingScrollPhysics(),
              itemCount:
                  orders.length,
              itemBuilder:
                  (context, index) {
                final order =
                    orders[index];

                return _orderCard(
                  context,
                  order,
                );
              },
            ),
    );
  }

  Widget _orderCard(
    BuildContext context,
    OrderRecord order,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                OrderDetailScreen(
              orderNumber:
                  order.orderNumber,
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
                        order.orderNumber,
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
                        formatDate(
                          order.date,
                        ),
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
                  '₺${order.total.toStringAsFixed(0)}',
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
                  _statusIcon(
                    order.status,
                  ),
                  color:
                      _statusColor(
                    order.status,
                  ),
                  size: 15,
                ),

                const SizedBox(
                  width: 6,
                ),

                Text(
                  order.status,
                  style:
                      TextStyle(
                    color:
                        _statusColor(
                      order.status,
                    ),
                    fontSize: 10,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),

                const Spacer(),

                Text(
                  order.paymentMethod,
                  style:
                      const TextStyle(
                    color:
                        Color(0xFF9B9189),
                    fontSize: 9,
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
                    order.address,
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

  IconData _statusIcon(
    String status,
  ) {
    switch (status) {
      case 'Kargoya Verildi':
        return Icons.local_shipping_outlined;

      case 'Teslim Edildi':
        return Icons.check_circle_outline;

      case 'Hazırlanıyor':
        return Icons.inventory_2_outlined;

      default:
        return Icons.schedule_outlined;
    }
  }

  Color _statusColor(
    String status,
  ) {
    switch (status) {
      case 'Kargoya Verildi':
        return const Color(0xFF9B806D);

      case 'Teslim Edildi':
        return const Color(0xFF8A9A7B);

      case 'Hazırlanıyor':
        return const Color(0xFFA9826E);

      default:
        return const Color(0xFF9B9189);
    }
  }

  Widget _emptyOrders() {
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
    );
  }
}