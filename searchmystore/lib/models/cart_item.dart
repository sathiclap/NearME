class CartItem {
  final String id;
  final String productId;
  final String productName;
  final double price;
  int quantity;
  final String shopId;
  final String shopName;

  CartItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.price,
    this.quantity = 1,
    required this.shopId,
    required this.shopName,
  });
}