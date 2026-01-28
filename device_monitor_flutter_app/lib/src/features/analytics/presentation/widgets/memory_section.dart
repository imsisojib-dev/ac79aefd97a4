import 'package:device_monitor/src/config/resources/app_colors.dart';
import 'package:device_monitor/src/core/utils/helpers/widget_helper.dart';
import 'package:device_monitor/src/features/analytics/data/models/analytics_data.dart';
import 'package:device_monitor/src/features/analytics/presentation/widgets/business_analysis_card.dart';
import 'package:flutter/material.dart';

class MemorySection extends StatelessWidget{
  final Analysis analysis;
  const MemorySection({super.key, required this.analysis});

  Widget _buildStatBox(BuildContext context, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendRow(String label, int value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 13),
          ),
        ),
        Text(
          '$value%',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: WidgetHelper.getMemoryColor(value),
          ),
        ),
      ],
    );
  }

  Widget _buildMemoryDistributionBar(BuildContext context, MemoryUsageDistribution distribution) {
    final total = distribution.total;
    if (total == 0) return const SizedBox();

    return Column(
      children: [
        Row(
          children: [
            if (distribution.optimal > 0)
              Expanded(
                flex: distribution.optimal,
                child: Container(
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.successGreen,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                ),
              ),
            if (distribution.moderate > 0)
              Expanded(
                flex: distribution.moderate,
                child: Container(
                  height: 32,
                  color: AppColors.infoBlue,
                ),
              ),
            if (distribution.high > 0)
              Expanded(
                flex: distribution.high,
                child: Container(
                  height: 32,
                  color: AppColors.warningAmber,
                ),
              ),
            if (distribution.critical > 0)
              Expanded(
                flex: distribution.critical,
                child: Container(
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.errorRed,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '0%',
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
            Text(
              '100%',
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = analysis.data;
    final distribution = MemoryUsageDistribution.fromJson(
      data['usageDistribution'] ?? {},
    );
    final trends = data['trends'] ?? {};
    final avgMemory = data['averageMemoryUsage'] ?? 0;
    final peakMemory = data['peakMemoryUsage'] ?? 0;

    return BusinessAnalysisCard(analysis: analysis, child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Stats
        Row(
          children: [
            Expanded(
              child: _buildStatBox(
                context,
                'Average',
                '$avgMemory%',
                WidgetHelper.getMemoryColor(avgMemory),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatBox(
                context,
                'Peak',
                '$peakMemory%',
                AppColors.errorRed,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Distribution
        const Text(
          'Usage Distribution',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildMemoryDistributionBar(context, distribution),
        const SizedBox(height: 16),

        // Legend
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            WidgetHelper.buildLegendItem('Optimal', distribution.optimal, AppColors.successGreen),
            WidgetHelper.buildLegendItem('Moderate', distribution.moderate, AppColors.infoBlue),
            WidgetHelper.buildLegendItem('High', distribution.high, AppColors.warningAmber),
            WidgetHelper.buildLegendItem('Critical', distribution.critical, AppColors.errorRed),
          ],
        ),

        // Trends
        if (trends.isNotEmpty) ...[
          const Divider(height: 24),
          const Text(
            'Memory Trends',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildTrendRow('Last 7 Days', trends['last7Days'] ?? 0),
          const SizedBox(height: 8),
          _buildTrendRow('Last 30 Days', trends['last30Days'] ?? 0),
          const SizedBox(height: 8),
          _buildTrendRow('Last 90 Days', trends['last90Days'] ?? 0),
        ],
      ],
    ),);
  }
}