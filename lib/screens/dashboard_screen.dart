import '../widgets/widgets.dart';
import 'package:fl_chart/fl_chart.dart';
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
  List<Map<String, dynamic>> _monthlyRevenue = [];
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
    final monthlyRevenue = await DatabaseService.getMonthlyRevenue();

    if (mounted) {
      setState(() {
        _stats = stats;
        _upcomingVisits = upcoming;
        _mileage = mileage;
        _monthlyRevenue = monthlyRevenue;
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
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: ListTile(
                leading: Icon(
                  Icons.route,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                title: Text(
                  "Today's Route",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                subtitle: Text(
                  'See all of today\'s stops in order',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TodayRouteScreen()),
                  );
                  _loadData();
                },
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2.2,
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
            _RevenueChartCard(data: _monthlyRevenue),
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

class _RevenueChartCard extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  const _RevenueChartCard({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();
    final maxVal = data
        .map((d) => d['total'] as double)
        .fold<double>(0, (a, b) => a > b ? a : b);

    const monthNames = [
      '',
      'J',
      'F',
      'M',
      'A',
      'M',
      'J',
      'J',
      'A',
      'S',
      'O',
      'N',
      'D'
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bar_chart,
                    color: Theme.of(context).colorScheme.primary, size: 18),
                const SizedBox(width: 8),
                Text('Revenue Trend (12 mo)',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 160,
              child: BarChart(
                BarChartData(
                  maxY: maxVal == 0 ? 100 : maxVal * 1.2,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, _, rod, __) {
                        final d = data[group.x.toInt()];
                        return BarTooltipItem(
                          AppUtils.formatCurrency(d['total'] as double),
                          const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          final i = value.toInt();
                          if (i < 0 || i >= data.length) {
                            return const SizedBox.shrink();
                          }
                          final m = data[i]['month'] as int;
                          return Text(monthNames[m],
                              style: const TextStyle(fontSize: 9));
                        },
                      ),
                    ),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(data.length, (i) {
                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: data[i]['total'] as double,
                          color: Theme.of(context).colorScheme.primary,
                          width: 12,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(3),
                            topRight: Radius.circular(3),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
