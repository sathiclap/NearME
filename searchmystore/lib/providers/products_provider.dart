import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:searchmystore/models/product.dart';
import 'package:searchmystore/utils/constants.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products {
    return [..._products];
  }

  Future<void> fetchAndSetProducts({String? query, String? shopId}) async {
    try {
      String url = '${AppConstants.BASE_URL}${AppConstants.PRODUCTS_ENDPOINT}';
      
      if (query != null && query.isNotEmpty) {
        url += '?search=$query';
      }
      
      if (shopId != null && shopId.isNotEmpty) {
        url += url.contains('?') ? '&shop_id=$shopId' : '?shop_id=$shopId';
      }
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body) as List<dynamic>;
        final List<Product> loadedProducts = [];
        
        for (var productData in extractedData) {
          loadedProducts.add(Product.fromJson(productData));
        }
        
        _products = loadedProducts;
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  List<Product> getProductsByShopId(String shopId) {
    return _products.where((product) => product.shopId == shopId).toList();
  }

  Product findById(String id) {
    return _products.firstWhere((product) => product.id == id);
  }
}
