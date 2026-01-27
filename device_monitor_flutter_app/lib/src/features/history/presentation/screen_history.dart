import 'package:device_monitor/src/config/resources/app_colors.dart';
import 'package:device_monitor/src/config/resources/app_theme.dart';
import 'package:device_monitor/src/features/history/presentation/providers/provider_history.dart';
import 'package:device_monitor/src/features/vitals/presentation/widgets/chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ScreenHistory extends StatefulWidget {
  const ScreenHistory({super.key});

  @override
  State<ScreenHistory> createState() => _ScreenHistoryState();
}

class _ScreenHistoryState extends State<ScreenHistory> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProviderHistory>().refresh();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'History & Analytics',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).colorScheme.primary,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          tabs: const [
            Tab(icon: Icon(Icons.timeline), text: 'Analytics'),
            Tab(icon: Icon(Icons.history), text: 'History'),
          ],
        ),
      ),
      body: Consumer<ProviderHistory>(
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

          return TabBarView(
            controller: _tabController,
            children: [
              // Analytics Tab
              _buildAnalyticsTab(provider),

              // History Tab
              _buildHistoryTab(provider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAnalyticsTab(ProviderHistory provider) {
    if (provider.analytics == null || provider.logs.isEmpty) {
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
                  SizedBox(
                    height: 200,
                    child: ChartWidget(
                      data: provider.logs.reversed.take(20).toList().reversed.map((log) => log.batteryLevel.toDouble()).toList(),
                      color: AppColors.successGreen,
                      gradientColor: AppColors.lightGreen,
                    ),
                  ),
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
                  SizedBox(
                    height: 200,
                    child: ChartWidget(
                      data: provider.logs.reversed.take(20).toList().reversed.map((log) => log.memoryUsage.toDouble()).toList(),
                      color: AppColors.infoBlue,
                      gradientColor: const Color(0xFF60A5FA),
                    ),
                  ),
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
                  SizedBox(
                    height: 200,
                    child: ChartWidget(
                      data: provider.logs.reversed.take(20).toList().reversed.map((log) => log.thermalValue.toDouble()).toList(),
                      color: AppColors.warningAmber,
                      gradientColor: const Color(0xFFFBBF24),
                      maxY: 3,
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

  Widget _buildHistoryTab(ProviderHistory provider) {
    if (provider.logs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            const Text('No history available'),
            const SizedBox(height: 8),
            const Text(
              'Log some vitals to see history',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => provider.refresh(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: provider.logs.length,
        itemBuilder: (context, index) {
          final log = provider.logs[index];
          final isDark = Theme.of(context).brightness == Brightness.dark;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: AppTheme.getThermalColor(log.thermalValue, isDark).withOpacity(0.2),
                child: Icon(
                  Icons.monitor_heart,
                  color: AppTheme.getThermalColor(log.thermalValue, isDark),
                ),
              ),
              title: Text(
                DateFormat('MMM dd, yyyy HH:mm').format(log.timestamp),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    _buildChip(
                      'Thermal: ${log.thermalValue}',
                      AppTheme.getThermalColor(log.thermalValue, isDark),
                    ),
                    const SizedBox(width: 8),
                    _buildChip(
                      'Battery: ${log.batteryLevel}%',
                      AppColors.successGreen,
                    ),
                    const SizedBox(width: 8),
                    _buildChip(
                      'Memory: ${log.memoryUsage}%',
                      AppColors.infoBlue,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
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