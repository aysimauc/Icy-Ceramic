import 'dart:math';

import 'package:flutter/material.dart';

import '../services/coupon_wallet_service.dart';

class MiniGameScreen extends StatefulWidget {
  const MiniGameScreen({
    super.key,
  });

  @override
  State<MiniGameScreen> createState() =>
      _MiniGameScreenState();
}

class _MiniGameScreenState
    extends State<MiniGameScreen> {
  // 3 farklı ürün ve her üründen 3 kart.
  final List<String> _cardImages = [
    'assets/products/kupa_02.png',
    'assets/products/kupa_02.png',
    'assets/products/kupa_02.png',

    'assets/products/kupa_03.png',
    'assets/products/kupa_03.png',
    'assets/products/kupa_03.png',

    'assets/products/kase_03.png',
    'assets/products/kase_03.png',
    'assets/products/kase_03.png',
  ];

  late List<int> _cards;

  final List<bool> _revealed =
      List<bool>.filled(9, false);

  final List<bool> _matched =
      List<bool>.filled(9, false);

  final List<int> _selectedCards = [];

  int _matchedSets = 0;
  int _moves = 0;

  bool _isChecking = false;
  bool _gameFinished = false;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  // ============================================================
  // YENİ OYUN
  // ============================================================

  void _startGame() {
    final indexes =
        List<int>.generate(9, (index) => index);

    indexes.shuffle(Random());

    setState(() {
      _cards = indexes;

      for (int i = 0; i < 9; i++) {
        _revealed[i] = false;
        _matched[i] = false;
      }

      _selectedCards.clear();

      _matchedSets = 0;
      _moves = 0;

      _isChecking = false;
      _gameFinished = false;
    });
  }

  // ============================================================
  // KARTA BASMA
  // ============================================================

  void _tapCard(int index) {
    if (_isChecking ||
        _gameFinished ||
        _revealed[index] ||
        _matched[index] ||
        _selectedCards.length >= 3) {
      return;
    }

    setState(() {
      _revealed[index] = true;
      _selectedCards.add(index);
    });

    if (_selectedCards.length == 3) {
      _checkSet();
    }
  }

  // ============================================================
  // 3 KARTI KONTROL ET
  // ============================================================

  Future<void> _checkSet() async {
    if (_selectedCards.length != 3) {
      return;
    }

    final selected =
        List<int>.from(_selectedCards);

    setState(() {
      _isChecking = true;
      _moves++;
    });

    await Future.delayed(
      const Duration(
        milliseconds: 700,
      ),
    );

    final firstImage =
        _cardImages[_cards[selected[0]]];

    final secondImage =
        _cardImages[_cards[selected[1]]];

    final thirdImage =
        _cardImages[_cards[selected[2]]];

    final isMatch =
        firstImage == secondImage &&
        secondImage == thirdImage;

    if (isMatch) {
      setState(() {
        for (final index in selected) {
          _matched[index] = true;
        }

        _selectedCards.clear();
        _matchedSets++;
        _isChecking = false;
      });

      if (_matchedSets == 3) {
        _finishGame();
      }
    } else {
      setState(() {
        for (final index in selected) {
          _revealed[index] = false;
        }

        _selectedCards.clear();
        _isChecking = false;
      });
    }
  }

  // ============================================================
  // OYUN BİTİŞİ
  // ============================================================

  void _finishGame() {
    const discount = 15;
    const code = 'ICY15';

    CouponWalletService.addCoupon(
      code: code,
      discount: discount,
    );

    setState(() {
      _gameFinished = true;
    });

    Future.delayed(
      const Duration(
        milliseconds: 250,
      ),
      () {
        if (!mounted) {
          return;
        }

        _showRewardDialog(
          discount,
          code,
        );
      },
    );
  }

  // ============================================================
  // ÖDÜL DİYALOĞU
  // ============================================================

  void _showRewardDialog(
    int discount,
    String code,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor:
              const Color(0xFFFBF9F5),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(24),
          ),
          child: Padding(
            padding:
                const EdgeInsets.all(24),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration:
                      const BoxDecoration(
                    color:
                        Color(0xFFEFE5DC),
                    shape:
                        BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.card_giftcard_outlined,
                    color:
                        Color(0xFFA9826E),
                    size: 34,
                  ),
                ),

                const SizedBox(
                  height: 18,
                ),

                const Text(
                  'Tebrikler! 🎉',
                  style:
                      TextStyle(
                    color:
                        Color(0xFF383431),
                    fontSize: 21,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                Text(
                  'Tüm seramik setlerini buldun.\n'
                  '%$discount indirim kuponu kazandın!',
                  textAlign:
                      TextAlign.center,
                  style:
                      const TextStyle(
                    color:
                        Color(0xFF796C64),
                    fontSize: 11,
                    height: 1.6,
                  ),
                ),

                const SizedBox(
                  height: 18,
                ),

                Container(
                  width:
                      double.infinity,
                  padding:
                      const EdgeInsets
                          .symmetric(
                    vertical: 14,
                    horizontal: 18,
                  ),
                  decoration:
                      BoxDecoration(
                    color:
                        const Color(
                      0xFFF1E9E1,
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'KUPON KODUN',
                        style:
                            TextStyle(
                          color:
                              Color(
                            0xFF9B9189,
                          ),
                          fontSize: 8,
                          letterSpacing:
                              1.2,
                        ),
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      Text(
                        code,
                        style:
                            const TextStyle(
                          color:
                              Color(
                            0xFFA9826E,
                          ),
                          fontSize: 20,
                          fontWeight:
                              FontWeight.w600,
                          letterSpacing:
                              2,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                SizedBox(
                  width:
                      double.infinity,
                  height: 48,
                  child:
                      ElevatedButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
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
                          14,
                        ),
                      ),
                    ),
                    child:
                        const Text(
                      'Kuponumu Aldım',
                      style:
                          TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // MEVCUT ÖDÜL
  // ============================================================

  int get currentReward {
    if (_matchedSets >= 3) {
      return 15;
    }

    if (_matchedSets >= 2) {
      return 10;
    }

    if (_matchedSets >= 1) {
      return 5;
    }

    return 0;
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
          'Mini Oyun',
          style: TextStyle(
            color:
                Color(0xFF383431),
            fontSize: 18,
            fontWeight:
                FontWeight.w500,
          ),
        ),
      ),

      body: SafeArea(
        child: ListView(
          padding:
              const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            30,
          ),

          physics:
              const BouncingScrollPhysics(),

          children: [
            // ==================================================
            // BAŞLIK
            // ==================================================

            Container(
              padding:
                  const EdgeInsets.all(
                18,
              ),
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
                  Container(
                    width: 52,
                    height: 52,
                    decoration:
                        const BoxDecoration(
                      color:
                          Color(0xFFEFE5DC),
                      shape:
                          BoxShape.circle,
                    ),
                    child:
                        const Icon(
                      Icons.extension_outlined,
                      color:
                          Color(0xFFA9826E),
                      size: 27,
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  const Text(
                    'Seramikleri Eşleştir',
                    textAlign:
                        TextAlign.center,
                    style:
                        TextStyle(
                      color:
                          Color(0xFF383431),
                      fontSize: 17,
                      fontWeight:
                          FontWeight.w500,
                    ),
                  ),

                  const SizedBox(
                    height: 6,
                  ),

                  const Text(
                    'Aynı seramik üründen 3 kartı bul.\n'
                    'Tüm setleri tamamlayarak %15 kupon kazan!',
                    textAlign:
                        TextAlign.center,
                    style:
                        TextStyle(
                      color:
                          Color(0xFF9B9189),
                      fontSize: 10,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 18,
            ),

            // ==================================================
            // ÖDÜL GÖSTERGESİ
            // ==================================================

            Row(
              children: [
                Expanded(
                  child: _rewardBox(
                    title: '1 Set',
                    value: '%5',
                    active:
                        currentReward >=
                            5,
                  ),
                ),

                const SizedBox(
                  width: 8,
                ),

                Expanded(
                  child: _rewardBox(
                    title: '2 Set',
                    value: '%10',
                    active:
                        currentReward >=
                            10,
                  ),
                ),

                const SizedBox(
                  width: 8,
                ),

                Expanded(
                  child: _rewardBox(
                    title: '3 Set',
                    value: '%15',
                    active:
                        currentReward >=
                            15,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 22,
            ),

            // ==================================================
            // 9 KART - 3x3
            // ==================================================

            GridView.builder(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(),

              itemCount: 9,

              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.92,
              ),

              itemBuilder:
                  (context, index) {
                return _gameCard(
                  index,
                );
              },
            ),

            const SizedBox(
              height: 22,
            ),

            // ==================================================
            // OYUN BİLGİSİ
            // ==================================================

            Container(
              padding:
                  const EdgeInsets.all(
                15,
              ),
              decoration:
                  BoxDecoration(
                color:
                    const Color(
                  0xFFF1E9E1,
                ),
                borderRadius:
                    BorderRadius.circular(
                  15,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.touch_app_outlined,
                    color:
                        Color(0xFFA9826E),
                    size: 19,
                  ),

                  const SizedBox(
                    width: 9,
                  ),

                  Expanded(
                    child: Text(
                      _gameFinished
                          ? 'Oyunu tamamladın! Kuponun Kuponlarım bölümüne eklendi.'
                          : 'Hamle: $_moves  •  Tamamlanan set: $_matchedSets / 3',
                      style:
                          const TextStyle(
                        color:
                            Color(0xFF796C64),
                        fontSize: 10,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            // ==================================================
            // YENİ OYUN
            // ==================================================

            SizedBox(
              width:
                  double.infinity,
              height: 50,
              child:
                  OutlinedButton.icon(
                onPressed: _startGame,
                icon: const Icon(
                  Icons.refresh_rounded,
                  size: 18,
                ),
                label: const Text(
                  'Yeni Oyun',
                  style:
                      TextStyle(
                    fontSize: 12,
                  ),
                ),
                style:
                    OutlinedButton.styleFrom(
                  foregroundColor:
                      const Color(
                    0xFFA9826E,
                  ),
                  side:
                      const BorderSide(
                    color:
                        Color(0xFFC9A995),
                  ),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ÖDÜL KUTUSU
  // ============================================================

  Widget _rewardBox({
    required String title,
    required String value,
    required bool active,
  }) {
    return AnimatedContainer(
      duration:
          const Duration(
        milliseconds: 200,
      ),
      padding:
          const EdgeInsets.symmetric(
        vertical: 12,
      ),
      decoration:
          BoxDecoration(
        color: active
            ? const Color(
                0xFFF1E9E1,
              )
            : const Color(
                0xFFFBF9F5,
              ),
        borderRadius:
            BorderRadius.circular(
          13,
        ),
        border: Border.all(
          color: active
              ? const Color(
                  0xFFC9A995,
                )
              : const Color(
                  0xFFE5DED4,
                ),
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            style:
                const TextStyle(
              color:
                  Color(0xFF9B9189),
              fontSize: 8,
            ),
          ),

          const SizedBox(
            height: 4,
          ),

          Text(
            value,
            style:
                TextStyle(
              color: active
                  ? const Color(
                      0xFFA9826E,
                    )
                  : const Color(
                      0xFFC1B8AF,
                    ),
              fontSize: 16,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // OYUN KARTI
  // ============================================================

  Widget _gameCard(
    int index,
  ) {
    final imagePath =
        _cardImages[_cards[index]];

    final isVisible =
        _revealed[index] ||
            _matched[index];

    final isSelected =
        _selectedCards.contains(index);

    return GestureDetector(
      onTap: () {
        _tapCard(index);
      },

      child: AnimatedContainer(
        duration:
            const Duration(
          milliseconds: 220,
        ),

        decoration:
            BoxDecoration(
          color: _matched[index]
              ? const Color(
                  0xFFEFE5DC,
                )
              : isVisible
                  ? const Color(
                      0xFFFBF9F5,
                    )
                  : const Color(
                      0xFFE6D7CB,
                    ),

          borderRadius:
              BorderRadius.circular(
            17,
          ),

          border: Border.all(
            color: _matched[index] ||
                    isSelected
                ? const Color(
                    0xFFC9A995,
                  )
                : const Color(
                    0xFFE0D2C6,
                  ),
            width:
                isSelected ? 1.5 : 1,
          ),

          boxShadow: const [
            BoxShadow(
              color:
                  Color(0x12000000),
              blurRadius: 7,
              offset:
                  Offset(0, 3),
            ),
          ],
        ),

        child: isVisible
            ? ClipRRect(
                borderRadius:
                    BorderRadius.circular(
                  17,
                ),
                child:
                    Stack(
                  fit: StackFit.expand,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.all(
                        6,
                      ),
                      child:
                          Image.asset(
                        imagePath,
                        fit:
                            BoxFit.cover,
                        errorBuilder:
                            (
                          context,
                          error,
                          stackTrace,
                        ) {
                          return const Icon(
                            Icons
                                .image_not_supported_outlined,
                            color:
                                Color(
                              0xFFB0A69E,
                            ),
                            size: 27,
                          );
                        },
                      ),
                    ),

                    if (_matched[index])
                      Positioned(
                        top: 6,
                        right: 6,
                        child:
                            Container(
                          width: 23,
                          height: 23,
                          decoration:
                              const BoxDecoration(
                            color:
                                Color(
                              0xFFFBF9F5,
                            ),
                            shape:
                                BoxShape
                                    .circle,
                          ),
                          child:
                              const Icon(
                            Icons
                                .check_rounded,
                            color:
                                Color(
                              0xFFA9826E,
                            ),
                            size: 15,
                          ),
                        ),
                      ),
                  ],
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .center,
                  children: [
                    const Icon(
                      Icons
                          .local_florist_outlined,
                      color:
                          Color(0xFFC19F8B),
                      size: 24,
                    ),

                    const SizedBox(
                      height: 3,
                    ),

                    Text(
                      '?',
                      style:
                          TextStyle(
                        color:
                            const Color(
                          0xFFA9826E,
                        ),
                        fontSize: 25,
                        fontWeight:
                            FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}