class Sale {
  int? id;
  int productId;
  String productName;
  int quantity;
  int unitPrice;
  String clientName;
  String clientCity;
  String clientPhone;
  String date; // ISO string

  Sale({
    this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.clientName,
    required this.clientCity,
    required this.clientPhone,
    required this.date,
  });

  Map<String,dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'clientName': clientName,
      'clientCity': clientCity,
      'clientPhone': clientPhone,
      'date': date,
    };
  }

  factory Sale.fromMap(Map<String,dynamic> m) {
    return Sale(
      id: m['id'],
      productId: m['productId'],
      productName: m['productName'],
      quantity: m['quantity'],
      unitPrice: m['unitPrice'],
      clientName: m['clientName'] ?? '',
      clientCity: m['clientCity'] ?? '',
      clientPhone: m['clientPhone'] ?? '',
      date: m['date'] ?? '',
    );
  }
}
