import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import '../models/order.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get user orders
  Stream<List<Order>> getUserOrders(String userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('orderDate', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Order.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  // Get order by ID
  Future<Order?> getOrderById(String orderId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('orders')
          .doc(orderId)
          .get();
      if (doc.exists) {
        return Order.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get order: $e');
    }
  }

  // Create new order
  Future<String> createOrder(Order order) async {
    try {
      DocumentReference docRef = await _firestore
          .collection('orders')
          .add(order.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  // Update order status
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': status,
      });
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  // Get all orders (for admin use)
  Stream<List<Order>> getAllOrders() {
    return _firestore
        .collection('orders')
        .orderBy('orderDate', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Order.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  // Get orders by status
  Stream<List<Order>> getOrdersByStatus(String status) {
    return _firestore
        .collection('orders')
        .where('status', isEqualTo: status)
        .orderBy('orderDate', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Order.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  // Delete order (for admin use)
  Future<void> deleteOrder(String orderId) async {
    try {
      await _firestore.collection('orders').doc(orderId).delete();
    } catch (e) {
      throw Exception('Failed to delete order: $e');
    }
  }
}
