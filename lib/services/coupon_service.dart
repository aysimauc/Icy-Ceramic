class CouponService {
  static const Map<String, double> coupons = {
    'ICY5': 0.05,
    'ICY10': 0.10,
    'ICY15': 0.15,
  };

  static String? _appliedCoupon;

  static String? get appliedCoupon {
    return _appliedCoupon;
  }

  static double get discountRate {
    if (_appliedCoupon == null) {
      return 0;
    }

    return coupons[_appliedCoupon] ?? 0;
  }

  static bool applyCoupon(String code) {
    final normalizedCode =
        code.trim().toUpperCase();

    if (!coupons.containsKey(normalizedCode)) {
      return false;
    }

    _appliedCoupon = normalizedCode;

    return true;
  }

  static void removeCoupon() {
    _appliedCoupon = null;
  }

  static double calculateDiscount(
    double total,
  ) {
    return total * discountRate;
  }

  static double calculateFinalTotal(
    double total,
  ) {
    final discount =
        calculateDiscount(total);

    return total - discount;
  }
}