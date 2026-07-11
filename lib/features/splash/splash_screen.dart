import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:athr/core/database/database_providers.dart';
import 'package:athr/core/database/seeder/db_seeder.dart';
import 'package:athr/core/notifications/notification_router.dart';
import 'package:athr/core/router/app_router.dart';

final seederProvider = FutureProvider<void>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final seeder = DatabaseSeeder(db);
  await seeder.seedDatabase();
  // Ensure the splash screen stays for at least 2 seconds for the animation to finish
  await Future.delayed(const Duration(seconds: 2));
});

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final seederAsync = ref.watch(seederProvider);

    ref.listen<AsyncValue<void>>(seederProvider, (_, state) async {
      if (!state.isLoading && !state.hasError) {
        await _controller.reverse();
        if (context.mounted) {
          final payload = ref.read(initialPayloadProvider);
          if (payload != null) {
            final route = NotificationRouter.resolveRoute(payload);
            if (route != null) {
              context.go(route);
            } else {
              context.go('/');
            }
          } else {
            context.go('/');
          }
        }
      }
    });

    return Scaffold(
      backgroundColor: const Color(
        0xFFFDF7EF,
      ), // Match the logo's vintage paper background
      body: Stack(
        children: [
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(32), // Adjusted radius for inner logo
                      child: Image.asset(
                        'assets/images/app_icon.png',
                        width: 200, // Slightly smaller since the outer padding is gone
                        height: 200,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'أَثَر',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333), // Charcoal
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'تَعَلَّم... اعْمَل... واستَمِرّ',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF5A7B72), // Sage green
                      ),
                    ),
                    const SizedBox(height: 48),
                    if (seederAsync.isLoading) ...[
                      const CircularProgressIndicator(color: Color(0xFF5A7B72)),
                    ] else if (seederAsync.hasError) ...[
                      const Icon(Icons.error, color: Colors.redAccent),
                      const SizedBox(height: 16),
                      Text(
                        'حدث خطأ: ${seederAsync.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'DEVELOPED BY',
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 3.0,
                      color: Color(0xFF999999),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'BASSEL ESSAM',
                    style: TextStyle(
                      fontSize: 14,
                      letterSpacing: 4.0,
                      color: Color(0xFF5A7B72),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
