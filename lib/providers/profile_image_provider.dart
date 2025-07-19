import 'dart:io';
import 'package:flutter/material.dart';
import '../utils/profile_image_helper.dart';

class ProfileImageProvider extends ChangeNotifier {
  File? _profileImage;

  File? get profileImage => _profileImage;

  Future<void> loadProfileImage() async {
    _profileImage = await getUserProfileImageFile();
    notifyListeners();
  }

  void setProfileImage(File? file) {
    _profileImage = file;
    notifyListeners();
  }
}
