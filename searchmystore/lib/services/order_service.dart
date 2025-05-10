import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:searchmystore/utils/constants.dart';

class OrderService {
  Future<void> saveOrder(Map<String, dynamic> orderData) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.BASE_URL}${AppConstants.ORDERS_ENDPOINT}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(orderData),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to save order');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<String?> getShopPhoneNumber(String shopId) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.BASE_URL}${AppConstants.SHOPS_ENDPOINT}/$shopId'),
      );

      if (response.statusCode == 200) {
        final shopData = json.decode(response.body);
        return shopData['phone_number'];
      }
      
      return null;
    } catch (error) {
      print('Error getting shop phone number: $error');
      return null;
    }
  }
}