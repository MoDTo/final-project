import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'selected_language';

  Locale _currentLocale = const Locale('th', 'TH');

  Locale get currentLocale => _currentLocale;

  // รองรับภาษา
  static const List<Locale> supportedLocales = [
    Locale('th', 'TH'), // ไทย
    Locale('en', 'US'), // อังกฤษ
    Locale('lo', 'LA'), // ลาว
  ];

  LanguageProvider() {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_languageKey);
      if (languageCode != null) {
        _currentLocale = Locale(languageCode);
        notifyListeners();
      }
    } catch (e) {
      // If SharedPreferences fails, keep the default locale
      debugPrint('Failed to load saved language: $e');
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    if (_currentLocale.languageCode != languageCode) {
      _currentLocale = Locale(languageCode);

      // บันทึกการตั้งค่าลง SharedPreferences
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_languageKey, languageCode);
      } catch (e) {
        // If SharedPreferences fails, still update the locale but log the error
        debugPrint('Failed to save language preference: $e');
      }

      notifyListeners();
    }
  }

  String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'th':
        return 'ไทย';
      case 'en':
        return 'English';
      case 'lo':
        return 'ລາວ';
      default:
        return 'ไทย';
    }
  }

  String getLanguageNativeName(String languageCode) {
    switch (languageCode) {
      case 'th':
        return 'ไทย';
      case 'en':
        return 'English';
      case 'lo':
        return 'ລາວ';
      default:
        return 'ไทย';
    }
  }
}
