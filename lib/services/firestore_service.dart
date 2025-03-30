import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference productsCollection = FirebaseFirestore.instance
      .collection('products');
  final CollectionReference cartCollection = FirebaseFirestore.instance
      .collection('cart');
  final CollectionReference ordersCollection = FirebaseFirestore.instance
      .collection('orders');

  // Get all products
  Future<List<Map<String, dynamic>>> getProducts() async {
    QuerySnapshot snapshot = await productsCollection.get();
    return snapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  // Add item to cart
  Future<void> addToCart(String productId, int quantity) async {
    await cartCollection.add({'productId': productId, 'quantity': quantity});
  }

  // Get cart items
  Future<List<Map<String, dynamic>>> getCartItems() async {
    QuerySnapshot snapshot = await cartCollection.get();
    return snapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  // Place an order
  Future<void> placeOrder(
    List<Map<String, dynamic>> items,
    double totalAmount,
  ) async {
    await ordersCollection.add({'items': items, 'totalAmount': totalAmount});
    await clearCart();
  }

  // Clear cart after placing order
  Future<void> clearCart() async {
    QuerySnapshot snapshot = await cartCollection.get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}
