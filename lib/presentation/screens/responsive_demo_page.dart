import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/responsive_helper.dart';
import '../../core/widgets/responsive_layout.dart';
import '../../core/widgets/responsive_grid.dart';

/// Demo page showcasing responsive UI capabilities
///
/// Demonstrates:
/// - Adaptive layouts for phone/tablet/desktop
/// - Responsive grid with automatic column adjustment
/// - Orientation-aware layouts
/// - Device type detection
class ResponsiveDemoPage extends StatelessWidget {
  const ResponsiveDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive UI Demo'),
      ),
      body: ResponsiveCenteredContainer(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(ResponsiveHelper.getHorizontalPadding(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section 1: Device Info
              _buildSectionTitle('Device Information'),
              SizedBox(height: AppSizes.spaceMD),
              _buildDeviceInfoCard(context),

              SizedBox(height: AppSizes.spaceXL),

              // Section 2: Responsive Grid Demo
              _buildSectionTitle('Responsive Grid Demo'),
              SizedBox(height: AppSizes.spaceMD),
              _buildGridDemo(context),

              SizedBox(height: AppSizes.spaceXL),

              // Section 3: Adaptive Values Demo
              _buildSectionTitle('Adaptive Values Demo'),
              SizedBox(height: AppSizes.spaceMD),
              _buildAdaptiveValuesDemo(context),

              SizedBox(height: AppSizes.spaceXL),

              // Section 4: Layout Variants Demo
              _buildSectionTitle('Layout Variants'),
              SizedBox(height: AppSizes.spaceMD),
              _buildLayoutVariantsDemo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.headlineSmall.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildDeviceInfoCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.paddingLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
              'Device Type',
              ResponsiveHelper.isDesktop(context)
                  ? 'Desktop'
                  : ResponsiveHelper.isTablet(context)
                      ? 'Tablet'
                      : 'Phone',
              Icons.devices,
            ),
            _buildInfoRow(
              'Orientation',
              ResponsiveHelper.isLandscape(context) ? 'Landscape' : 'Portrait',
              Icons.screen_rotation,
            ),
            _buildInfoRow(
              'Screen Size',
              '${ResponsiveHelper.screenWidth(context).toInt()} × ${ResponsiveHelper.screenHeight(context).toInt()}',
              Icons.aspect_ratio,
            ),
            _buildInfoRow(
              'Scale Factor',
              ScreenUtil().scaleWidth.toStringAsFixed(2),
              Icons.design_services,
            ),
            _buildInfoRow(
              'Grid Columns',
              '${ResponsiveHelper.getGridColumnCount(context)}',
              Icons.grid_view,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.spaceSM),
      child: Row(
        children: [
          Icon(icon, size: AppSizes.iconSM, color: AppColors.primary),
          SizedBox(width: AppSizes.spaceMD),
          Expanded(
            child: Text(label, style: AppTextStyles.bodyMedium),
          ),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridDemo(BuildContext context) {
    return SizedBox(
      height: 400.h,
      child: ResponsiveGridBuilder(
        itemCount: 12,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.2,
        itemBuilder: (context, index) {
          return Card(
            color: AppColors.primary.withOpacity(0.1),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.apps,
                    size: AppSizes.iconLG,
                    color: AppColors.primary,
                  ),
                  SizedBox(height: AppSizes.spaceSM),
                  Text(
                    'Item ${index + 1}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAdaptiveValuesDemo(BuildContext context) {
    final padding = ResponsiveHelper.valueByDevice(
      context,
      phone: 16.0,
      tablet: 24.0,
      desktop: 32.0,
    );

    final fontSize = ResponsiveHelper.valueByDevice(
      context,
      phone: 14.0,
      tablet: 16.0,
      desktop: 18.0,
    );

    return Card(
      child: Container(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Adaptive Padding & Font Size',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppSizes.spaceMD),
            Text(
              'This card uses adaptive values:',
              style: AppTextStyles.bodyMedium,
            ),
            SizedBox(height: AppSizes.spaceSM),
            _buildAdaptiveValueRow('Padding', '${padding.toInt()}px'),
            _buildAdaptiveValueRow('Font Size', '${fontSize.toInt()}px'),
            _buildAdaptiveValueRow(
              'Horizontal Padding',
              '${ResponsiveHelper.getHorizontalPadding(context).toInt()}px',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdaptiveValueRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.spaceXS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('• $label:', style: AppTextStyles.bodySmall),
          Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLayoutVariantsDemo() {
    return ResponsiveLayout(
      mobile: _buildLayoutCard(
        'Mobile Layout',
        'This layout is optimized for phone screens',
        Icons.phone_android,
        Colors.blue,
      ),
      tablet: _buildLayoutCard(
        'Tablet Layout',
        'This layout is optimized for tablet screens',
        Icons.tablet,
        Colors.green,
      ),
      desktop: _buildLayoutCard(
        'Desktop Layout',
        'This layout is optimized for desktop screens',
        Icons.desktop_windows,
        Colors.purple,
      ),
    );
  }

  Widget _buildLayoutCard(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.paddingLG),
        child: Column(
          children: [
            Icon(icon, size: AppSizes.iconXL, color: color),
            SizedBox(height: AppSizes.spaceMD),
            Text(
              title,
              style: AppTextStyles.titleLarge.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSizes.spaceSM),
            Text(
              description,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
