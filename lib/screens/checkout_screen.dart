import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/cart_service.dart';
import '../services/coupon_service.dart';
import '../services/order_service.dart';
import '../services/address_service.dart';
import 'order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({
    super.key,
  });

  @override
  State<CheckoutScreen> createState() =>
      _CheckoutScreenState();
}

class _CheckoutScreenState
    extends State<CheckoutScreen> {
  final _formKey =
      GlobalKey<FormState>();

  final TextEditingController
      nameController =
      TextEditingController();

  final TextEditingController
      phoneController =
      TextEditingController();

  final TextEditingController
      addressController =
      TextEditingController();

  final TextEditingController
      cityController =
      TextEditingController();

  final TextEditingController
      cardNameController =
      TextEditingController();

  final TextEditingController
      cardNumberController =
      TextEditingController();

  final TextEditingController
      expiryController =
      TextEditingController();

  final TextEditingController
      cvvController =
      TextEditingController();

  String selectedPayment = 'Kart';

  String? selectedSavedAddress;

  bool saveAddress = false;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cityController.dispose();
    cardNameController.dispose();
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();

    super.dispose();
  }

  void selectSavedAddress(
    String address,
  ) {
    setState(() {
      selectedSavedAddress = address;
      addressController.text = address;
    });
  }

  void completeOrder() {
    if (!_formKey.currentState!
        .validate()) {
      return;
    }

    final address =
        '${addressController.text.trim()}, ${cityController.text.trim()}';

    if (saveAddress) {
      AddressService.addAddress(address);
    }

    final orderNumber =
        'ICY-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

    final total =
        CouponService.calculateFinalTotal(
      CartService.totalPrice,
    );

    final order = OrderRecord(
      orderNumber: orderNumber,
      total: total,
      date: DateTime.now(),
      paymentMethod: selectedPayment,
      address: address,
      status: 'Hazırlanıyor',
    );

    OrderService.addOrder(order);

    CartService.clear();
    CouponService.removeCoupon();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            OrderSuccessScreen(
          orderNumber: orderNumber,
          total: total,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final subtotal =
        CartService.totalPrice;

    final discount =
        CouponService.calculateDiscount(
      subtotal,
    );

    final total =
        CouponService.calculateFinalTotal(
      subtotal,
    );

    final appliedCoupon =
        CouponService.appliedCoupon;

    final savedAddresses =
        AddressService.addresses;

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
          'Siparişi Tamamla',
          style: TextStyle(
            color:
                Color(0xFF383431),
            fontSize: 18,
            fontWeight:
                FontWeight.w500,
          ),
        ),
      ),

      body: Form(
        key: _formKey,

        child: ListView(
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
              height: 14,
            ),

            _inputField(
              controller:
                  nameController,
              label: 'Ad Soyad',
              hint:
                  'Adınızı ve soyadınızı girin',
              icon:
                  Icons.person_outline,
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Ad soyad gerekli.';
                }

                if (value.trim().length < 3) {
                  return 'Lütfen geçerli bir ad soyad girin.';
                }

                return null;
              },
            ),

            const SizedBox(
              height: 12,
            ),

            _inputField(
              controller:
                  phoneController,
              label: 'Telefon',
              hint:
                  '05XX XXX XX XX',
              icon:
                  Icons.phone_outlined,
              keyboardType:
                  TextInputType.phone,
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Telefon gerekli.';
                }

                final digits =
                    value.replaceAll(
                  RegExp(r'\D'),
                  '',
                );

                if (digits.length < 10) {
                  return 'Lütfen geçerli bir telefon girin.';
                }

                return null;
              },
            ),

            const SizedBox(
              height: 20,
            ),

            // =================================================
            // KAYITLI ADRESLER
            // =================================================

            if (savedAddresses.isNotEmpty) ...[
              const Text(
                'Kayıtlı Adresler',
                style: TextStyle(
                  color:
                      Color(0xFF66564E),
                  fontSize: 12,
                  fontWeight:
                      FontWeight.w500,
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              ...savedAddresses.map(
                (address) {
                  final selected =
                      selectedSavedAddress ==
                          address;

                  return GestureDetector(
                    onTap: () {
                      selectSavedAddress(
                        address,
                      );
                    },

                    child:
                        AnimatedContainer(
                      duration:
                          const Duration(
                        milliseconds: 180,
                      ),
                      margin:
                          const EdgeInsets
                              .only(
                        bottom: 8,
                      ),
                      padding:
                          const EdgeInsets
                              .all(12),
                      decoration:
                          BoxDecoration(
                        color: selected
                            ? const Color(
                                0xFFF1E9E1,
                              )
                            : const Color(
                                0xFFFBF9F5,
                              ),
                        borderRadius:
                            BorderRadius
                                .circular(
                          12,
                        ),
                        border:
                            Border.all(
                          color: selected
                              ? const Color(
                                  0xFFC9A995,
                                )
                              : const Color(
                                  0xFFE5DED4,
                                ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            selected
                                ? Icons
                                    .radio_button_checked
                                : Icons
                                    .radio_button_off,
                            color:
                                const Color(
                              0xFFA9826E,
                            ),
                            size: 18,
                          ),

                          const SizedBox(
                            width: 8,
                          ),

                          Expanded(
                            child: Text(
                              address,
                              style:
                                  const TextStyle(
                                color:
                                    Color(
                                  0xFF796C64,
                                ),
                                fontSize: 10,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(
                height: 8,
              ),
            ],

            // =================================================
            // ADRES
            // =================================================

            _inputField(
              controller:
                  addressController,
              label: 'Adres',
              hint:
                  'Mahalle, sokak, bina ve daire bilgisi',
              icon:
                  Icons.location_on_outlined,
              maxLines: 3,
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Adres gerekli.';
                }

                if (value.trim().length < 10) {
                  return 'Lütfen adresinizi daha detaylı girin.';
                }

                return null;
              },
            ),

            const SizedBox(
              height: 4,
            ),

            // =================================================
            // ADRESİ KAYDET
            // =================================================

            CheckboxListTile(
              value: saveAddress,
              onChanged: (value) {
                setState(() {
                  saveAddress =
                      value ?? false;
                });
              },
              activeColor:
                  const Color(0xFFA9826E),
              contentPadding:
                  EdgeInsets.zero,
              controlAffinity:
                  ListTileControlAffinity
                      .leading,
              title: const Text(
                'Bu adresi kaydet',
                style: TextStyle(
                  color:
                      Color(0xFF66564E),
                  fontSize: 11,
                ),
              ),
              subtitle:
                  const Text(
                'Bir sonraki siparişinde tekrar kullanabilirsin.',
                style: TextStyle(
                  color:
                      Color(0xFF9B9189),
                  fontSize: 9,
                ),
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            _inputField(
              controller:
                  cityController,
              label: 'Şehir',
              hint:
                  'Şehir',
              icon:
                  Icons.location_city_outlined,
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Şehir gerekli.';
                }

                return null;
              },
            ),

            const SizedBox(
              height: 30,
            ),

            // =================================================
            // ÖDEME YÖNTEMİ
            // =================================================

            const Text(
              'Ödeme Yöntemi',
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

            _paymentOption(
              title:
                  'Kart ile Ödeme',
              subtitle:
                  'Kredi veya banka kartı',
              icon:
                  Icons.credit_card_outlined,
              value: 'Kart',
            ),

            const SizedBox(
              height: 10,
            ),

            _paymentOption(
              title:
                  'Kapıda Ödeme',
              subtitle:
                  'Teslimatta ödeme',
              icon:
                  Icons.payments_outlined,
              value:
                  'Kapıda Ödeme',
            ),

            // =================================================
            // KART BİLGİLERİ
            // =================================================

            if (selectedPayment ==
                'Kart') ...[
              const SizedBox(
                height: 20,
              ),

              Container(
                padding:
                    const EdgeInsets.all(
                  16,
                ),
                decoration:
                    BoxDecoration(
                  color:
                      const Color(
                    0xFFFBF9F5,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                  border: Border.all(
                    color:
                        const Color(
                      0xFFE5DED4,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons
                              .lock_outline,
                          color:
                              Color(
                            0xFFA9826E,
                          ),
                          size: 17,
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Text(
                          'Kart Bilgileri',
                          style:
                              TextStyle(
                            color:
                                Color(
                              0xFF66564E,
                            ),
                            fontSize:
                                13,
                            fontWeight:
                                FontWeight
                                    .w500,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 14,
                    ),

                    _inputField(
                      controller:
                          cardNameController,
                      label:
                          'Kart Üzerindeki İsim',
                      hint:
                          'Ad Soyad',
                      icon:
                          Icons.person_outline,
                      validator:
                          (value) {
                        if (selectedPayment !=
                            'Kart') {
                          return null;
                        }

                        if (value == null ||
                            value.trim()
                                .isEmpty) {
                          return 'Kart üzerindeki isim gerekli.';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    _inputField(
                      controller:
                          cardNumberController,
                      label:
                          'Kart Numarası',
                      hint:
                          '1234 5678 9012 3456',
                      icon:
                          Icons.credit_card,
                      keyboardType:
                          TextInputType
                              .number,
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .digitsOnly,
                        LengthLimitingTextInputFormatter(
                          16,
                        ),
                      ],
                      validator:
                          (value) {
                        if (selectedPayment !=
                            'Kart') {
                          return null;
                        }

                        final digits =
                            value?.replaceAll(
                                  ' ',
                                  '',
                                ) ??
                                '';

                        if (digits.length !=
                            16) {
                          return 'Kart numarası 16 haneli olmalı.';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    Row(
                      children: [
                        Expanded(
                          child:
                              _inputField(
                            controller:
                                expiryController,
                            label:
                                'Son Kullanma',
                            hint:
                                'MM/YY',
                            icon:
                                Icons
                                    .calendar_today_outlined,
                            keyboardType:
                                TextInputType
                                    .number,
                            inputFormatters: [
                              FilteringTextInputFormatter
                                  .digitsOnly,
                              LengthLimitingTextInputFormatter(
                                4,
                              ),
                            ],
                            validator:
                                (value) {
                              if (selectedPayment !=
                                  'Kart') {
                                return null;
                              }

                              if ((value ??
                                      '')
                                  .length !=
                                  4) {
                                return 'MM/YY girin.';
                              }

                              return null;
                            },
                          ),
                        ),

                        const SizedBox(
                          width: 12,
                        ),

                        Expanded(
                          child:
                              _inputField(
                            controller:
                                cvvController,
                            label:
                                'CVV',
                            hint:
                                '123',
                            icon:
                                Icons
                                    .lock_outline,
                            keyboardType:
                                TextInputType
                                    .number,
                            inputFormatters: [
                              FilteringTextInputFormatter
                                  .digitsOnly,
                              LengthLimitingTextInputFormatter(
                                3,
                              ),
                            ],
                            validator:
                                (value) {
                              if (selectedPayment !=
                                  'Kart') {
                                return null;
                              }

                              if ((value ??
                                      '')
                                  .length !=
                                  3) {
                                return 'CVV 3 haneli olmalı.';
                              }

                              return null;
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    const Text(
                      'Demo ödeme ekranıdır. Gerçek kart işlemi yapılmaz.',
                      style: TextStyle(
                        color:
                            Color(
                          0xFFB0A69E,
                        ),
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(
              height: 30,
            ),

            // =================================================
            // SİPARİŞ ÖZETİ
            // =================================================

            const Text(
              'Sipariş Özeti',
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
                16,
              ),
              decoration:
                  BoxDecoration(
                color:
                    const Color(
                  0xFFFBF9F5,
                ),
                borderRadius:
                    BorderRadius.circular(
                  16,
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
                  _summaryRow(
                    'Ara Toplam',
                    '₺${subtotal.toStringAsFixed(0)}',
                  ),

                  if (appliedCoupon !=
                      null) ...[
                    const SizedBox(
                      height: 9,
                    ),

                    _summaryRow(
                      'Kupon ($appliedCoupon)',
                      '-₺${discount.toStringAsFixed(0)}',
                      valueColor:
                          const Color(
                        0xFFA9826E,
                      ),
                    ),
                  ],

                  const Padding(
                    padding:
                        EdgeInsets.symmetric(
                      vertical: 12,
                    ),
                    child: Divider(
                      color:
                          Color(
                        0xFFE5DED4,
                      ),
                      height: 1,
                    ),
                  ),

                  _summaryRow(
                    'Toplam',
                    '₺${total.toStringAsFixed(0)}',
                    bold: true,
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            SizedBox(
              width:
                  double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed:
                    completeOrder,
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
                      16,
                    ),
                  ),
                ),
                child: const Text(
                  'Siparişi Tamamla',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            const Text(
              'Siparişinizi tamamlayarak teslimat ve ödeme bilgilerinizin doğruluğunu onaylamış olursunuz.',
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                color:
                    Color(0xFFB0A69E),
                fontSize: 9,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController
        controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(
      String?,
    ) validator,
    TextInputType? keyboardType,
    int maxLines = 1,
    List<TextInputFormatter>?
        inputFormatters,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color:
                Color(0xFF796C64),
            fontSize: 10,
          ),
        ),

        const SizedBox(
          height: 6,
        ),

        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType:
              keyboardType,
          maxLines: maxLines,
          inputFormatters:
              inputFormatters,

          style:
              const TextStyle(
            color:
                Color(0xFF66564E),
            fontSize: 12,
          ),

          decoration:
              InputDecoration(
            hintText: hint,

            hintStyle:
                const TextStyle(
              color:
                  Color(0xFFB0A69E),
              fontSize: 11,
            ),

            prefixIcon:
                Icon(
              icon,
              color:
                  const Color(
                0xFFA9826E,
              ),
              size: 19,
            ),

            filled: true,

            fillColor:
                const Color(
              0xFFFBF9F5,
            ),

            border:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                13,
              ),
              borderSide:
                  const BorderSide(
                color:
                    Color(0xFFE5DED4),
              ),
            ),

            enabledBorder:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                13,
              ),
              borderSide:
                  const BorderSide(
                color:
                    Color(0xFFE5DED4),
              ),
            ),

            focusedBorder:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                13,
              ),
              borderSide:
                  const BorderSide(
                color:
                    Color(0xFFC9A995),
              ),
            ),

            errorBorder:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                13,
              ),
              borderSide:
                  const BorderSide(
                color:
                    Color(0xFFB98C7E),
              ),
            ),

            contentPadding:
                const EdgeInsets
                    .symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _paymentOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required String value,
  }) {
    final isSelected =
        selectedPayment == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPayment = value;
        });
      },

      child: AnimatedContainer(
        duration:
            const Duration(
          milliseconds: 180,
        ),
        padding:
            const EdgeInsets.all(
          14,
        ),
        decoration:
            BoxDecoration(
          color: isSelected
              ? const Color(
                  0xFFF1E9E1,
                )
              : const Color(
                  0xFFFBF9F5,
                ),
          borderRadius:
              BorderRadius.circular(
            15,
          ),
          border: Border.all(
            color: isSelected
                ? const Color(
                    0xFFC9A995,
                  )
                : const Color(
                    0xFFE5DED4,
                  ),
          ),
        ),

        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
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
                    const Color(
                  0xFFA9826E,
                ),
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
                    title,
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
                    height: 3,
                  ),

                  Text(
                    subtitle,
                    style:
                        const TextStyle(
                      color:
                          Color(0xFF9B9189),
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              isSelected
                  ? Icons
                      .radio_button_checked
                  : Icons
                      .radio_button_off,
              color:
                  isSelected
                      ? const Color(
                          0xFFA9826E,
                        )
                      : const Color(
                          0xFFB0A69E,
                        ),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(
    String title,
    String value, {
    bool bold = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment
              .spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color:
                const Color(
              0xFF796C64,
            ),
            fontSize:
                bold ? 13 : 11,
            fontWeight: bold
                ? FontWeight.w500
                : FontWeight.w400,
          ),
        ),

        Text(
          value,
          style: TextStyle(
            color: valueColor ??
                const Color(
                  0xFF383431,
                ),
            fontSize:
                bold ? 17 : 12,
            fontWeight: bold
                ? FontWeight.w600
                : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}