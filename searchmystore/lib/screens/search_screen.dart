import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchmystore/providers/products_provider.dart';
import 'package:searchmystore/widgets/product_item.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  bool _isLoading = false;
  bool _hasSearched = false;

  Future<void> _searchProducts(String query) async {
    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });
    
    try {
      await Provider.of<ProductsProvider>(context, listen: false)
          .fetchAndSetProducts(query: query);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to search products. Please try again later.'),
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
    final products = productsData.products;

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Products'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for products...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                  },
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  _searchProducts(value);
                }
              },
            ),
          ),
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : !_hasSearched
                  ? Center(
                      child: Text('Search for products above'),
                    )
                  : products.isEmpty
                      ? Center(
                          child: Text('No products found. Try another search term.'),
                        )
                      : Expanded(
                          child: GridView.builder(
                            padding: const EdgeInsets.all(16.0),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 2 / 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: products.length,
                            itemBuilder: (ctx, i) => ProductItem(products[i]),
                          ),
                        ),
        ],
      ),
    );
  }
}
