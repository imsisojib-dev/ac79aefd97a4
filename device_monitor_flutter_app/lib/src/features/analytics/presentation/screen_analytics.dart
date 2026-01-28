import 'package:device_monitor/src/config/resources/app_colors.dart';
import 'package:device_monitor/src/core/enums/e_loading.dart';
import 'package:device_monitor/src/features/analytics/data/enums/e_date_range.dart';
import 'package:device_monitor/src/features/analytics/data/models/analytics_data.dart';
import 'package:device_monitor/src/features/analytics/presentation/providers/provider_analytics.dart';
import 'package:device_monitor/src/features/analytics/presentation/widgets/battery_drain_section.dart';
import 'package:device_monitor/src/features/analytics/presentation/widgets/business_analysis_card.dart';
import 'package:device_monitor/src/features/analytics/presentation/widgets/health_score_section.dart';
import 'package:device_monitor/src/features/analytics/presentation/widgets/memory_section.dart';
import 'package:device_monitor/src/features/analytics/presentation/widgets/overall_summary_card.dart';
import 'package:device_monitor/src/features/analytics/presentation/widgets/period_info.dart';
import 'package:device_monitor/src/features/analytics/presentation/widgets/thermal_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenAnalytics extends StatefulWidget {
  final String deviceId;

  const ScreenAnalytics({
    super.key,
    required this.deviceId,
  });

  @override
  State<ScreenAnalytics> createState() => _ScreenAnalyticsState();
}

class _ScreenAnalyticsState extends State<ScreenAnalytics> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProviderAnalytics>().loadAnalytics(widget.deviceId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Analytics & Insights',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Date Range Selector
          _buildDateRangeSelector(),

          // Content
          Expanded(
            child: Consumer<ProviderAnalytics>(
              builder: (context, provider, child) {
                if (provider.loading==ELoading.loading) {
                  return _buildLoadingState();
                }

                if (provider.error != null) {
                  return _buildErrorState(provider);
                }

                if (provider.analyticsData == null) {
                  return _buildEmptyState();
                }

                return _buildAnalyticsContent(provider.analyticsData!);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangeSelector() {
    return Consumer<ProviderAnalytics>(
      builder: (context, provider, child) {
        return Container(
          height: 50,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: EDateRange.values.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final range = EDateRange.values[index];
              final isSelected = provider.selectedRange == range;

              return GestureDetector(
                onTap: () => provider.selectDateRange(range),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryGreen : Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppColors.primaryGreen : Theme.of(context).dividerColor,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      range.label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildAnalyticsContent(AnalyticsData data) {
    return RefreshIndicator(
      onRefresh: () => context.read<ProviderAnalytics>().loadAnalytics(widget.deviceId),
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  // Period Info
                  PeriodInfo(period: data.analyzedPeriod),
                  const SizedBox(height: 16),

                  // Overall Summary Card
                  OverallSummaryCard(summary: data.overallSummary),

                  const SizedBox(height: 24),

                  // Analysis Sections
                  ...data.analyses.map((analysis) {
                    switch (analysis.type) {
                      case 'DEVICE_HEALTH_SCORE':
                        return HealthScoreSection(analysis: analysis);
                      case 'BATTERY_DRAIN_ANALYSIS':
                        return BatteryDrainSection(analysis: analysis);
                      case 'THERMAL_THROTTLING_ALERTS':
                        return ThermalSection(analysis: analysis);
                      case 'MEMORY_PRESSURE_INSIGHTS':
                        return MemorySection(analysis: analysis);
                      default:
                        return BusinessAnalysisCard(
                          analysis: analysis,
                          child: const SizedBox(),
                        );
                    }
                  }).toList(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading analytics...'),
        ],
      ),
    );
  }

  Widget _buildErrorState(ProviderAnalytics provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.errorRed,
            ),
            const SizedBox(height: 16),
            Text(
              provider.error!,
              style: const TextStyle(color: AppColors.errorRed),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => provider.loadAnalytics(widget.deviceId),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No analytics data available',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }


}
