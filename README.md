# Food Delivery App

แอปส่งอาหารที่พัฒนาด้วย Flutter และเชื่อมต่อกับ Firebase

## โครงสร้างโปรเจค

```
lib/
├── main.dart                    # Entry point ของแอป
├── firebase_options.dart        # การตั้งค่า Firebase
├── models/                      # Model classes
│   ├── product.dart            # โมเดลสินค้า
│   ├── order.dart              # โมเดลออเดอร์
│   └── user.dart               # โมเดลผู้ใช้
├── services/                    # Firebase services
│   ├── auth_service.dart       # บริการ Authentication
│   ├── product_service.dart    # บริการจัดการสินค้า
│   └── order_service.dart      # บริการจัดการออเดอร์
├── screens/                     # หน้าต่างๆ ของแอป
│   ├── login/                  # หน้าล็อกอิน/สมัครสมาชิก
│   ├── home/                   # หน้าหลักและสินค้า
│   ├── cart/                   # หน้าตะกร้า
│   ├── orders/                 # หน้าประวัติออเดอร์
│   └── profile/                # หน้าข้อมูลผู้ใช้
├── widgets/                     # Custom widgets
│   ├── product_card.dart       # การ์ดสินค้า
│   ├── custom_button.dart      # ปุ่มที่ใช้ซ้ำ
│   └── custom_textfield.dart   # ช่องกรอกข้อมูล
└── utils/                       # Utility functions
    ├── format.dart             # ฟังก์ชันฟอร์แมตข้อมูล
    └── validator.dart          # ฟังก์ชันตรวจสอบข้อมูล

assets/
└── images/                      # รูปภาพ
    ├── foodlogo.png            # โลโก้แอป
    └── angus_reserve.png       # รูปสินค้า
```

## ฟีเจอร์หลัก

- **Authentication**: ล็อกอิน/สมัครสมาชิกด้วย Firebase Auth
- **Product Management**: แสดงสินค้าและจัดการสต็อก
- **Shopping Cart**: เพิ่มสินค้าลงตะกร้าและจัดการจำนวน
- **Order Management**: สร้างออเดอร์และติดตามสถานะ
- **User Profile**: จัดการข้อมูลผู้ใช้
- **Real-time Updates**: อัปเดตข้อมูลแบบ real-time ด้วย Firestore

## การติดตั้ง

1. Clone โปรเจค
2. รัน `flutter pub get` เพื่อติดตั้ง dependencies
3. ตั้งค่า Firebase ใน `firebase_options.dart`
4. รัน `flutter run` เพื่อเริ่มแอป

## Dependencies หลัก

- `firebase_core`: Firebase Core
- `firebase_auth`: Firebase Authentication
- `cloud_firestore`: Cloud Firestore
- `firebase_storage`: Firebase Storage
- `intl`: Internationalization
- `image_picker`: เลือกรูปภาพ
- `path_provider`: จัดการไฟล์

## การใช้งาน

1. **ล็อกอิน/สมัครสมาชิก**: ใช้อีเมลและรหัสผ่าน
2. **ดูสินค้า**: เลือกสินค้าจากหน้าแรก
3. **เพิ่มลงตะกร้า**: กดปุ่ม "เพิ่มลงตะกร้า" ในสินค้า
4. **สั่งซื้อ**: ไปที่ตะกร้าและทำการสั่งซื้อ
5. **ติดตามออเดอร์**: ดูสถานะออเดอร์ในหน้า "My Orders"

## การพัฒนา

- ใช้ **MVVM Architecture** pattern
- แยก **Services** สำหรับจัดการข้อมูล
- ใช้ **Custom Widgets** เพื่อความสม่ำเสมอ
- รองรับ **Responsive Design**
- ใช้ **Material Design 3** components
