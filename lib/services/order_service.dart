class OrderRecord {
  final String orderNumber;
  final double total;
  final DateTime date;
  final String paymentMethod;
  final String address;

  String status;
  String? trackingNumber;
  String? cargoCompany;

  OrderRecord({
    required this.orderNumber,
    required this.total,
    required this.date,
    required this.paymentMethod,
    required this.address,
    required this.status,
    this.trackingNumber,
    this.cargoCompany,
  });
}

class OrderService {
  static final List<OrderRecord> _orders = [];

  static List<OrderRecord> get orders {
    return List.unmodifiable(
      _orders.reversed,
    );
  }

  static void addOrder(
    OrderRecord order,
  ) {
    _orders.add(order);
  }

  static OrderRecord? getOrder(
    String orderNumber,
  ) {
    for (final order in _orders) {
      if (order.orderNumber ==
          orderNumber) {
        return order;
      }
    }

    return null;
  }

  static void updateStatus({
    required String orderNumber,
    required String status,
    String? trackingNumber,
    String? cargoCompany,
  }) {
    final order =
        getOrder(orderNumber);

    if (order == null) {
      return;
    }

    order.status = status;

    if (trackingNumber != null) {
      order.trackingNumber =
          trackingNumber;
    }

    if (cargoCompany != null) {
      order.cargoCompany =
          cargoCompany;
    }
  }
}