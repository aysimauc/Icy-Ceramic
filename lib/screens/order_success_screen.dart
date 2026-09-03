import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'order_history_screen.dart';

class OrderSuccessScreen
    extends StatelessWidget {
  final String orderNumber;
  final double total;

  const OrderSuccessScreen({
    super.key,
    required this.orderNumber,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,

      child: Scaffold(
        backgroundColor:
            const Color(0xFFF7F4EE),

        body: SafeArea(
          child: Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 30,
              ),

              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment
                        .center,

                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration:
                        const BoxDecoration(
                      color:
                          Color(0xFFEFE5DC),
                      shape:
                          BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color:
                          Color(0xFFA9826E),
                      size: 48,
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  const Text(
                    'Siparişin Alındı! 🤎',
                    textAlign:
                        TextAlign.center,
                    style: TextStyle(
                      color:
                          Color(0xFF383431),
                      fontSize: 24,
                      fontWeight:
                          FontWeight.w500,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  const Text(
                    'Siparişin başarıyla oluşturuldu.\nHazırlamaya başladığımızda seni bilgilendireceğiz.',
                    textAlign:
                        TextAlign.center,
                    style: TextStyle(
                      color:
                          Color(0xFF796C64),
                      fontSize: 12,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(
                    height: 28,
                  ),

                  Container(
                    width:
                        double.infinity,
                    padding:
                        const EdgeInsets
                            .all(18),
                    decoration:
                        BoxDecoration(
                      color:
                          const Color(
                        0xFFFBF9F5,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        18,
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
                        _infoRow(
                          'Sipariş No',
                          orderNumber,
                        ),

                        const SizedBox(
                          height: 12,
                        ),

                        _infoRow(
                          'Toplam',
                          '₺${total.toStringAsFixed(0)}',
                        ),

                        const SizedBox(
                          height: 12,
                        ),

                        _infoRow(
                          'Durum',
                          'Hazırlanıyor',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  // =========================================
                  // SİPARİŞLERİM
                  // =========================================

                  SizedBox(
                    width:
                        double.infinity,
                    height: 50,
                    child:
                        OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    const OrderHistoryScreen(),
                          ),
                        );
                      },
                      style:
                          OutlinedButton
                              .styleFrom(
                        foregroundColor:
                            const Color(
                          0xFFA9826E,
                        ),
                        side:
                            const BorderSide(
                          color:
                              Color(
                            0xFFC9A995,
                          ),
                        ),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            15,
                          ),
                        ),
                      ),
                      child:
                          const Text(
                        'Siparişlerimi Gör',
                        style:
                            TextStyle(
                          fontSize:
                              12,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  // =========================================
                  // ANA SAYFA
                  // =========================================

                  SizedBox(
                    width:
                        double.infinity,
                    height: 52,
                    child:
                        ElevatedButton(
                      onPressed: () {
                        Navigator
                            .pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    const HomeScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      style:
                          ElevatedButton
                              .styleFrom(
                        backgroundColor:
                            const Color(
                          0xFFC9A995,
                        ),
                        foregroundColor:
                            Colors.white,
                        elevation: 0,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            15,
                          ),
                        ),
                      ),
                      child:
                          const Text(
                        'Ana Sayfaya Dön',
                        style:
                            TextStyle(
                          fontSize:
                              13,
                          fontWeight:
                              FontWeight
                                  .w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(
    String title,
    String value,
  ) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment
              .spaceBetween,
      children: [
        Text(
          title,
          style:
              const TextStyle(
            color:
                Color(0xFF9B9189),
            fontSize: 11,
          ),
        ),

        Text(
          value,
          style:
              const TextStyle(
            color:
                Color(0xFF66564E),
            fontSize: 11,
            fontWeight:
                FontWeight.w500,
          ),
        ),
      ],
    );
  }
}