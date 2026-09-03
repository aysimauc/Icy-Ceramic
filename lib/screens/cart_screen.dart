import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import '../services/coupon_service.dart';
import '../models/product.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({
    super.key,
  });

  @override
  State<CartScreen> createState() =>
      _CartScreenState();
}

class _CartScreenState
    extends State<CartScreen> {
  final TextEditingController
      couponController =
      TextEditingController();

  String? couponMessage;
  bool couponError = false;

  @override
  void dispose() {
    couponController.dispose();
    super.dispose();
  }

  void applyCoupon() {
    final code =
        couponController.text.trim();

    if (code.isEmpty) {
      setState(() {
        couponMessage =
            'Lütfen bir kupon kodu gir.';
        couponError = true;
      });

      return;
    }

    final success =
        CouponService.applyCoupon(code);

    setState(() {
      if (success) {
        couponMessage =
            '$code kuponu uygulandı. 🎉';
        couponError = false;
      } else {
        couponMessage =
            'Geçersiz kupon kodu.';
        couponError = true;
      }
    });
  }

  void removeCoupon() {
    CouponService.removeCoupon();

    couponController.clear();

    setState(() {
      couponMessage = null;
      couponError = false;
    });
  }

  void refresh() {
    setState(() {});
  }

  void openCheckout() {
    if (CartService.items.isEmpty) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const CheckoutScreen(),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = CartService.items;

    final subtotal =
        CartService.totalPrice;

    final discount =
        CouponService.calculateDiscount(
      subtotal,
    );

    final finalTotal =
        CouponService.calculateFinalTotal(
      subtotal,
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
          'Sepetim',
          style: TextStyle(
            color:
                Color(0xFF383431),
            fontSize: 18,
            fontWeight:
                FontWeight.w500,
          ),
        ),
      ),

      body: items.isEmpty
          ? _emptyCart()
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding:
                        const EdgeInsets.fromLTRB(
                      20,
                      8,
                      20,
                      20,
                    ),
                    physics:
                        const BouncingScrollPhysics(),

                    children: [
                      ...items.map(
                        (product) =>
                            _cartItem(product),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      _couponSection(),

                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),

                _bottomSummary(
                  subtotal: subtotal,
                  discount: discount,
                  finalTotal: finalTotal,
                ),
              ],
            ),
    );
  }

  Widget _emptyCart() {
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
                    .shopping_bag_outlined,
                color:
                    Color(0xFFA9826E),
                size: 34,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            const Text(
              'Sepetin henüz boş',
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
              'Beğendiğin ürünleri sepete ekleyerek\nalışverişine devam edebilirsin.',
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                color:
                    Color(0xFF9B9189),
                fontSize: 11,
                height: 1.5,
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            SizedBox(
              height: 46,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                  );
                },
                style:
                    ElevatedButton.styleFrom(
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
                      14,
                    ),
                  ),
                ),
                child: const Text(
                  'Alışverişe Başla',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cartItem(Product product) {
    final quantity =
        CartService.quantity(product);

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),
      padding:
          const EdgeInsets.all(10),
      decoration:
          BoxDecoration(
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
              width: 82,
              height: 82,
              fit: BoxFit.cover,
              errorBuilder:
                  (
                context,
                error,
                stackTrace,
              ) {
                return Container(
                  width: 82,
                  height: 82,
                  color:
                      const Color(
                    0xFFF1ECE4,
                  ),
                  child:
                      const Icon(
                    Icons
                        .image_not_supported_outlined,
                    color:
                        Color(
                      0xFFB0A69E,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(
            width: 12,
          ),

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
                        Color(0xFF66564E),
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),

                Text(
                  product.category,
                  style:
                      const TextStyle(
                    color:
                        Color(0xFF9B9189),
                    fontSize: 9,
                  ),
                ),

                const SizedBox(
                  height: 7,
                ),

                Text(
                  '₺${product.price.toStringAsFixed(0)}',
                  style:
                      const TextStyle(
                    color:
                        Color(0xFFA9826E),
                    fontSize: 13,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                Row(
                  children: [
                    _quantityButton(
                      icon:
                          Icons.remove,
                      onPressed: () {
                        CartService
                            .decrease(
                          product,
                        );
                        refresh();
                      },
                    ),

                    Padding(
                      padding:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 12,
                      ),
                      child: Text(
                        '$quantity',
                        style:
                            const TextStyle(
                          color:
                              Color(
                            0xFF66564E,
                          ),
                          fontSize: 12,
                          fontWeight:
                              FontWeight
                                  .w600,
                        ),
                      ),
                    ),

                    _quantityButton(
                      icon: Icons.add,
                      onPressed: () {
                        if (quantity <
                            product.stock) {
                          CartService
                              .increase(
                            product,
                          );
                          refresh();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () {
              CartService.remove(
                product,
              );
              refresh();
            },
            icon: const Icon(
              Icons.delete_outline,
              color:
                  Color(0xFFB0A69E),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _couponSection() {
    final appliedCoupon =
        CouponService.appliedCoupon;

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(16),
      decoration:
          BoxDecoration(
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
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons
                    .local_offer_outlined,
                color:
                    Color(0xFFA9826E),
                size: 18,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                'İndirim Kuponu',
                style:
                    TextStyle(
                  color:
                      Color(0xFF66564E),
                  fontSize: 14,
                  fontWeight:
                      FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 12,
          ),

          if (appliedCoupon == null)
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 44,
                    decoration:
                        BoxDecoration(
                      color:
                          const Color(
                        0xFFF7F4EE,
                      ),
                      borderRadius:
                          BorderRadius
                              .circular(
                        12,
                      ),
                      border:
                          Border.all(
                        color:
                            const Color(
                          0xFFE5DED4,
                        ),
                      ),
                    ),
                    child: TextField(
                      controller:
                          couponController,
                      textCapitalization:
                          TextCapitalization
                              .characters,
                      style:
                          const TextStyle(
                        color:
                            Color(
                          0xFF66564E,
                        ),
                        fontSize: 12,
                      ),
                      decoration:
                          const InputDecoration(
                        border:
                            InputBorder.none,
                        hintText:
                            'Kupon kodunu gir...',
                        hintStyle:
                            TextStyle(
                          color:
                              Color(
                            0xFFB0A69E,
                          ),
                          fontSize: 11,
                        ),
                        contentPadding:
                            EdgeInsets
                                .symmetric(
                          horizontal: 12,
                          vertical: 13,
                        ),
                      ),
                      onSubmitted:
                          (_) {
                        applyCoupon();
                      },
                    ),
                  ),
                ),

                const SizedBox(
                  width: 8,
                ),

                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed:
                        applyCoupon,
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
                      padding:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 15,
                      ),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                          12,
                        ),
                      ),
                    ),
                    child: const Text(
                      'Uygula',
                      style:
                          TextStyle(
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            Container(
              padding:
                  const EdgeInsets
                      .symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              decoration:
                  BoxDecoration(
                color:
                    const Color(
                  0xFFF1E9E1,
                ),
                borderRadius:
                    BorderRadius.circular(
                  12,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons
                        .check_circle_outline,
                    color:
                        Color(0xFFA9826E),
                    size: 18,
                  ),

                  const SizedBox(
                    width: 8,
                  ),

                  Expanded(
                    child: Text(
                      '$appliedCoupon kuponu uygulandı',
                      style:
                          const TextStyle(
                        color:
                            Color(
                          0xFF66564E,
                        ),
                        fontSize: 11,
                        fontWeight:
                            FontWeight.w500,
                      ),
                    ),
                  ),

                  TextButton(
                    onPressed:
                        removeCoupon,
                    child:
                        const Text(
                      'Kaldır',
                      style:
                          TextStyle(
                        color:
                            Color(
                          0xFFA9826E,
                        ),
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          if (couponMessage != null) ...[
            const SizedBox(
              height: 8,
            ),

            Row(
              children: [
                Icon(
                  couponError
                      ? Icons
                          .error_outline
                      : Icons
                          .check_circle_outline,
                  color: couponError
                      ? const Color(
                          0xFF9A6F62,
                        )
                      : const Color(
                          0xFFA9826E,
                        ),
                  size: 14,
                ),

                const SizedBox(
                  width: 6,
                ),

                Expanded(
                  child: Text(
                    couponMessage!,
                    style:
                        TextStyle(
                      color: couponError
                          ? const Color(
                              0xFF9A6F62,
                            )
                          : const Color(
                              0xFFA9826E,
                            ),
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(
            height: 10,
          ),

          const Text(
            'Deneme kodları: ICY5 • ICY10 • ICY15',
            style: TextStyle(
              color:
                  Color(0xFFB0A69E),
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius:
          BorderRadius.circular(8),
      child: Container(
        width: 27,
        height: 27,
        decoration:
            BoxDecoration(
          color:
              const Color(0xFFF1E9E1),
          borderRadius:
              BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color:
              const Color(0xFF796C64),
          size: 15,
        ),
      ),
    );
  }

  Widget _bottomSummary({
    required double subtotal,
    required double discount,
    required double finalTotal,
  }) {
    return Container(
      padding:
          const EdgeInsets.fromLTRB(
        20,
        15,
        20,
        20,
      ),
      decoration:
          const BoxDecoration(
        color:
            Color(0xFFFBF9F5),
        border: Border(
          top: BorderSide(
            color:
                Color(0xFFE5DED4),
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,
            children: [
              const Text(
                'Ara Toplam',
                style: TextStyle(
                  color:
                      Color(0xFF796C64),
                  fontSize: 11,
                ),
              ),

              Text(
                '₺${subtotal.toStringAsFixed(0)}',
                style:
                    const TextStyle(
                  color:
                      Color(0xFF66564E),
                  fontSize: 12,
                ),
              ),
            ],
          ),

          if (discount > 0) ...[
            const SizedBox(
              height: 6,
            ),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,
              children: [
                const Text(
                  'İndirim',
                  style: TextStyle(
                    color:
                        Color(0xFFA9826E),
                    fontSize: 11,
                  ),
                ),

                Text(
                  '-₺${discount.toStringAsFixed(0)}',
                  style:
                      const TextStyle(
                    color:
                        Color(0xFFA9826E),
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(
            height: 8,
          ),

          Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,
            children: [
              const Text(
                'Toplam',
                style: TextStyle(
                  color:
                      Color(0xFF66564E),
                  fontSize: 13,
                  fontWeight:
                      FontWeight.w500,
                ),
              ),

              Text(
                '₺${finalTotal.toStringAsFixed(0)}',
                style:
                    const TextStyle(
                  color:
                      Color(0xFF383431),
                  fontSize: 18,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 14,
          ),

          SizedBox(
            width:
                double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed:
                  openCheckout,
              style:
                  ElevatedButton.styleFrom(
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
              child: const Text(
                'Alışverişi Tamamla',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                      FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}