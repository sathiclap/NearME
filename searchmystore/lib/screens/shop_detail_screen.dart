import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchmystore/models/shop.dart';
import 'package:searchmystore/providers/products_provider.dart';
import 'package:searchmystore/widgets/product_item.dart';

class ShopDetailScreen extends StatefulWidget {
  final Shop shop;

  ShopDetailScreen(this.shop);

  @override
  _ShopDetailScreenState createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchShopProducts();
  }

  Future<void> _fetchShopProducts() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      await Provider.of<ProductsProvider>(context, listen: false)
          .fetchAndSetProducts(shopId: widget.shop.id);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load products. Please try again later.'),
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
    final productsData = Provider.of<ProductsProvider>(context);
    final shopProducts = productsData.getProductsByShopId(widget.shop.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shop.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              child: Image.network(
                widget.shop.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.shop.name,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber),
                          SizedBox(width: 4),
                          Text(
                            widget.shop.rating.toString(),
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.grey),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.shop.address,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (widget.shop.distance != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Row(
                        children: [
                          Icon(Icons.directions, color: Colors.grey),
                          SizedBox(width: 4),
                          Text(
                            '${widget.shop.distance!.toStringAsFixed(1)} km away',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 24),
                  Text(
                    'Products',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : shopProducts.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text('No products available in this shop.'),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(16.0),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2 / 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: shopProducts.length,
                        itemBuilder: (ctx, i) => ProductItem(shopProducts[i]),
                      ),
          ],
        ),
      ),
    );
  }
}
