import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchmystore/providers/shops_provider.dart';
import 'package:searchmystore/widgets/shop_item.dart';
import 'package:searchmystore/screens/search_screen.dart';
import 'package:searchmystore/screens/cart_screen.dart';
import 'package:searchmystore/providers/cart_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchShops();
  }

  Future<void> _fetchShops() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      await Provider.of<ShopsProvider>(context, listen: false).fetchAndSetShops();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load shops. Please try again later.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
    
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final shopsData = Provider.of<ShopsProvider>(context);
    final shops = shopsData.shops;
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
            ),
            SizedBox(width: 8),
            Text('Shop Finder'),
          ],
        ),
        actions: [
          IconButton(
            icon: Badge(
              label: Text(cart.itemCount.toString()),
              child: Icon(Icons.shopping_cart),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => CartScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => SearchScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search),
                  SizedBox(width: 8),
                  Text('Search Products'),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  'Shops Near You',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: RefreshIndicator(
                    onRefresh: _fetchShops,
                    child: shops.isEmpty
                        ? Center(
                            child: Text('No shops found in your area.'),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16.0),
                            itemCount: shops.length,
                            itemBuilder: (ctx, i) => ShopItem(shops[i]),
                          ),
                  ),
                ),
        ],
      ),
    );
  }
}
