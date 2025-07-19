import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/language_provider.dart';
import '../../utils/app_localizations.dart';

class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          l10n.get('language'),
          style: const TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1A1A1A)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.language,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.get('language'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.get('language_subtitle'),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Language Options
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF0F0F0)),
              ),
              child: Column(
                children: [
                  _buildLanguageOption(
                    context: context,
                    languageProvider: languageProvider,
                    languageCode: 'th',
                    languageName: 'ไทย',
                    nativeName: 'ไทย',
                    flag: '🇹🇭',
                    isSelected:
                        languageProvider.currentLocale.languageCode == 'th',
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _buildLanguageOption(
                    context: context,
                    languageProvider: languageProvider,
                    languageCode: 'en',
                    languageName: 'English',
                    nativeName: 'English',
                    flag: '🇺🇸',
                    isSelected:
                        languageProvider.currentLocale.languageCode == 'en',
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _buildLanguageOption(
                    context: context,
                    languageProvider: languageProvider,
                    languageCode: 'lo',
                    languageName: 'ລາວ',
                    nativeName: 'ລາວ',
                    flag: '🇱🇦',
                    isSelected:
                        languageProvider.currentLocale.languageCode == 'lo',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 20, color: Colors.grey[600]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.get('language_change_info'),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required LanguageProvider languageProvider,
    required String languageCode,
    required String languageName,
    required String nativeName,
    required String flag,
    required bool isSelected,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Center(child: Text(flag, style: const TextStyle(fontSize: 20))),
      ),
      title: Text(
        languageName,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isSelected ? const Color(0xFF1A1A1A) : const Color(0xFF1A1A1A),
        ),
      ),
      subtitle: Text(
        nativeName,
        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
      ),
      trailing: isSelected
          ? Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.check, size: 16, color: Colors.white),
            )
          : null,
      onTap: () {
        languageProvider.changeLanguage(languageCode);
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n
                  .get('language_changed_to')
                  .replaceAll('{lang}', languageName),
            ),
            backgroundColor: const Color(0xFF1A1A1A),
            duration: const Duration(seconds: 2),
          ),
        );
      },
    );
  }
}
