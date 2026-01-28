import 'package:device_monitor/src/config/resources/app_colors.dart';
import 'package:device_monitor/src/core/utils/helpers/format_helper.dart';
import 'package:device_monitor/src/core/utils/helpers/widget_helper.dart';
import 'package:device_monitor/src/features/analytics/data/models/analytics_data.dart';
import 'package:device_monitor/src/features/analytics/presentation/widgets/business_analysis_card.dart';
import 'package:flutter/material.dart';

class ThermalSection extends StatelessWidget{
  final Analysis analysis;

  const ThermalSection({super.key,required this.analysis,});

  Widget _buildThermalDistributionBar(BuildContext context, ThermalDistribution distribution) {
    final total = distribution.total;
    if (total == 0) return const SizedBox();

    return Column(
      children: [
        Row(
          children: [
            if (distribution.cool > 0)
              Expanded(
                flex: distribution.cool,
                child: Container(
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.infoBlue,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                ),
              ),
            if (distribution.nominal > 0)
              Expanded(
                flex: distribution.nominal,
                child: Container(
                  height: 32,
                  color: AppColors.successGreen,
                ),
              ),
            if (distribution.warm > 0)
              Expanded(
                flex: distribution.warm,
                child: Container(
                  height: 32,
                  color: AppColors.warningAmber,
                ),
              ),
            if (distribution.hot > 0)
              Expanded(
                flex: distribution.hot,
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
    final distribution = ThermalDistribution.fromJson(
      data['thermalDistribution'] ?? {},
    );
    final criticalEvents = (data['criticalEvents'] as List<dynamic>?) ?? [];

    return BusinessAnalysisCard(analysis: analysis, child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Thermal distribution chart
        const Text(
          'Thermal Distribution',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildThermalDistributionBar(context, distribution),
        const SizedBox(height: 16),

        // Legend
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            WidgetHelper.buildLegendItem('Cool', distribution.cool, AppColors.infoBlue),
            WidgetHelper.buildLegendItem('Nominal', distribution.nominal, AppColors.successGreen),
            WidgetHelper.buildLegendItem('Warm', distribution.warm, AppColors.warningAmber),
            WidgetHelper.buildLegendItem('Hot', distribution.hot, AppColors.errorRed),
          ],
        ),

        // Critical events
        if (criticalEvents.isNotEmpty) ...[
          const Divider(height: 24),
          const Text(
            'Recent Critical Events',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...criticalEvents.take(3).map((event) {
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
                  Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.errorRed,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${FormatHelper.formatDate(event['date'] ?? '')} at ${event['time'] ?? ''}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          event['impact'] ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ],
    ),);
  }
}