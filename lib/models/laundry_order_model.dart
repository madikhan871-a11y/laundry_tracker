import 'laundry_item_model.dart';

class LaundryOrderModel {
  final String id;
  final String customerName;
  final String pickupDate;
  final String deliveryDate;
  final String status;
  final double total;
  final List<LaundryItemModel> items;

  const LaundryOrderModel({
    required this.id,
    required this.customerName,
    required this.pickupDate,
    required this.deliveryDate,
    required this.status,
    required this.total,
    required this.items,
  });

  factory LaundryOrderModel.fromApi(Map<String, dynamic> json) {
    final apiId = json['id']?.toString() ?? '1';

    final userId =
        int.tryParse(json['userId']?.toString() ?? '1') ?? 1;

    final title = json['title']?.toString() ?? 'Laundry Order';

    final quantity = (apiId.hashCode.abs() % 4) + 1;

    final price = 350.0 + (userId * 50);

    final item = LaundryItemModel(
      name: _formatTitle(title),
      quantity: quantity,
      price: price,
    );

    final total = item.total;

    return LaundryOrderModel(
      id: 'LF-${apiId.padLeft(4, '0')}',
      customerName: 'Customer $userId',
      pickupDate: _dateForId(apiId, 0),
      deliveryDate: _dateForId(apiId, 2),
      status: _statusForId(apiId),
      total: total,
      items: [item],
    );
  }

  static String _formatTitle(String title) {
    if (title.isEmpty) {
      return 'Laundry Item';
    }

    final words = title.split(' ');
    final selected = words.take(3).join(' ');

    return selected[0].toUpperCase() + selected.substring(1);
  }

  static String _statusForId(String id) {
    final number = int.tryParse(id) ?? 1;

    switch (number % 4) {
      case 0:
        return 'Delivered';
      case 1:
        return 'Pending';
      case 2:
        return 'Washing';
      default:
        return 'Ready';
    }
  }

  static String _dateForId(String id, int extraDays) {
    final number = int.tryParse(id) ?? 1;
    final date = DateTime.now().add(
      Duration(days: (number % 5) + extraDays),
    );

    return '${date.day.toString().padLeft(2, '0')} '
        '${_month(date.month)} ${date.year}';
  }

  static String _month(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return months[month - 1];
  }
}