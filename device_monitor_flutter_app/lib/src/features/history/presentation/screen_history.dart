import 'package:device_monitor/src/config/resources/app_colors.dart';
import 'package:device_monitor/src/core/enums/e_loading.dart';
import 'package:device_monitor/src/features/history/presentation/providers/provider_history.dart';
import 'package:device_monitor/src/features/history/presentation/widgets/history_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenHistory extends StatefulWidget {
  final String deviceId;

  const ScreenHistory({super.key, required this.deviceId});

  @override
  State<ScreenHistory> createState() => _ScreenHistoryState();
}

class _ScreenHistoryState extends State<ScreenHistory> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProviderHistory>().loadHistory(deviceId: widget.deviceId);
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final provider = context.read<ProviderHistory>();

    // Load next page when scrolled near bottom
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (provider.hasMoreNext && provider.loading == null) {
        provider.loadNextPage();
      }
    }

    // Load previous page when scrolled near top
    if (_scrollController.position.pixels == _scrollController.position.minScrollExtent) {
      if (provider.hasMorePrevious && provider.loading == null) {
        provider.loadPreviousPage();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vitals History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<ProviderHistory>(
        builder: (context, provider, child) {
          if (provider.loading == ELoading.loading) {
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
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: provider.loading == ELoading.fetchingPreviousPage
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : const SizedBox(),
              ),
              SliverToBoxAdapter(
                child: _buildHistoryTab(provider),
              ),
              SliverToBoxAdapter(
                child: provider.loading == ELoading.fetchingNextPage
                    ? Center(
                  child: CircularProgressIndicator(),
                )
                    : const SizedBox(),
              ),
            ],
          );
        },
      ),
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
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: provider.logs.length,
        itemBuilder: (context, index) {
          final log = provider.logs[index];

          return HistoryCard(log: log);
        },
      ),
    );
  }
}
