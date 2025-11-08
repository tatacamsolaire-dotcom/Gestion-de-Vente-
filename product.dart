class Product {
  int? id;
  String name;
  String description;
  int purchasePrice;
  int salePrice;
  int quantity;
  String? imagePath;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.purchasePrice,
    required this.salePrice,
    required this.quantity,
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'purchasePrice': purchasePrice,
      'salePrice': salePrice,
      'quantity': quantity,
      'imagePath': imagePath,
    };
  }

  factory Product.fromMap(Map<String,dynamic> m) {
    return Product(
      id: m['id'],
      name: m['name'],
      description: m['description'] ?? '',
      purchasePrice: m['purchasePrice'] ?? 0,
      salePrice: m['salePrice'] ?? 0,
      quantity: m['quantity'] ?? 0,
      imagePath: m['imagePath'],
    );
  }
}
