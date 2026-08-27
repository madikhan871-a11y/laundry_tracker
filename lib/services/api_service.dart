import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/app_constants.dart';

class ApiService {
  Future<List<Map<String, dynamic>>> fetchOrders() async {
    final uri = Uri.parse(
      '${AppConstants.apiBaseUrl}/posts?_limit=8',
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data is List) {
        return data
            .map(
              (item) => Map<String, dynamic>.from(item as Map),
        )
            .toList();
      }
    }

    throw Exception(
      'Unable to load laundry orders. '
          'Status: ${response.statusCode}',
    );
  }

  Future<Map<String, dynamic>> createOrder(
      Map<String, dynamic> order,
      ) async {
    final uri = Uri.parse(
      '${AppConstants.apiBaseUrl}/posts',
    );

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(order),
    );

    if (response.statusCode == 201) {
      return Map<String, dynamic>.from(
        jsonDecode(response.body) as Map,
      );
    }

    throw Exception(
      'Unable to create order. '
          'Status: ${response.statusCode}',
    );
  }
}