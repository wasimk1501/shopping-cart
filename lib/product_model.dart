class Product {
  final String name;
  final double price;
  int quantity;
  bool? isFavorite;
  Product(
      {required this.name,
      required this.price,
      this.quantity = 1,
      this.isFavorite = false});
  factory Product.fromJson(Map<String, dynamic> json) => Product(
      name: json['name'],
      price: json['price'],
      quantity: json['quantity'],
      isFavorite: json['isFavorite'] ?? false);
  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        'quantity': quantity,
        'isFavorite': isFavorite
      };
}
