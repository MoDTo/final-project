import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<File?> getUserProfileImageFile() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return null;
  final prefs = await SharedPreferences.getInstance();
  final path = prefs.getString('profile_image_path_${user.uid}');
  if (path != null && File(path).existsSync()) {
    return File(path);
  }
  return null;
}
