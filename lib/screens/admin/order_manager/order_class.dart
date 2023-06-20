class OrderData {
  final String orderId;
  final String orderDate;
  final String userName;
  final double total;
  final String deliveryAddress;

  OrderData({
    required this.orderId,
    required this.orderDate,
    required this.userName,
    required this.total,
    required this.deliveryAddress,
  });
}
