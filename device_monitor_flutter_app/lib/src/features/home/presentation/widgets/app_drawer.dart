import 'package:device_monitor/src/config/routes/routes.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  static const List<String> deviceIds = [
    'DEV00000001',
    'DEV00000002',
    'DEV00000003',
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildSection(
                    context: context,
                    title: 'View Analytics',
                    icon: Icons.analytics_outlined,
                    routeName: Routes.analyticsScreen,
                  ),
                  const Divider(),
                  _buildSection(
                    context: context,
                    title: 'View History',
                    icon: Icons.history_outlined,
                    routeName: Routes.historyScreen,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Text(
        'Quick Test',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required IconData icon,
    required String routeName,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          dense: true,
          leading: Icon(icon),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        ...deviceIds.map(
              (deviceId) => ListTile(
            contentPadding: const EdgeInsets.only(left: 56,right: 24),
            title: Text(deviceId),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pop(context); // close drawer
              Navigator.pushNamed(
                context,
                routeName,
                arguments: deviceId,
              );
            },
          ),
        ),
      ],
    );
  }
}
