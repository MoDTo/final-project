import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'th': {
      // Profile
      'profile': 'โปรไฟล์',
      'edit_profile': 'แก้ไขโปรไฟล์',
      'my_orders': 'คำสั่งซื้อของฉัน',
      'saved_products': 'สินค้าที่บันทึก',
      'notifications': 'การแจ้งเตือน',
      'help': 'ช่วยเหลือ',
      'logout': 'ออกจากระบบ',
      'logout_subtitle': 'ออกจากบัญชีของคุณ',
      'logout_confirm': 'คุณต้องการออกจากระบบหรือไม่?',
      'language': 'ภาษา',
      'language_subtitle': 'เลือกภาษาที่ต้องการ',
      'my_orders_subtitle': 'ดูประวัติการสั่งซื้อ',
      'saved_products_subtitle': 'สินค้าที่คุณชอบ',
      'notifications_subtitle': 'จัดการการแจ้งเตือน',
      'help_subtitle': 'ติดต่อฝ่ายสนับสนุน',
      'login_to_view_orders': 'กรุณาเข้าสู่ระบบเพื่อดูคำสั่งซื้อของคุณ',
      'received': 'ได้รับสินค้า',
      'language_change_info':
          'การเปลี่ยนแปลงภาษาจะมีผลทันทีและจะถูกบันทึกไว้สำหรับการใช้งานครั้งต่อไป',
      'language_changed_to': 'เปลี่ยนภาษาเป็น {lang}',

      // Cart
      'cart': 'ตะกร้าสินค้า',
      'empty_cart': 'ตะกร้าสินค้าว่าง',
      'empty_cart_subtitle': 'เพิ่มสินค้าลงตะกร้าเพื่อเริ่มช้อปปิ้ง',
      'total': 'รวมทั้งหมด',
      'proceed_to_checkout': 'ดำเนินการสั่งซื้อ',

      // Checkout
      'checkout': 'ชำระเงิน',
      'order_summary': 'สรุปคำสั่งซื้อ',
      'customer_info': 'ข้อมูลลูกค้า',
      'delivery_info': 'ข้อมูลการจัดส่ง',
      'payment_method': 'วิธีการชำระเงิน',
      'order_notes': 'หมายเหตุ (ไม่บังคับ)',
      'place_order': 'ยืนยันคำสั่งซื้อ',
      'order_success': 'สั่งซื้อสำเร็จ!',
      'order_success_message': 'คำสั่งซื้อของคุณได้รับการยืนยันแล้ว',
      'ok': 'ตกลง',

      // Orders
      'no_orders': 'ยังไม่มีคำสั่งซื้อ',
      'no_orders_subtitle': 'คำสั่งซื้อของคุณจะแสดงที่นี่',
      'order_details': 'ดูรายละเอียด',
      'order_items': 'รายการสินค้า',
      'delivered': 'จัดส่งแล้ว',
      'on_the_way': 'กำลังจัดส่ง',
      'preparing': 'กำลังเตรียม',
      'pending': 'รอดำเนินการ',

      // Common
      'loading': 'กำลังโหลด...',
      'error': 'เกิดข้อผิดพลาด',
      'cancel': 'ยกเลิก',
      'save': 'บันทึก',
      'edit': 'แก้ไข',
      'delete': 'ลบ',
      'confirm': 'ยืนยัน',
      'back': 'กลับ',
      'next': 'ถัดไป',
      'done': 'เสร็จสิ้น',

      // Edit Profile
      'change_profile_picture': 'เปลี่ยนรูปโปรไฟล์',
      'personal_info': 'ข้อมูลส่วนตัว',
      'full_name': 'ชื่อ-นามสกุล',
      'email': 'อีเมล',
      'phone': 'เบอร์โทรศัพท์',
      'birthday': 'วันเกิด',
      'new_password': 'รหัสผ่านใหม่',
      'password_min_length': 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร',
    },
    'en': {
      // Profile
      'profile': 'Profile',
      'edit_profile': 'Edit Profile',
      'my_orders': 'My Orders',
      'saved_products': 'Saved Products',
      'notifications': 'Notifications',
      'help': 'Help',
      'logout': 'Logout',
      'logout_subtitle': 'Sign out of your account',
      'logout_confirm': 'Are you sure you want to logout?',
      'language': 'Language',
      'language_subtitle': 'Choose your preferred language',
      'my_orders_subtitle': 'View your order history',
      'saved_products_subtitle': 'Your favorite products',
      'notifications_subtitle': 'Manage notifications',
      'help_subtitle': 'Contact support',
      'login_to_view_orders': 'Please log in to view your orders',
      'received': 'Received',
      'language_change_info':
          'Language change will take effect immediately and will be saved for future use.',
      'language_changed_to': 'Language changed to {lang}',

      // Cart
      'cart': 'My Cart',
      'empty_cart': 'Your cart is empty',
      'empty_cart_subtitle': 'Add items to your cart to start shopping',
      'total': 'Total',
      'proceed_to_checkout': 'Proceed to Checkout',

      // Checkout
      'checkout': 'Checkout',
      'order_summary': 'Order Summary',
      'customer_info': 'Customer Information',
      'delivery_info': 'Delivery Information',
      'payment_method': 'Payment Method',
      'order_notes': 'Order Notes (Optional)',
      'place_order': 'Place Order',
      'order_success': 'Order Confirmed!',
      'order_success_message': 'Your order has been placed successfully',
      'ok': 'OK',

      // Orders
      'no_orders': 'No orders yet',
      'no_orders_subtitle': 'Your orders will appear here',
      'order_details': 'View Details',
      'order_items': 'Order Items',
      'delivered': 'Delivered',
      'on_the_way': 'On the way',
      'preparing': 'Preparing',
      'pending': 'Pending',

      // Common
      'loading': 'Loading...',
      'error': 'Error',
      'cancel': 'Cancel',
      'save': 'Save',
      'edit': 'Edit',
      'delete': 'Delete',
      'confirm': 'Confirm',
      'back': 'Back',
      'next': 'Next',
      'done': 'Done',

      // Edit Profile
      'change_profile_picture': 'Change Profile Picture',
      'personal_info': 'Personal Information',
      'full_name': 'Full Name',
      'email': 'Email',
      'phone': 'Phone Number',
      'birthday': 'Birthday',
      'new_password': 'New Password',
      'password_min_length': 'Password must be at least 6 characters',
    },
    'lo': {
      // Profile
      'profile': 'ໂປຣໄຟລ໌',
      'edit_profile': 'ແກ້ໄຂໂປຣໄຟລ໌',
      'my_orders': 'ຄຳສັ່ງຊື້ຂອງຂ້ອຍ',
      'saved_products': 'ສິນຄ້າທີ່ບັນທຶກ',
      'notifications': 'ການແຈ້ງເຕືອນ',
      'help': 'ຊ່ວຍເຫຼືອ',
      'logout': 'ອອກຈາກລະບົບ',
      'logout_subtitle': 'ອອກຈາກບັນຊີຂອງທ່ານ',
      'logout_confirm': 'ທ່ານຕ້ອງການອອກຈາກລະບົບບໍ?',
      'language': 'ພາສາ',
      'language_subtitle': 'ເລືອກພາສາທີ່ຕ້ອງການ',
      'my_orders_subtitle': 'ເບິ່ງປະຫວັດການສັ່ງຊື້',
      'saved_products_subtitle': 'ສິນຄ້າທີ່ທ່ານມັກ',
      'notifications_subtitle': 'ຈັດການການແຈ້ງເຕືອນ',
      'help_subtitle': 'ຕິດຕໍ່ສະຫນັບສະໜູນ',
      'login_to_view_orders': 'ກະລຸນາເຂົ້າລະບົບເພື່ອເບິ່ງຄຳສັ່ງຊື້ຂອງທ່ານ',
      'received': 'ໄດ້ຮັບສິນຄ້າແລ້ວ',
      'language_change_info':
          'ການປ່ຽນພາສາຈະມີຜົນທັນທີ ແລະຈະຖືກບັນທຶກໄວ້ສໍາລັບການໃຊ້ງານຄັ້ງຕໍ່ໄປ',
      'language_changed_to': 'ປ່ຽນພາສາເປັນ {lang}',

      // Cart
      'cart': 'ກະຕ່າສິນຄ້າ',
      'empty_cart': 'ກະຕ່າສິນຄ້າວ່າງ',
      'empty_cart_subtitle': 'ເພີ່ມສິນຄ້າລົງກະຕ່າເພື່ອເລີ່ມຊື້ເຄື່ອງ',
      'total': 'ລວມທັງໝົດ',
      'proceed_to_checkout': 'ດຳເນີນການສັ່ງຊື້',

      // Checkout
      'checkout': 'ຊຳລະເງິນ',
      'order_summary': 'ສະຫຼຸບຄຳສັ່ງຊື້',
      'customer_info': 'ຂໍ້ມູນລູກຄ້າ',
      'delivery_info': 'ຂໍ້ມູນການຈັດສົ່ງ',
      'payment_method': 'ວິທີການຊຳລະເງິນ',
      'order_notes': 'ໝາຍເຫດ (ບໍ່ບັງຄັບ)',
      'place_order': 'ຢືນຢັນຄຳສັ່ງຊື້',
      'order_success': 'ສັ່ງຊື້ສຳເລັດ!',
      'order_success_message': 'ຄຳສັ່ງຊື້ຂອງທ່ານໄດ້ຮັບການຢືນຢັນແລ້ວ',
      'ok': 'ຕົກລົງ',

      // Orders
      'no_orders': 'ຍັງບໍ່ມີຄຳສັ່ງຊື້',
      'no_orders_subtitle': 'ຄຳສັ່ງຊື້ຂອງທ່ານຈະສະແດງທີ່ນີ້',
      'order_details': 'ເບິ່ງລາຍລະອຽດ',
      'order_items': 'ລາຍການສິນຄ້າ',
      'delivered': 'ຈັດສົ່ງແລ້ວ',
      'on_the_way': 'ກຳລັງຈັດສົ່ງ',
      'preparing': 'ກຳລັງເຕີມພ້ອມ',
      'pending': 'ລໍຖ້າດຳເນີນການ',

      // Common
      'loading': 'ກຳລັງໂຫຼດ...',
      'error': 'ຜິດພາດ',
      'cancel': 'ຍົກເລີກ',
      'save': 'ບັນທຶກ',
      'edit': 'ແກ້ໄຂ',
      'delete': 'ລຶບ',
      'confirm': 'ຢືນຢັນ',
      'back': 'ກັບ',
      'next': 'ຕໍ່ໄປ',
      'done': 'ເຮັດແລ້ວ',

      // Edit Profile
      'change_profile_picture': 'ປ່ຽນຮູບໂປຣໄຟລ໌',
      'personal_info': 'ຂໍ້ມູນສ່ວນໂຕ',
      'full_name': 'ຊື່-ນາມສະກຸນ',
      'email': 'ອີເມວ',
      'phone': 'ເບີໂທລະສັບ',
      'birthday': 'ວັນເກີດ',
      'new_password': 'ລະຫັດຜ່ານໃໝ່',
      'password_min_length': 'ລະຫັດຜ່ານຕ້ອງຢ່າງນ້ອຍ 6 ຕົວອັກສອນ',
    },
  };

  String get(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['th']![key] ??
        key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['th', 'en', 'lo'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
