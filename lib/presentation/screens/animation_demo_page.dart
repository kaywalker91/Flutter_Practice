import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/widgets/animations/animated_counter.dart';
import '../../core/widgets/animations/shimmer_loader.dart';
import '../../core/widgets/animations/staggered_animations.dart';
import '../../core/widgets/animations/micro_interactions.dart';
import '../../core/widgets/animations/hero_animations.dart';
import '../../core/widgets/animations/page_transitions.dart';

/// Comprehensive animation showcase page
///
/// Demonstrates all animation features in the app

class AnimationDemoPage extends StatefulWidget {
  const AnimationDemoPage({super.key});

  @override
  State<AnimationDemoPage> createState() => _AnimationDemoPageState();
}

class _AnimationDemoPageState extends State<AnimationDemoPage> {
  double _balance = 1234.56;
  double _percentage = 12.34;
  bool _showShimmer = false;
  bool _shakeError = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Animation Showcase'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          // ================================================================
          // ANIMATED COUNTERS
          // ================================================================
          _buildSection(
            'Animated Counters',
            Column(
              children: [
                // Balance counter
                AnimatedCounter(
                  value: _balance,
                  previousValue: _balance - 100,
                  prefix: '\$',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  animateColor: true,
                  positiveColor: theme.colorScheme.tertiary,
                  negativeColor: theme.colorScheme.error,
                ),
                SizedBox(height: 16.h),

                // Percentage change
                AnimatedPercentageChange(
                  percentage: _percentage,
                  previousPercentage: _percentage - 2,
                ),
                SizedBox(height: 16.h),

                // Rolling counter
                RollingCounter(
                  value: _balance.toInt(),
                  previousValue: (_balance - 100).toInt(),
                  style: theme.textTheme.headlineMedium,
                ),
                SizedBox(height: 16.h),

                // Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _balance += 100;
                            _percentage += 2.5;
                          });
                        },
                        child: const Text('Increase'),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _balance -= 100;
                            _percentage -= 2.5;
                          });
                        },
                        child: const Text('Decrease'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 24.h),

          // ================================================================
          // SHIMMER LOADERS
          // ================================================================
          _buildSection(
            'Shimmer Loading',
            Column(
              children: [
                // Toggle shimmer
                SwitchListTile(
                  title: const Text('Show Shimmer'),
                  value: _showShimmer,
                  onChanged: (value) {
                    setState(() {
                      _showShimmer = value;
                    });
                  },
                ),
                SizedBox(height: 16.h),

                // Shimmer examples
                if (_showShimmer) ...[
                  const TokenListItemSkeleton(),
                  const TokenListItemSkeleton(),
                  const TransactionListItemSkeleton(),
                ] else ...[
                  _buildMockTokenItem('ETH', 'Ethereum', '2.5 ETH', '+5.2%'),
                  _buildMockTokenItem('BTC', 'Bitcoin', '0.05 BTC', '+3.1%'),
                  _buildMockTransactionItem(),
                ],
              ],
            ),
          ),

          SizedBox(height: 24.h),

          // ================================================================
          // STAGGERED ANIMATIONS
          // ================================================================
          _buildSection(
            'Staggered List',
            Column(
              children: List.generate(
                5,
                (index) => StaggeredListAnimation(
                  index: index,
                  type: StaggerAnimationType.slideAndFade,
                  child: Card(
                    margin: EdgeInsets.only(bottom: 8.h),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text('${index + 1}'),
                      ),
                      title: Text('Item ${index + 1}'),
                      subtitle: const Text('Staggered animation demo'),
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 24.h),

          // ================================================================
          // MICRO-INTERACTIONS
          // ================================================================
          _buildSection(
            'Micro-Interactions',
            Column(
              children: [
                // Animated button
                AnimatedButton(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Button tapped!')),
                    );
                  },
                  backgroundColor: theme.colorScheme.primary,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 12.h,
                  ),
                  child: Text(
                    'Animated Button',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                // Bounce animation
                BounceAnimation(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Bounce!')),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: const Text('Tap to Bounce'),
                  ),
                ),
                SizedBox(height: 16.h),

                // Shake animation
                ShakeAnimation(
                  shake: _shakeError,
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: const Text('Shake on Error'),
                  ),
                ),
                SizedBox(height: 8.h),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _shakeError = true;
                    });
                    Future.delayed(const Duration(milliseconds: 500), () {
                      if (mounted) {
                        setState(() {
                          _shakeError = false;
                        });
                      }
                    });
                  },
                  child: const Text('Trigger Shake'),
                ),
                SizedBox(height: 16.h),

                // Pulse animation
                const PulseAnimation(
                  child: Icon(
                    Icons.notifications_active,
                    size: 48,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 24.h),

          // ================================================================
          // PAGE TRANSITIONS
          // ================================================================
          _buildSection(
            'Page Transitions',
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                ElevatedButton(
                  onPressed: () {
                    navigateSlideFromBottom(
                      context,
                      const _DemoDestinationPage(title: 'Slide from Bottom'),
                    );
                  },
                  child: const Text('Slide Bottom'),
                ),
                ElevatedButton(
                  onPressed: () {
                    navigateSlideFromRight(
                      context,
                      const _DemoDestinationPage(title: 'Slide from Right'),
                    );
                  },
                  child: const Text('Slide Right'),
                ),
                ElevatedButton(
                  onPressed: () {
                    navigateFade(
                      context,
                      const _DemoDestinationPage(title: 'Fade Transition'),
                    );
                  },
                  child: const Text('Fade'),
                ),
                ElevatedButton(
                  onPressed: () {
                    navigateScale(
                      context,
                      const _DemoDestinationPage(title: 'Scale Transition'),
                    );
                  },
                  child: const Text('Scale'),
                ),
                ElevatedButton(
                  onPressed: () {
                    navigateSharedAxis(
                      context,
                      const _DemoDestinationPage(title: 'Shared Axis'),
                    );
                  },
                  child: const Text('Shared Axis'),
                ),
              ],
            ),
          ),

          SizedBox(height: 24.h),

          // ================================================================
          // HERO ANIMATIONS
          // ================================================================
          _buildSection(
            'Hero Animations',
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    navigateWithHero(
                      context,
                      const _HeroDestinationPage(),
                    );
                  },
                  child: Row(
                    children: [
                      TokenIconHero(
                        tokenSymbol: 'ETH',
                        child: Container(
                          width: 48.w,
                          height: 48.w,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.currency_bitcoin,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      BalanceHero(
                        identifier: 'ETH',
                        child: Text(
                          '\$1,234.56',
                          style: theme.textTheme.headlineSmall,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Tap to see hero animation',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Widget child) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 16.h),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildMockTokenItem(
    String symbol,
    String name,
    String balance,
    String change,
  ) {
    final theme = Theme.of(context);
    final isPositive = change.startsWith('+');

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                symbol[0],
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(symbol, style: theme.textTheme.titleMedium),
                Text(
                  name,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(balance, style: theme.textTheme.titleMedium),
              Text(
                change,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isPositive
                      ? theme.colorScheme.tertiary
                      : theme.colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMockTransactionItem() {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_upward,
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sent ETH', style: theme.textTheme.titleSmall),
                Text('2 hours ago', style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          Text(
            '-0.5 ETH',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}

// Demo destination pages

class _DemoDestinationPage extends StatelessWidget {
  final String title;

  const _DemoDestinationPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 100.w,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(height: 24.h),
            Text(
              'Page Transition Demo',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroDestinationPage extends StatelessWidget {
  const _HeroDestinationPage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hero Animation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TokenIconHero(
              tokenSymbol: 'ETH',
              child: Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.currency_bitcoin,
                  color: Colors.white,
                  size: 60.w,
                ),
              ),
            ),
            SizedBox(height: 24.h),
            BalanceHero(
              identifier: 'ETH',
              child: Text(
                '\$1,234.56',
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Ethereum',
              style: theme.textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}
