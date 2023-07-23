class Product {
  final String name;
  final double price;
  int quantity;
  Product({required this.name, required this.price, this.quantity = 1});
  factory Product.fromJson(Map<String, dynamic> json) => Product(
      name: json['name'], price: json['price'], quantity: json['quantity']);
  Map<String, dynamic> toJson() =>
      {'name': name, 'price': price, 'quantity': quantity};
}
