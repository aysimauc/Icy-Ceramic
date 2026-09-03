import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/coupon_wallet_service.dart';
import 'mini_game_screen.dart';

class CouponWalletScreen extends StatefulWidget {
  const CouponWalletScreen({
    super.key,
  });

  @override
  State<CouponWalletScreen> createState() =>
      _CouponWalletScreenState();
}

class _CouponWalletScreenState
    extends State<CouponWalletScreen> {
  @override
  Widget build(BuildContext context) {
    final coupons = CouponWalletService.coupons;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EE),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F4EE),
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF66564E),
            size: 19,
          ),
        ),

        title: const Text(
          'Kuponlarım',
          style: TextStyle(
            color: Color(0xFF383431),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      body: SafeArea(
        child: coupons.isEmpty
            ? _emptyState()
            : ListView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  15,
                  20,
                  30,
                ),
                physics: const BouncingScrollPhysics(),
                children: [
                  const Text(
                    'Kazandığın Kuponlar',
                    style: TextStyle(
                      color: Color(0xFF383431),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Mini oyunlardan kazandığın indirim kuponlarını burada görebilirsin.',
                    style: TextStyle(
                      color: Color(0xFF9B9189),
                      fontSize: 10,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 20),

                  ...coupons.map(
                    (coupon) => _couponCard(
                      code: coupon.code,
                      discount: coupon.discount,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // ============================================================
  // BOŞ KUPON EKRANI
  // ============================================================

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 35,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 82,
              height: 82,
              decoration: const BoxDecoration(
                color: Color(0xFFEFE5DC),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.local_offer_outlined,
                color: Color(0xFFA9826E),
                size: 38,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Henüz kuponun yok',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF383431),
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Mini oyunu oynayarak indirim kuponları kazanabilirsin.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF9B9189),
                fontSize: 10,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 22),

            SizedBox(
              height: 46,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const MiniGameScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.extension_outlined,
                  size: 17,
                ),
                label: const Text(
                  'Mini Oyuna Git',
                  style: TextStyle(
                    fontSize: 11,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor:
                      const Color(0xFFA9826E),
                  side: const BorderSide(
                    color: Color(0xFFC9A995),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(14),
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
  // KUPON KARTI
  // ============================================================

  Widget _couponCard({
    required String code,
    required int discount,
  }) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 14,
      ),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: const Color(0xFFFBF9F5),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE5DED4),
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(
              color: Color(0xFFEFE5DC),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_offer_outlined,
              color: Color(0xFFA9826E),
              size: 27,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  '%$discount İndirim',
                  style: const TextStyle(
                    color: Color(0xFF383431),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  code,
                  style: const TextStyle(
                    color: Color(0xFFA9826E),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  'Sepette kullanabilirsin',
                  style: TextStyle(
                    color: Color(0xFF9B9189),
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () {
              _copyCoupon(code);
            },
            icon: const Icon(
              Icons.copy_outlined,
              color: Color(0xFFA9826E),
              size: 20,
            ),
            tooltip: 'Kuponu Kopyala',
          ),
        ],
      ),
    );
  }

  // ============================================================
  // KUPONU GERÇEKTEN CLIPBOARD'A KOPYALA
  // ============================================================

  Future<void> _copyCoupon(String code) async {
    await Clipboard.setData(
      ClipboardData(
        text: code,
      ),
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor:
            const Color(0xFF66564E),
        content: Text(
          '$code kupon kodu kopyalandı. Sepette yapıştırabilirsin.',
          style: const TextStyle(
            fontSize: 11,
          ),
        ),
        duration: const Duration(
          seconds: 2,
        ),
      ),
    );
  }
}