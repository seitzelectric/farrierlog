import '../widgets/widgets.dart';
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/database_service.dart';
import '../utils/utils.dart';
import 'screens.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic> _stats = {};
  List<Visit> _upcomingVisits = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);

    final stats = await DatabaseService.getStats();
    final now = DateTime.now();
    final upcoming = await DatabaseService.getVisits(
      from: now,
      to: now.add(const Duration(days: 7)),
    );

    if (mounted) {
      setState(() {
        _stats = stats;
        _upcomingVisits = upcoming;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _StatCard(
                  title: 'Total Clients',
                  value: '${_stats['totalClients']}',
                  icon: Icons.people,
                  color: Colors.blue,
                ),
                _StatCard(
                  title: 'Total Horses',
                  value: '${_stats['totalHorses']}',
                  icon: Icons.dataset,
                  color: Colors.brown,
                ),
                _StatCard(
                  title: 'Upcoming',
                  value: '${_stats['upcomingVisits']}',
                  icon: Icons.event,
                  color: Colors.orange,
                ),
                _StatCard(
                  title: 'Past Due',
                  value: '${_stats['unpaidVisits']}',
                  icon: Icons.warning_amber,
                  color: (_stats['unpaidVisits'] as int) > 0
                      ? Colors.red
                      : Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Total Revenue',
                    value: AppUtils.formatCurrency(
                      (_stats['totalRevenue'] as num).toDouble(),
                    ),
                    icon: Icons.attach_money,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    title: 'Outstanding',
                    value: AppUtils.formatCurrency(
                      (_stats['outstandingRevenue'] as num).toDouble(),
                    ),
                    icon: Icons.account_balance_wallet,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SectionHeader(
              title: 'Next 7 Days',
              onAdd: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NewVisitScreen()),
                );
                _loadData();
              },
              addLabel: 'New Visit',
            ),
            if (_upcomingVisits.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('No upcoming visits this week'),
              )
            else
              ..._upcomingVisits.map(
                (v) => VisitListTile(
                  visit: v,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VisitDetailScreen(visit: v),
                      ),
                    );
                    _loadData();
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                ),
                Icon(icon, color: color, size: 20),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
