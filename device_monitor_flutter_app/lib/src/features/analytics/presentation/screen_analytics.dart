import 'package:device_monitor/src/config/resources/app_colors.dart';
import 'package:device_monitor/src/config/resources/app_theme.dart';
import 'package:device_monitor/src/features/analytics/presentation/providers/provider_analytics.dart';
import 'package:device_monitor/src/features/history/presentation/providers/provider_history.dart';
import 'package:device_monitor/src/features/vitals/presentation/widgets/chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ScreenAnalytics extends StatefulWidget {
  const ScreenAnalytics({super.key});

  @override
  State<ScreenAnalytics> createState() => _ScreenAnalyticsState();
}

class _ScreenAnalyticsState extends State<ScreenAnalytics> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProviderAnalytics>().refresh();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vitals Analytics',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<ProviderAnalytics>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
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
                    onPressed: () => provider.refresh(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _buildAnalyticsTab(provider),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildAnalyticsTab(ProviderAnalytics provider) {
    if (provider.analytics == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.insert_chart_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            const Text('No analytics data available'),
            const SizedBox(height: 8),
            const Text(
              'Log some vitals to see analytics',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      );
    }

    final analytics = provider.analytics!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return RefreshIndicator(
      onRefresh: () => provider.refresh(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Summary Cards
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.analytics,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Rolling Average (Last 10 Entries)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildMetricRow(
                    'Thermal State',
                    analytics.avgThermal.toStringAsFixed(1),
                    AppTheme.getThermalColor(analytics.avgThermal.round(), isDark),
                    Icons.thermostat,
                  ),
                  const Divider(height: 24),
                  _buildMetricRow(
                    'Battery Level',
                    '${analytics.avgBattery.toStringAsFixed(1)}%',
                    AppColors.successGreen,
                    Icons.battery_charging_full,
                  ),
                  const Divider(height: 24),
                  _buildMetricRow(
                    'Memory Usage',
                    '${analytics.avgMemory.toStringAsFixed(1)}%',
                    AppColors.infoBlue,
                    Icons.memory,
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Entries',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        '${analytics.totalEntries}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Battery Chart
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Battery Level Trend',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Min: ${analytics.minBattery.toInt()}% | Max: ${analytics.maxBattery.toInt()}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // SizedBox(
                  //   height: 200,
                  //   child: ChartWidget(
                  //     data: provider.logs.reversed.take(20).toList().reversed.map((log) => log.batteryLevel.toDouble()).toList(),
                  //     color: AppColors.successGreen,
                  //     gradientColor: AppColors.lightGreen,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Memory Chart
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Memory Usage Trend',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Min: ${analytics.minMemory.toInt()}% | Max: ${analytics.maxMemory.toInt()}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // SizedBox(
                  //   height: 200,
                  //   child: ChartWidget(
                  //     data: provider.logs.reversed.take(20).toList().reversed.map((log) => log.memoryUsage.toDouble()).toList(),
                  //     color: AppColors.infoBlue,
                  //     gradientColor: const Color(0xFF60A5FA),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Thermal Chart
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thermal State Trend',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // SizedBox(
                  //   height: 200,
                  //   child: ChartWidget(
                  //     data: provider.logs.reversed.take(20).toList().reversed.map((log) => log.thermalValue.toDouble()).toList(),
                  //     color: AppColors.warningAmber,
                  //     gradientColor: const Color(0xFFFBBF24),
                  //     maxY: 3,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, Color color, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}