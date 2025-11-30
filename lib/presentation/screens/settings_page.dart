import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/providers/theme_provider.dart';

/// Settings page for language and theme selection
/// Now integrated with Riverpod for state management
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider);
    final currentThemeMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSizes.paddingMD),
        children: [
          // Language section
          _buildSectionTitle(l10n.language),
          SizedBox(height: AppSizes.spaceSM),
          _buildLanguageCard(context, ref, l10n, currentLocale),

          SizedBox(height: AppSizes.spaceLG),

          // Theme section
          _buildSectionTitle(l10n.theme),
          SizedBox(height: AppSizes.spaceSM),
          _buildThemeCard(context, ref, l10n, currentThemeMode),

          SizedBox(height: AppSizes.spaceLG),

          // Info section
          _buildInfoSection(context),
        ],
      ),
    );
  }

  /// Build section title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingSM),
      child: Text(
        title,
        style: AppTextStyles.titleMedium.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Build language selection card with Riverpod integration
  Widget _buildLanguageCard(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    Locale currentLocale,
  ) {
    return Card(
      elevation: AppSizes.cardElevation,
      child: Column(
        children: [
          _buildLanguageOption(
            context: context,
            ref: ref,
            locale: const Locale('ko'),
            currentLocale: currentLocale,
            title: l10n.korean,
            subtitle: '한국어',
            icon: Icons.flag,
          ),
          Divider(height: 1.h, thickness: AppSizes.dividerThickness),
          _buildLanguageOption(
            context: context,
            ref: ref,
            locale: const Locale('en'),
            currentLocale: currentLocale,
            title: l10n.english,
            subtitle: 'English',
            icon: Icons.flag,
          ),
          Divider(height: 1.h, thickness: AppSizes.dividerThickness),
          _buildLanguageOption(
            context: context,
            ref: ref,
            locale: const Locale('ja'),
            currentLocale: currentLocale,
            title: l10n.japanese,
            subtitle: '日本語',
            icon: Icons.flag,
          ),
        ],
      ),
    );
  }

  /// Build language option tile with Riverpod integration
  Widget _buildLanguageOption({
    required BuildContext context,
    required WidgetRef ref,
    required Locale locale,
    required Locale currentLocale,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = currentLocale.languageCode == locale.languageCode;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDarkMode ? AppColors.primaryDarkMode : AppColors.primary;

    return ListTile(
      leading: Icon(
        icon,
        size: AppSizes.iconMD,
        color: isSelected ? primaryColor : AppColors.textSecondary,
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyLarge.copyWith(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? primaryColor : null,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.bodySmall,
      ),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: primaryColor,
              size: AppSizes.iconMD,
            )
          : null,
      onTap: () async {
        // Update locale using Riverpod provider
        await ref.read(localeProvider.notifier).setLocale(locale);

        // Show confirmation snackbar
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Language changed to: $title'),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
    );
  }

  /// Build theme selection card with Riverpod integration
  Widget _buildThemeCard(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    ThemeMode currentThemeMode,
  ) {
    return Card(
      elevation: AppSizes.cardElevation,
      child: Column(
        children: [
          _buildThemeOption(
            context: context,
            ref: ref,
            themeMode: ThemeMode.light,
            currentThemeMode: currentThemeMode,
            title: l10n.lightMode,
            icon: Icons.light_mode,
          ),
          Divider(height: 1.h, thickness: AppSizes.dividerThickness),
          _buildThemeOption(
            context: context,
            ref: ref,
            themeMode: ThemeMode.dark,
            currentThemeMode: currentThemeMode,
            title: l10n.darkMode,
            icon: Icons.dark_mode,
          ),
          Divider(height: 1.h, thickness: AppSizes.dividerThickness),
          _buildThemeOption(
            context: context,
            ref: ref,
            themeMode: ThemeMode.system,
            currentThemeMode: currentThemeMode,
            title: l10n.systemMode,
            icon: Icons.brightness_auto,
          ),
        ],
      ),
    );
  }

  /// Build theme option tile with Riverpod integration
  Widget _buildThemeOption({
    required BuildContext context,
    required WidgetRef ref,
    required ThemeMode themeMode,
    required ThemeMode currentThemeMode,
    required String title,
    required IconData icon,
  }) {
    final isSelected = currentThemeMode == themeMode;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDarkMode ? AppColors.primaryDarkMode : AppColors.primary;

    return ListTile(
      leading: Icon(
        icon,
        size: AppSizes.iconMD,
        color: isSelected ? primaryColor : AppColors.textSecondary,
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyLarge.copyWith(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? primaryColor : null,
        ),
      ),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: primaryColor,
              size: AppSizes.iconMD,
            )
          : null,
      onTap: () async {
        // Update theme mode using Riverpod provider
        await ref.read(themeProvider.notifier).setThemeMode(themeMode);

        // Show confirmation snackbar
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Theme changed to: $title'),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
    );
  }

  /// Build info section
  Widget _buildInfoSection(BuildContext context) {
    return Card(
      elevation: AppSizes.cardElevation,
      child: Padding(
        padding: EdgeInsets.all(AppSizes.paddingLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: AppSizes.iconMD,
                  color: AppColors.info,
                ),
                SizedBox(width: AppSizes.spaceSM),
                Text(
                  'Language Settings',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.spaceMD),
            Text(
              'Language changes are now applied immediately using Riverpod state management. '
              'Your selected language is saved and will be restored when you restart the app.',
              style: AppTextStyles.bodyMedium,
            ),
            SizedBox(height: AppSizes.spaceMD),
            Text(
              'Default Language: English\n'
              'Supported Languages: English, Korean (한국어), Japanese (日本語)',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppSizes.spaceMD),
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  size: AppSizes.iconSM,
                  color: AppColors.success,
                ),
                SizedBox(width: AppSizes.spaceSM),
                Expanded(
                  child: Text(
                    'Powered by Riverpod + SharedPreferences',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
