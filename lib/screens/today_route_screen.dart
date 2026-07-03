import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/models.dart';
import '../services/database_service.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';
import 'screens.dart';

class TodayRouteScreen extends StatefulWidget {
  const TodayRouteScreen({super.key});

  @override
  State<TodayRouteScreen> createState() => _TodayRouteScreenState();
}

class _TodayRouteScreenState extends State<TodayRouteScreen> {
  List<Map<String, dynamic>> _stops = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final stops = await DatabaseService.getTodayRoute();
    if (mounted) {
      setState(() {
        _stops = stops;
        _loading = false;
      });
    }
  }

  Future<void> _openFullRoute() async {
    final addresses = _stops
        .map((s) => (s['address'] as String?) ?? '')
        .where((a) => a.isNotEmpty)
        .toList();
    if (addresses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('No addresses on file for today\'s visits')),
      );
      return;
    }
    final url = AppUtils.multiStopRouteUrl(addresses);
    if (url.isNotEmpty) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _navigateToStop(String address) async {
    if (address.isEmpty) return;
    await AppUtils.openGoogleMapsSearch(address);
  }

  Future<void> _remindTomorrow() async {
    final visits = await DatabaseService.getTomorrowVisitsForReminders();
    if (visits.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('No visits with phone numbers tomorrow')),
      );
      return;
    }
    final template = await DatabaseService.getReminderTemplate();

    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        builder: (_, scroll) => Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text("Tomorrow's Reminders",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                controller: scroll,
                itemCount: visits.length,
                itemBuilder: (_, i) {
                  final v = visits[i];
                  final visit = Visit.fromMap(v);
                  final firstName = v['first_name'] as String? ?? '';
                  final phone = (v['phone'] as String? ?? '')
                      .replaceAll(RegExp(r'[^0-9+]'), '');
                  return ListTile(
                    title: Text(visit.clientName),
                    subtitle: Text(AppUtils.formatTime(visit.dateTime)),
                    trailing: TextButton.icon(
                      icon: const Icon(Icons.sms),
                      label: const Text('Send'),
                      onPressed: () async {
                        final message = template
                            .replaceAll('{name}', firstName)
                            .replaceAll(
                                '{date}',
                                AppUtils.formatDate(visit.dateTime))
                            .replaceAll(
                                '{time}',
                                AppUtils.formatTime(visit.dateTime));
                        final uri = Uri.parse(
                            'sms:$phone?body=${Uri.encodeComponent(message)}');
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final addressCount = _stops
        .where((s) => ((s['address'] as String?) ?? '').isNotEmpty)
        .length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Today's Route"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active),
            tooltip: "Remind Tomorrow's Clients",
            onPressed: _remindTomorrow,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _stops.isEmpty
              ? const EmptyState(
                  icon: Icons.route,
                  title: 'No visits scheduled today',
                  subtitle: 'Enjoy the day off, or schedule a visit.',
                )
              : Column(
                  children: [
                    Container(
                      width: double.infinity,
                      color: Theme.of(context).colorScheme.primaryContainer,
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        '${_stops.length} visit${_stops.length == 1 ? '' : 's'} today'
                        '${addressCount < _stops.length ? ' · ${_stops.length - addressCount} missing address' : ''}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _stops.length,
                        itemBuilder: (_, i) {
                          final stop = _stops[i];
                          final visit = Visit.fromMap(stop);
                          final address = (stop['address'] as String?) ?? '';

                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text('${i + 1}'),
                              ),
                              title: Text(visit.clientName),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(AppUtils.formatTime(visit.dateTime)),
                                  if (address.isNotEmpty)
                                    Text(address,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall)
                                  else
                                    Text('No address on file',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                          fontSize: 12,
                                        )),
                                ],
                              ),
                              isThreeLine: true,
                              trailing: address.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.navigation),
                                      tooltip: 'Navigate',
                                      onPressed: () =>
                                          _navigateToStop(address),
                                    )
                                  : null,
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        VisitDetailScreen(visit: visit),
                                  ),
                                );
                                _load();
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
      floatingActionButton: _stops.isNotEmpty && addressCount > 0
          ? FloatingActionButton.extended(
              onPressed: _openFullRoute,
              icon: const Icon(Icons.map),
              label: const Text('Open Full Route'),
            )
          : null,
    );
  }
}
