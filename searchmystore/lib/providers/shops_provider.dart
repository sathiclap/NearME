import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:searchmystore/models/shop.dart';
import 'package:searchmystore/utils/constants.dart';

class ShopsProvider with ChangeNotifier {
  List<Shop> _shops = [];
  Position? _userPosition;

  List<Shop> get shops {
    return [..._shops];
  }

  Future<void> fetchAndSetShops() async {
    try {
      final response = await http.get(Uri.parse('${AppConstants.BASE_URL}${AppConstants.SHOPS_ENDPOINT}'));
      
      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body) as List<dynamic>;
        final List<Shop> loadedShops = [];
        
        for (var shopData in extractedData) {
          loadedShops.add(Shop.fromJson(shopData));
        }
        
        _shops = loadedShops;
        await _calculateDistances();
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _calculateDistances() async {
    try {
      if (_userPosition == null) {
        _userPosition = await _determinePosition();
      }
      
      for (var shop in _shops) {
        shop.distance = Geolocator.distanceBetween(
          _userPosition!.latitude,
          _userPosition!.longitude,
          shop.latitude,
          shop.longitude,
        ) / 1000; // Convert to kilometers
      }
      
      _shops.sort((a, b) => a.distance!.compareTo(b.distance!));
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Shop findById(String id) {
    return _shops.firstWhere((shop) => shop.id == id);
  }
}