class LaundryItemModel {
  final String name;
  final int quantity;
  final double price;

  const LaundryItemModel({
    required this.name,
    required this.quantity,
    required this.price,
  });

  double get total => quantity * price;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'price': price,
    };
  }

  factory LaundryItemModel.fromJson(Map<String, dynamic> json) {
    return LaundryItemModel(
      name: json['name']?.toString() ?? 'Laundry Item',
      quantity: int.tryParse(
        json['quantity']?.toString() ?? '1',
      ) ??
          1,
      price: double.tryParse(
        json['price']?.toString() ?? '0',
      ) ??
          0,
    );
  }
}