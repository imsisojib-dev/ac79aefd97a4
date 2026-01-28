import 'package:device_monitor/src/config/resources/app_colors.dart';
import 'package:device_monitor/src/core/utils/helpers/format_helper.dart';
import 'package:device_monitor/src/core/utils/helpers/widget_helper.dart';
import 'package:device_monitor/src/features/analytics/data/models/analytics_data.dart';
import 'package:device_monitor/src/features/analytics/presentation/widgets/business_analysis_card.dart';
import 'package:flutter/material.dart';

class BatteryDrainSection extends StatelessWidget {
  final Analysis analysis;

  const BatteryDrainSection({
    super.key,
    required this.analysis,
  });

  @override
  Widget build(BuildContext context) {
    final data = analysis.data;
    final insights = (data['insights'] as List<dynamic>?) ?? [];
    final peakDrainDays = (data['peakDrainDays'] as List<dynamic>?) ?? [];
    final avgDailyDrain = data['averageDailyDrain'] ?? 0;

    return BusinessAnalysisCard(
      analysis: analysis,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Average drain
          Center(
            child: Column(
              children: [
                Text(
                  '$avgDailyDrain%',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: WidgetHelper.getBatteryDrainColor(avgDailyDrain),
                  ),
                ),
                const Text(
                  'Average Daily Drain',
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Time period insights
          if (insights.isNotEmpty) ...[
            const Text(
              'Drain by Time Period',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...insights.map((insight) {
              final period = insight['period'] ?? '';
              final drain = insight['averageDrain'] ?? 0;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      WidgetHelper.getPeriodIcon(period),
                      size: 18,
                      color: AppColors.primaryGreen,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        period,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    Text(
                      '$drain%',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],

          // Peak drain days
          if (peakDrainDays.isNotEmpty) ...[
            const Divider(height: 24),
            const Text(
              'Peak Drain Days',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...peakDrainDays.take(3).map((day) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.errorRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.errorRed.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      FormatHelper.formatDate(day['date'] ?? ''),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${day['drainPercentage']}%',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.errorRed,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ],
      ),
    );
  }
}
