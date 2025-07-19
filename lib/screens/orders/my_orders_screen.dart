import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../utils/app_localizations.dart';

class MyOrderPage extends StatelessWidget {
  const MyOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            l10n.get('my_orders'),
            style: const TextStyle(
              color: Color(0xFF1A1A1A),
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Color(0xFF1A1A1A)),
        ),
        body: Center(
          child: Text(
            l10n.get('login_to_view_orders'),
            style: const TextStyle(color: Color(0xFF1A1A1A), fontSize: 16),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          l10n.get('my_orders'),
          style: const TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1A1A1A)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: user.uid)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1A1A1A)),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    l10n.get('error'),
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return Center(
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
                      Icons.receipt_long_outlined,
                      size: 60,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.get('no_orders'),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.get('no_orders_subtitle'),
                    style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              // Trigger a rebuild of the StreamBuilder
            },
            color: const Color(0xFF1A1A1A),
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final order = docs[index].data() as Map<String, dynamic>;
                return _buildOrderCard(context, order);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Map<String, dynamic> order) {
    final l10n = AppLocalizations.of(context);
    Color statusColor;
    String statusLabel;
    IconData statusIcon;

    switch (order['status']) {
      case 'delivered':
        statusColor = Colors.green;
        statusLabel = l10n.get('delivered');
        statusIcon = Icons.check_circle;
        break;
      case 'shipping':
        statusColor = Colors.blue;
        statusLabel = 'Shipping';
        statusIcon = Icons.local_shipping;
        break;
      case 'on_the_way':
      case 'on the way':
        statusColor = Colors.orange;
        statusLabel = 'On the way';
        statusIcon = Icons.directions_bike;
        break;
      case 'preparing':
        statusColor = Colors.purple;
        statusLabel = 'Preparing';
        statusIcon = Icons.restaurant;
        break;
      case 'received':
        statusColor = Colors.teal;
        statusLabel = l10n.get('received');
        statusIcon = Icons.assignment_turned_in;
        break;
      default:
        statusColor = Colors.grey;
        statusLabel = l10n.get('pending');
        statusIcon = Icons.schedule;
    }

    String dateStr = '';
    if (order['createdAt'] != null && order['createdAt'] is Timestamp) {
      final dt = (order['createdAt'] as Timestamp).toDate();
      dateStr = '${dt.day} ${_monthName(dt.month, l10n)} ${dt.year}';
    }

    final items = order['items'] as List<dynamic>? ?? [];
    final itemStr = items
        .map((e) {
          final name = e['name'] ?? '';
          final qty = e['quantity'] ?? 1;
          return '$name x$qty';
        })
        .join(', ');

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
        (m) => ',',
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Order ID and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${l10n.get('my_orders')} #${order['orderId'] ?? order['id'] ?? order['createdAt']?.seconds ?? ''}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 16, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        statusLabel,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Date
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  dateStr,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Items
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.get('order_items'),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    itemStr,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Total and Details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.get('total'),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      '${formatPrice(order['totalPrice'])} KIP',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    // รายละเอียดเพิ่มเติม
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF1A1A1A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    l10n.get('order_details'),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _monthName(int month, AppLocalizations l10n) {
    final months = {
      'th': [
        '',
        'มกราคม',
        'กุมภาพันธ์',
        'มีนาคม',
        'เมษายน',
        'พฤษภาคม',
        'มิถุนายน',
        'กรกฎาคม',
        'สิงหาคม',
        'กันยายน',
        'ตุลาคม',
        'พฤศจิกายน',
        'ธันวาคม',
      ],
      'en': [
        '',
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ],
      'lo': [
        '',
        'ມັງກອນ',
        'ກຸມພາ',
        'ມີນາ',
        'ເມສາ',
        'ພຶດສະພາ',
        'ມິຖຸນາ',
        'ກໍລະກົດ',
        'ສິງຫາ',
        'ກັນຍາ',
        'ຕຸລາ',
        'ພະຈິກ',
        'ທັນວາ',
      ],
    };
    return months[l10n.locale.languageCode]?[month] ?? months['th']![month];
  }
}
