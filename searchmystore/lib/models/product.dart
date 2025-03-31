class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String shopId;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.shopId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: double.parse(json['price'].toString()),
      imageUrl: json['image_url'],
      shopId: json['shop_id'],
    );
  }
}
