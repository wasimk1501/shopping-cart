class Product {
  final String name;
  final double price;
  int quantity;
  Product({required this.name, required this.price, this.quantity = 1});
  Map<String, dynamic> toJson() =>
      {'name': name, 'price': price, 'quantity': quantity};
}
