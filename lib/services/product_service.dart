import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all products
  Stream<List<Product>> getProducts() {
    return _firestore
        .collection('products')
        .where('isAvailable', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Product.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  // Get product by ID
  Future<Product?> getProductById(String productId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('products')
          .doc(productId)
          .get();
      if (doc.exists) {
        return Product.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get product: $e');
    }
  }

  // Get products by category
  Stream<List<Product>> getProductsByCategory(String category) {
    return _firestore
        .collection('products')
        .where('category', isEqualTo: category)
        .where('isAvailable', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Product.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  // Search products
  Stream<List<Product>> searchProducts(String query) {
    return _firestore
        .collection('products')
        .where('isAvailable', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Product.fromMap(doc.data(), doc.id))
              .where(
                (product) =>
                    product.name.toLowerCase().contains(query.toLowerCase()) ||
                    product.description.toLowerCase().contains(
                      query.toLowerCase(),
                    ),
              )
              .toList();
        });
  }

  // Update product stock
  Future<void> updateProductStock(String productId, int newStock) async {
    try {
      await _firestore.collection('products').doc(productId).update({
        'stock': newStock,
      });
    } catch (e) {
      throw Exception('Failed to update product stock: $e');
    }
  }

  // Add new product (for admin use)
  Future<void> addProduct(Product product) async {
    try {
      await _firestore.collection('products').add(product.toMap());
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  // Update product (for admin use)
  Future<void> updateProduct(
    String productId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore.collection('products').doc(productId).update(data);
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  // Delete product (for admin use)
  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }
}
