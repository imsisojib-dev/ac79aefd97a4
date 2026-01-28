import 'package:device_monitor/src/config/resources/app_colors.dart';
import 'package:device_monitor/src/core/utils/helpers/format_helper.dart';
import 'package:device_monitor/src/core/utils/helpers/widget_helper.dart';
import 'package:device_monitor/src/features/analytics/data/models/analytics_data.dart';
import 'package:flutter/material.dart';

class OverallSummaryCard extends StatelessWidget{
  final OverallSummary summary;
  const OverallSummaryCard({super.key, required this.summary,});

  Widget _buildSummaryBadge(String label, int count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final conditionColor = WidgetHelper.getConditionColor(summary.deviceCondition);
    final conditionIcon = WidgetHelper.getConditionIcon(summary.deviceCondition);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: conditionColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(conditionIcon, color: conditionColor, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Device Condition',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        FormatHelper.formatCondition(summary.deviceCondition),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: conditionColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                _buildSummaryBadge(
                  'Critical',
                  summary.criticalIssues,
                  AppColors.errorRed,
                ),
                const SizedBox(width: 12),
                _buildSummaryBadge(
                  'Warnings',
                  summary.warnings,
                  AppColors.warningAmber,
                ),
                const SizedBox(width: 12),
                _buildSummaryBadge(
                  'Good',
                  summary.improvements,
                  AppColors.successGreen,
                ),
              ],
            ),
            if (summary.topRecommendation.isNotEmpty) ...[
              const Divider(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: AppColors.warningAmber,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      summary.topRecommendation,
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}