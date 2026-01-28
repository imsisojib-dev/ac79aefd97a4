import 'package:device_monitor/src/config/resources/app_colors.dart';
import 'package:device_monitor/src/core/utils/helpers/widget_helper.dart';
import 'package:device_monitor/src/features/analytics/data/models/analytics_data.dart';
import 'package:device_monitor/src/features/analytics/presentation/widgets/business_analysis_card.dart';
import 'package:flutter/material.dart';

class HealthScoreSection extends StatelessWidget {
  final Analysis analysis;

  const HealthScoreSection({
    super.key,
    required this.analysis,
  });

  Widget _buildBreakdownRow(String label, int value, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(fontSize: 13),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: (value / 100).clamp(0.0, 1.0),
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 35,
          child: Text(
            '$value',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final healthData = DeviceHealthScore.fromJson(analysis.data);

    return BusinessAnalysisCard(
      analysis: analysis,
      child: Column(
        children: [
          // Score Circle
          SizedBox(
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: healthData.currentScore / 100,
                    strokeWidth: 12,
                    backgroundColor: WidgetHelper.getHealthScoreColor(healthData.currentScore).withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation(
                      WidgetHelper.getHealthScoreColor(healthData.currentScore),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${healthData.currentScore}',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: WidgetHelper.getHealthScoreColor(healthData.currentScore),
                      ),
                    ),
                    Text(
                      healthData.status,
                      style: TextStyle(
                        fontSize: 12,
                        color: WidgetHelper.getHealthScoreColor(healthData.currentScore),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Breakdown
          _buildBreakdownRow(
            'Thermal',
            healthData.breakdown['thermalScore'] ?? 0,
            AppColors.warningAmber,
          ),
          const SizedBox(height: 8),
          _buildBreakdownRow(
            'Battery',
            healthData.breakdown['batteryScore'] ?? 0,
            AppColors.successGreen,
          ),
          const SizedBox(height: 8),
          _buildBreakdownRow(
            'Memory',
            healthData.breakdown['memoryScore'] ?? 0,
            AppColors.infoBlue,
          ),

          // Trend
          if (healthData.trendPercentage != 0) ...[
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  healthData.trendPercentage > 0 ? Icons.trending_up : Icons.trending_down,
                  color: healthData.trendPercentage > 0 ? AppColors.successGreen : AppColors.errorRed,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '${healthData.trendPercentage.abs().toStringAsFixed(1)}% ${healthData.trend.toLowerCase()}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: healthData.trendPercentage > 0 ? AppColors.successGreen : AppColors.errorRed,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
