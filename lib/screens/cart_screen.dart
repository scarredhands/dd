import 'package:flutter/material.dart';

import '../services/firestore_service.dart';

class CartScreen extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: FutureBuilder(
        future: firestoreService.getCartItems(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Cart is empty!'));
          }
          var cartItems = snapshot.data!;
          double totalAmount = 0;
          cartItems.forEach((item) {
            totalAmount += item['quantity'] * 50; // Static price for simplicity
          });
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    var item = cartItems[index];
                    return ListTile(
                      title: Text('Product ID: ${item['productId']}'),
                      subtitle: Text('Quantity: ${item['quantity']}'),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  firestoreService.placeOrder(cartItems, totalAmount);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Order placed successfully!')),
                  );
                },
                child: Text(
                  'Place Order (\$${totalAmount.toStringAsFixed(2)})',
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
