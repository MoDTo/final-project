class Validator {
  // Email validation
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'กรุณากรอกอีเมล';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return 'กรุณากรอกอีเมลให้ถูกต้อง';
    }

    return null;
  }

  // Password validation
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'กรุณากรอกรหัสผ่าน';
    }

    if (password.length < 6) {
      return 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
    }

    return null;
  }

  // Confirm password validation
  static String? validateConfirmPassword(
    String? password,
    String? confirmPassword,
  ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'กรุณายืนยันรหัสผ่าน';
    }

    if (password != confirmPassword) {
      return 'รหัสผ่านไม่ตรงกัน';
    }

    return null;
  }

  // Name validation
  static String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'กรุณากรอกชื่อ';
    }

    if (name.length < 2) {
      return 'ชื่อต้องมีอย่างน้อย 2 ตัวอักษร';
    }

    return null;
  }

  // Phone number validation
  static String? validatePhone(String? phone) {
    if (phone == null || phone.isEmpty) {
      return 'กรุณากรอกเบอร์โทรศัพท์';
    }

    final phoneRegex = RegExp(r'^[0-9]{10}$');
    if (!phoneRegex.hasMatch(phone)) {
      return 'กรุณากรอกเบอร์โทรศัพท์ให้ถูกต้อง (10 หลัก)';
    }

    return null;
  }

  // Address validation
  static String? validateAddress(String? address) {
    if (address == null || address.isEmpty) {
      return 'กรุณากรอกที่อยู่';
    }

    if (address.length < 10) {
      return 'ที่อยู่ต้องมีอย่างน้อย 10 ตัวอักษร';
    }

    return null;
  }

  // Quantity validation
  static String? validateQuantity(String? quantity) {
    if (quantity == null || quantity.isEmpty) {
      return 'กรุณากรอกจำนวน';
    }

    final quantityInt = int.tryParse(quantity);
    if (quantityInt == null || quantityInt <= 0) {
      return 'จำนวนต้องเป็นตัวเลขที่มากกว่า 0';
    }

    return null;
  }

  // Search query validation
  static String? validateSearchQuery(String? query) {
    if (query == null || query.isEmpty) {
      return 'กรุณากรอกคำค้นหา';
    }

    if (query.length < 2) {
      return 'คำค้นหาต้องมีอย่างน้อย 2 ตัวอักษร';
    }

    return null;
  }
}
