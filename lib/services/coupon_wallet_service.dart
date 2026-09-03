class CouponReward {
  final String code;
  final int discount;
  final DateTime earnedAt;

  const CouponReward({
    required this.code,
    required this.discount,
    required this.earnedAt,
  });
}

class CouponWalletService {
  static final List<CouponReward> _coupons = [];

  static List<CouponReward> get coupons {
    return List.unmodifiable(
      _coupons.reversed,
    );
  }

  static bool hasCoupon(String code) {
    return _coupons.any(
      (coupon) => coupon.code == code,
    );
  }

  static void addCoupon({
    required String code,
    required int discount,
  }) {
    if (hasCoupon(code)) {
      return;
    }

    _coupons.add(
      CouponReward(
        code: code,
        discount: discount,
        earnedAt: DateTime.now(),
      ),
    );
  }

  static void removeCoupon(String code) {
    _coupons.removeWhere(
      (coupon) => coupon.code == code,
    );
  }
}