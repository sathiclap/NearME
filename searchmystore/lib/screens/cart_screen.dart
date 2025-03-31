import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchmystore/providers/cart_provider.dart';
import 'package:searchmystore/widgets/cart_item.dart';
import 'package:searchmystore/screens/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          if (cart.currentShopName != null) 
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Icon(Icons.store, color: Theme.of(context).primaryColor),
                  SizedBox(width: 8),
                  Text(
                    'Shop: ${cart.currentShopName}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.titleLarge?.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  TextButton(
                    onPressed: cart.items.isEmpty
                        ? null
                        : () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => CheckoutScreen(),
                              ),
                            );
                          },
                    child: Text('CHECKOUT'),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: cart.items.isEmpty
                ? Center(
                    child: Text('Your cart is empty!'),
                  )
                : ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (ctx, i) {
                      final cartItem = cart.items.values.toList()[i];
                      final productId = cart.items.keys.toList()[i];
                      return CartItemWidget(
                        id: cartItem.id,
                        productId: productId,
                        price: cartItem.price,
                        quantity: cartItem.quantity,
                        title: cartItem.productName,
                        shopId:cartItem.shopId,
                        shopName: cartItem.shopName,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
