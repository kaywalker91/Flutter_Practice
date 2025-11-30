import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/l10n/app_localizations.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/responsive_helper.dart';
import '../widgets/responsive_builder.dart';
import 'responsive_demo_page.dart';
import 'settings_page.dart';

/// Home page with counter functionality
/// Demonstrates ScreenUtil usage and localization
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homePageTitle),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, size: AppSizes.iconMD),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
            tooltip: l10n.settings,
          ),
        ],
      ),
      body: ResponsiveBuilder(
        mobile: _buildMobileLayout(context, l10n),
        tablet: _buildTabletLayout(context, l10n),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: l10n.incrementTooltip,
        child: Icon(Icons.add, size: AppSizes.iconMD),
      ),
    );
  }

  /// Mobile layout (portrait)
  Widget _buildMobileLayout(BuildContext context, AppLocalizations l10n) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(AppSizes.paddingMD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Welcome message card
              _buildWelcomeCard(l10n),

              SizedBox(height: AppSizes.spaceLG),

              // Counter description
              Text(
                l10n.counterDescription,
                style: AppTextStyles.bodyLarge,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: AppSizes.spaceMD),

              // Counter display
              _buildCounterDisplay(),

              SizedBox(height: AppSizes.spaceXL),

              // Info card with device details
              _buildInfoCard(),

              SizedBox(height: AppSizes.spaceLG),

              // Demo button (NEW)
              _buildDemoButton(context),

              // Bottom padding for scroll comfort
              SizedBox(height: AppSizes.spaceMD),
            ],
          ),
        ),
      ),
    );
  }

  /// Tablet layout (wider screens)
  Widget _buildTabletLayout(BuildContext context, AppLocalizations l10n) {
    return SafeArea(
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 600.w),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(AppSizes.paddingLG),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Welcome message card
                  _buildWelcomeCard(l10n),

                  SizedBox(height: AppSizes.spaceXL),

                  // Counter section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              l10n.counterDescription,
                              style: AppTextStyles.titleLarge,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: AppSizes.spaceMD),
                            _buildCounterDisplay(),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: AppSizes.spaceXL),

                  // Info card
                  _buildInfoCard(),

                  SizedBox(height: AppSizes.spaceLG),

                  // Demo button (NEW)
                  _buildDemoButton(context),

                  // Bottom padding for scroll comfort
                  SizedBox(height: AppSizes.spaceMD),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Welcome message card
  Widget _buildWelcomeCard(AppLocalizations l10n) {
    return Card(
      elevation: AppSizes.cardElevation,
      child: Padding(
        padding: EdgeInsets.all(AppSizes.paddingLG),
        child: Row(
          children: [
            Icon(
              Icons.star,
              size: AppSizes.iconLG,
              color: AppColors.primary,
            ),
            SizedBox(width: AppSizes.spaceMD),
            Expanded(
              child: Text(
                l10n.welcomeMessage,
                style: AppTextStyles.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Counter display with styling
  Widget _buildCounterDisplay() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingXL,
        vertical: AppSizes.paddingLG,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusLG),
        border: Border.all(
          color: AppColors.primary,
          width: 2.w,
        ),
      ),
      child: Text(
        '$_counter',
        style: AppTextStyles.displayLarge.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Info card with device and screen details
  Widget _buildInfoCard() {
    return Card(
      elevation: AppSizes.cardElevation,
      child: Padding(
        padding: EdgeInsets.all(AppSizes.paddingLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Device Info',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppSizes.spaceMD),

            // Device Type Detection (NEW)
            _buildInfoRow(
              'Device Type',
              ResponsiveHelper.isDesktop(context)
                  ? 'Desktop'
                  : ResponsiveHelper.isTablet(context)
                      ? 'Tablet'
                      : 'Phone',
            ),
            _buildInfoRow(
              'Orientation',
              ResponsiveHelper.isLandscape(context) ? 'Landscape' : 'Portrait',
            ),

            Divider(height: AppSizes.spaceLG),

            // Screen Measurements
            _buildInfoRow('Screen Width', '${ScreenUtil().screenWidth.toStringAsFixed(1)} px'),
            _buildInfoRow('Screen Height', '${ScreenUtil().screenHeight.toStringAsFixed(1)} px'),
            _buildInfoRow('Shortest Side', '${ResponsiveHelper.shortestSide(context).toStringAsFixed(1)} px'),
            _buildInfoRow('Device Pixel Ratio', ScreenUtil().pixelRatio!.toStringAsFixed(2)),

            Divider(height: AppSizes.spaceLG),

            // ScreenUtil Info
            _buildInfoRow('Scale Factor', ScreenUtil().scaleWidth.toStringAsFixed(2)),
            _buildInfoRow('Status Bar Height', '${ScreenUtil().statusBarHeight.toStringAsFixed(1)} px'),
            _buildInfoRow('Bottom Bar Height', '${ScreenUtil().bottomBarHeight.toStringAsFixed(1)} px'),
            _buildInfoRow('Text Scale Factor', ScreenUtil().textScaleFactor.toStringAsFixed(2)),

            Divider(height: AppSizes.spaceLG),

            // Adaptive Grid Columns (NEW)
            _buildInfoRow(
              'Grid Columns',
              '${ResponsiveHelper.getGridColumnCount(context)}',
            ),
          ],
        ),
      ),
    );
  }

  /// Helper to build info rows
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.spaceSM),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 3,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: AppSizes.spaceSM),
          Flexible(
            flex: 2,
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Demo button to navigate to responsive demo page
  Widget _buildDemoButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ResponsiveDemoPage(),
            ),
          );
        },
        icon: Icon(Icons.preview, size: AppSizes.iconSM),
        label: const Text('View Responsive UI Demo'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}
