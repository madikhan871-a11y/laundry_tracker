import '../models/laundry_order_model.dart';
import 'api_service.dart';

class LaundryService {
  final ApiService _apiService = ApiService();

  Future<List<LaundryOrderModel>> fetchOrders() async {
    final apiData = await _apiService.fetchOrders();

    return apiData
        .map(
          (json) => LaundryOrderModel.fromApi(json),
    )
        .toList();
  }

  Future<LaundryOrderModel> createOrder({
    required String customerName,
    required String pickupDate,
    required String deliveryDate,
    required List<Map<String, dynamic>> items,
    required double total,
  }) async {
    final response = await _apiService.createOrder({
      'customerName': customerName,
      'pickupDate': pickupDate,
      'deliveryDate': deliveryDate,
      'items': items,
      'total': total,
    });

    return LaundryOrderModel.fromApi(response);
  }
}