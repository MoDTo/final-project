import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_app/screens/home/product_detail_screen.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  List<Map<String, dynamic>> savedProducts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedProducts();
  }

  Future<void> _loadSavedProducts() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      return;
    }

    try {
      final savedDocs = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('saved_products')
          .get();

      List<Map<String, dynamic>> products = [];
      for (var doc in savedDocs.docs) {
        // Search for products by name since saved_products uses product names as IDs
        final productQuery = await FirebaseFirestore.instance
            .collection('products')
            .where('name', isEqualTo: doc.id)
            .get();

        if (productQuery.docs.isNotEmpty) {
          final productDoc = productQuery.docs.first;
          products.add({'id': productDoc.id, ...productDoc.data()});
        }
      }

      if (mounted) {
        setState(() {
          savedProducts = products;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _removeFromSaved(String productName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('saved_products')
          .doc(productName)
          .delete();

      if (mounted) {
        setState(() {
          savedProducts.removeWhere(
            (product) => product['name'] == productName,
          );
        });
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('นำออกจากสินค้าที่บันทึกแล้ว'),
          duration: Duration(seconds: 1),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('เกิดข้อผิดพลาดในการนำออก'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String formatPrice(dynamic price) {
    if (price == null) return '';
    int? value;
    if (price is int) {
      value = price;
    } else if (price is String) {
      value = int.tryParse(price.replaceAll(RegExp(r'[^0-9]'), ''));
    }
    if (value == null) return '';
    return "${value.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',')} KIP";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Saved Products',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1A1A1A)),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1A1A1A)),
              ),
            )
          : savedProducts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Icon(
                      Icons.favorite_border,
                      size: 60,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No Saved Products',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'สินค้าที่คุณบันทึกจะแสดงที่นี่',
                    style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadSavedProducts,
              color: const Color(0xFF1A1A1A),
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: savedProducts.length,
                itemBuilder: (context, index) {
                  final product = savedProducts[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailPage(product: product),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              // Product Image
                              if (product['image'] != null)
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8F9FA),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child:
                                        product['image'] != null &&
                                            product['image']
                                                .toString()
                                                .isNotEmpty
                                        ? Image.network(
                                            product['image'],
                                            fit: BoxFit.cover,
                                          )
                                        : Icon(
                                            Icons.image,
                                            size: 40,
                                            color: Colors.grey[400],
                                          ),
                                  ),
                                ),

                              const SizedBox(width: 16),

                              // Product Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product['name'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1A1A1A),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    if (product['description'] != null)
                                      Text(
                                        product['description'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    const SizedBox(height: 8),
                                    Text(
                                      formatPrice(product['price']),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1A1A1A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Remove Button
                              IconButton(
                                onPressed: () =>
                                    _removeFromSaved(product['name']),
                                icon: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8F9FA),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
