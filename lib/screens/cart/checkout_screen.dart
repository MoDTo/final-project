import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../utils/app_localizations.dart';

class CheckoutPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalPrice;

  const CheckoutPage({
    super.key,
    required this.cartItems,
    required this.totalPrice,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedPaymentMethod = 'cash';
  bool _useCurrentLocation = false;

  // User data variables
  String _userName = '';
  String _userPhone = '';
  bool _isLoadingUserData = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (!mounted) return;

        setState(() {
          _userName = doc.data()?['username'] ?? '';
          _userPhone = doc.data()?['tel'] ?? '';
          _isLoadingUserData = false;
        });
      } catch (e) {
        if (!mounted) return;
        setState(() {
          _isLoadingUserData = false;
        });
      }
    } else {
      setState(() {
        _isLoadingUserData = false;
      });
    }
  }

  Future<void> _submitOrder() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('กรุณาเข้าสู่ระบบก่อนสั่งซื้อ'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // ดึงข้อมูล user จาก Firestore
      try {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (!userDoc.exists) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('ไม่พบข้อมูลผู้ใช้ กรุณาลงทะเบียนใหม่'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        final userData = userDoc.data()!;
        final userName = userData['username'] ?? '';
        final userPhone = userData['tel'] ?? '';
        final userEmail = userData['email'] ?? '';

        // เตรียมข้อมูลออเดอร์
        final orderData = {
          'items': widget.cartItems
              .map(
                (item) => {
                  'name': item['product']['name'],
                  'price': item['product']['price'],
                  'quantity': item['quantity'],
                },
              )
              .toList(),
          'totalPrice': widget.totalPrice,
          'customerName': userName,
          'tel': userPhone,
          'email': userEmail,
          'address': _addressController.text,
          'notes': _notesController.text,
          'paymentMethod': _selectedPaymentMethod,
          'createdAt': FieldValue.serverTimestamp(),
          'status': 'pending',
          'userId': user.uid,
          'userEmail': user.email,
        };

        await FirebaseFirestore.instance.collection('orders').add(orderData);

        // ลบ cart ของ user หลังสั่งซื้อ
        final cartRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('cart');
        final cartItems = await cartRef.get();
        for (var doc in cartItems.docs) {
          await doc.reference.delete();
        }

        if (!mounted) return;

        // Show success dialog
        showDialog(
          context: context,
          builder: (context) {
            final l10n = AppLocalizations.of(context);
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                l10n.get('order_success'),
                style: const TextStyle(
                  color: Color(0xFF1A1A1A),
                  fontWeight: FontWeight.w600,
                ),
              ),
              content: Text(
                l10n.get('order_success_message'),
                style: const TextStyle(color: Color(0xFF1A1A1A)),
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A1A1A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pop(); // Go back to cart
                    Navigator.of(context).pop(); // Go back to home
                  },
                  child: Text(
                    l10n.get('ok'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      } catch (e) {
        if (!mounted) return;
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.get('error')}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ฟังก์ชันดึงตำแหน่งปัจจุบัน
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // เก็บ context ไว้ก่อนเพื่อใช้กับ SnackBar
    final messenger = ScaffoldMessenger.of(context);

    // ตรวจสอบว่าเปิด location service หรือยัง
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // ถ้ายังไม่เปิด
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(
          content: Text('กรุณาเปิดบริการตำแหน่ง'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // ขอ permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (!mounted) return;
        messenger.showSnackBar(
          const SnackBar(
            content: Text('การอนุญาตตำแหน่งถูกปฏิเสธ'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(
          content: Text('การอนุญาตตำแหน่งถูกปฏิเสธอย่างถาวร'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // ดึงตำแหน่ง
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    if (!mounted) return;
    setState(() {
      _addressController.text =
          'Lat: ${position.latitude}, Lng: ${position.longitude}';
    });
  }

  String formatPrice(dynamic price) {
    if (price == null) return '';
    int? value;
    if (price is int) {
      value = price;
    } else if (price is String) {
      value = int.tryParse(price.replaceAll(RegExp(r'[^0-9]'), ''));
    } else if (price is double) {
      value = price.toInt();
    }
    if (value == null) return '';
    return value.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          l10n.get('checkout'),
          style: const TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1A1A1A)),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Order Summary
            _buildOrderSummary(),
            const SizedBox(height: 20),

            // Customer Information
            _buildCustomerInfo(),
            const SizedBox(height: 20),

            // Delivery Information
            _buildDeliveryInfo(),
            const SizedBox(height: 20),

            // Payment Method
            _buildPaymentMethod(),
            const SizedBox(height: 20),

            // Order Notes
            _buildOrderNotes(),
            const SizedBox(height: 32),

            // Place Order Button
            _buildPlaceOrderButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.get('order_summary'),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),
          ...widget.cartItems.map((item) {
            final product = item['product'] as Map<String, dynamic>;
            final quantity = item['quantity'] as int;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${product['name']?.toString() ?? ''} x$quantity',
                      style: const TextStyle(color: Color(0xFF1A1A1A)),
                    ),
                  ),
                  Text(
                    product['price'] != null
                        ? '${formatPrice(product['price'])} KIP'
                        : '',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
            );
          }),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${l10n.get('total')}:',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              Text(
                '${formatPrice(widget.totalPrice.toStringAsFixed(0))} KIP',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerInfo() {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.get('customer_info'),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),
          if (_isLoadingUserData)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1A1A1A)),
              ),
            )
          else ...[
            Row(
              children: [
                const Icon(Icons.person, color: Color(0xFF1A1A1A), size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _userName.isNotEmpty ? _userName : 'ไม่ระบุชื่อ',
                    style: const TextStyle(
                      color: Color(0xFF1A1A1A),
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.phone, color: Color(0xFF1A1A1A), size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _userPhone.isNotEmpty ? _userPhone : 'ไม่ระบุเบอร์โทร',
                    style: const TextStyle(
                      color: Color(0xFF1A1A1A),
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDeliveryInfo() {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.get('delivery_info'),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            title: Text(
              l10n.get('use_current_location'),
              style: const TextStyle(color: Color(0xFF1A1A1A)),
            ),
            subtitle: Text(
              l10n.get('gps_note'),
              style: const TextStyle(color: Colors.grey),
            ),
            value: _useCurrentLocation,
            onChanged: (value) {
              setState(() {
                _useCurrentLocation = value ?? false;
                if (_useCurrentLocation) {
                  _getCurrentLocation();
                } else {
                  _addressController.clear();
                }
              });
            },
            contentPadding: EdgeInsets.zero,
            activeColor: const Color(0xFF1A1A1A),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _addressController,
            enabled: !_useCurrentLocation,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: l10n.get('delivery_address'),
              hintText: l10n.get('enter_delivery_address'),
              prefixIcon: const Icon(
                Icons.location_on,
                color: Color(0xFF1A1A1A),
              ),
              filled: true,
              fillColor: const Color(0xFFF8F9FA),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF1A1A1A),
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
            ),
            validator: (value) {
              if (!_useCurrentLocation && (value == null || value.isEmpty)) {
                return l10n.get('please_enter_delivery_address');
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod() {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.get('payment_method'),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),
          RadioListTile<String>(
            title: Text(
              l10n.get('cash_on_delivery'),
              style: const TextStyle(color: Color(0xFF1A1A1A)),
            ),
            subtitle: Text(
              l10n.get('pay_on_delivery'),
              style: const TextStyle(color: Colors.grey),
            ),
            value: 'cash',
            groupValue: _selectedPaymentMethod,
            onChanged: (value) {
              setState(() {
                _selectedPaymentMethod = value!;
              });
            },
            activeColor: const Color(0xFF1A1A1A),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderNotes() {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.get('order_note_optional'),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _notesController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: l10n.get('add_special_instructions'),
              prefixIcon: const Icon(Icons.note, color: Color(0xFF1A1A1A)),
              filled: true,
              fillColor: const Color(0xFFF8F9FA),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF1A1A1A),
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceOrderButton() {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A1A1A),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        onPressed: _submitOrder,
        child: Text(
          l10n.get('place_order'),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
