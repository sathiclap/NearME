import 'package:flutter/material.dart';
import 'package:searchmystore/models/cart_item.dart';
import 'package:searchmystore/models/shop.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};
  String? _currentShopId;
  String? _currentShopName;

  Map<String, CartItem> get items {
    return {..._items};
  }

  String? get currentShopId {
    return _currentShopId;
  }

  String? get currentShopName {
    return _currentShopName;
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  bool canAddProductFromShop(String shopId, String shopName) {
    // If cart is empty, allow adding from any shop
    if (_items.isEmpty) {
      _currentShopId = shopId;
      _currentShopName = shopName;
      return true;
    }
    
    // If already have items, only allow from same shop
    return _currentShopId == shopId;
  }

  void addItem(String productId, String productName, double price, String shopId, String shopName) {
    // Check if we can add from this shop
    if (!canAddProductFromShop(shopId, shopName)) {
      throw Exception('Cannot add products from different shops to cart');
    }

    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          productId: existingCartItem.productId,
          productName: existingCartItem.productName,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
          shopId: existingCartItem.shopId,
          shopName: existingCartItem.shopName,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          productId: productId,
          productName: productName,
          price: price,
          shopId: shopId,
          shopName: shopName,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    
    // If cart is now empty, reset the current shop
    if (_items.isEmpty) {
      _currentShopId = null;
      _currentShopName = null;
    }
    
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          productId: existingCartItem.productId,
          productName: existingCartItem.productName,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity - 1,
          shopId: existingCartItem.shopId,
          shopName: existingCartItem.shopName,
        ),
      );
    } else {
      _items.remove(productId);
      
      // If cart is now empty, reset the current shop
      if (_items.isEmpty) {
        _currentShopId = null;
        _currentShopName = null;
      }
    }
    
    notifyListeners();
  }

  void clear() {
    _items = {};
    _currentShopId = null;
    _currentShopName = null;
    notifyListeners();
  }
}