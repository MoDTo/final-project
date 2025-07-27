class UserModel {
  final String id;
  final String email;
  final String? name;
  final String? tel;
  final String? address;
  final String? profileImageUrl;

  UserModel({
    required this.id,
    required this.email,
    this.name,
    this.tel,
    this.address,
    this.profileImageUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      email: map['email'] ?? '',
      name: map['name'],
      tel: map['tel'],
      address: map['address'],
      profileImageUrl: map['profileImageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'tel': tel,
      'address': address,
      'profileImageUrl': profileImageUrl,
    };
  }
}
