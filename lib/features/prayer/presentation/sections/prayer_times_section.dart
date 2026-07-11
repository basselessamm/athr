import 'package:flutter/material.dart';

import 'package:athr/core/theme/app_spacing.dart';
import 'package:athr/features/prayer/presentation/widgets/prayer_times_card.dart';

class PrayerTimesSection extends StatelessWidget {
  const PrayerTimesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: PrayerTimesCard(),
    );
  }
}
