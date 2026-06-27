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
  Map<String, double> _mileage = {};
  Map<String, double> _revenue = {};
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
    final mileage = await DatabaseService.getMileageSummary();
    final revenue = await DatabaseService.getRevenueSummary();

    if (mounted) {
      setState(() {
        _stats = stats;
        _upcomingVisits = upcoming;
        _mileage = mileage;
        _revenue = revenue;
        _loading = false;
      });
    }
  }

  Future<void> _openList(DashboardListType type) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DashboardListScreen(type: type)),
    );
    _loadData();
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
                  onTap: () => _openList(DashboardListType.clients),
                ),
                _StatCard(
                  title: 'Total Animals',
                  value: '${_stats['totalHorses']}',
                  icon: Icons.pets,
                  color: Colors.brown,
                  onTap: () => _openList(DashboardListType.animals),
                ),
                _StatCard(
                  title: 'Upcoming',
                  value: '${_stats['upcomingVisits']}',
                  icon: Icons.event,
                  color: Colors.orange,
                  onTap: () => _openList(DashboardListType.upcomingVisits),
                ),
                _StatCard(
                  title: 'Past Due',
                  value: '${_stats['pastDueVisits']}',
                  icon: Icons.warning_amber,
                  color: (_stats['pastDueVisits'] as int) > 0
                      ? Colors.red
                      : Colors.green,
                  onTap: () => _openList(DashboardListType.pastDueVisits),
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
                    onTap: () => _openList(DashboardListType.paidVisits),
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
                    onTap: () => _openList(DashboardListType.outstandingVisits),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _TwoColumnCard(
              title: 'Miles Driven',
              icon: Icons.route,
              iconColor: Colors.deepOrange,
              columns: [
                _ColumnStat(
                  label: 'This Month',
                  value: AppUtils.formatDistance(_mileage['month'] ?? 0),
                ),
                _ColumnStat(
                  label: 'This Year',
                  value: AppUtils.formatDistance(_mileage['year'] ?? 0),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _RevenueCard(
              earnedMonth: _revenue['earnedMonth'] ?? 0,
              earnedYear: _revenue['earnedYear'] ?? 0,
              projectedMonth: _revenue['projectedMonth'] ?? 0,
              projectedYear: _revenue['projectedYear'] ?? 0,
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

class _ColumnStat {
  final String label;
  final String value;
  const _ColumnStat({required this.label, required this.value});
}

class _TwoColumnCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final List<_ColumnStat> columns;

  const _TwoColumnCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.columns,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 18),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: columns
                  .map((c) => Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              c.label,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .outline,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              c.value,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _RevenueCard extends StatelessWidget {
  final double earnedMonth;
  final double earnedYear;
  final double projectedMonth;
  final double projectedYear;

  const _RevenueCard({
    required this.earnedMonth,
    required this.earnedYear,
    required this.projectedMonth,
    required this.projectedYear,
  });

  @override
  Widget build(BuildContext context) {
    final outline = Theme.of(context).colorScheme.outline;
    final labelStyle =
        Theme.of(context).textTheme.bodySmall?.copyWith(color: outline);
    final valueStyle = Theme.of(context)
        .textTheme
        .titleMedium
        ?.copyWith(fontWeight: FontWeight.bold);
    final earnedColor = Theme.of(context).colorScheme.primary;
    final projectedColor = outline;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.attach_money, color: earnedColor, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Revenue',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Expanded(child: SizedBox()),
                Expanded(
                  child: Text('This Month',
                      style: labelStyle, textAlign: TextAlign.center),
                ),
                Expanded(
                  child: Text('This Year',
                      style: labelStyle, textAlign: TextAlign.center),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline,
                          size: 14, color: earnedColor),
                      const SizedBox(width: 4),
                      Text('Earned',
                          style: labelStyle?.copyWith(color: earnedColor)),
                    ],
                  ),
                ),
                Expanded(
                  child: Text(
                    AppUtils.formatCurrency(earnedMonth),
                    style: valueStyle?.copyWith(color: earnedColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    AppUtils.formatCurrency(earnedYear),
                    style: valueStyle?.copyWith(color: earnedColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.schedule, size: 14, color: projectedColor),
                      const SizedBox(width: 4),
                      Text('Projected', style: labelStyle),
                    ],
                  ),
                ),
                Expanded(
                  child: Text(
                    AppUtils.formatCurrency(projectedMonth),
                    style: valueStyle?.copyWith(color: projectedColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    AppUtils.formatCurrency(projectedYear),
                    style: valueStyle?.copyWith(color: projectedColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
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
  final VoidCallback onTap;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
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
      ),
    );
  }
}
