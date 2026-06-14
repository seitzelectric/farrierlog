import 'package:flutter/material.dart';

import '../models/models.dart';
import '../services/database_service.dart';
import '../widgets/widgets.dart';
import 'screens.dart';

enum DashboardListType {
  clients,
  animals,
  upcomingVisits,
  pastDueVisits,
  outstandingVisits,
  paidVisits,
}

class DashboardListScreen extends StatefulWidget {
  final DashboardListType type;

  const DashboardListScreen({
    super.key,
    required this.type,
  });

  @override
  State<DashboardListScreen> createState() => _DashboardListScreenState();
}

class _DashboardListScreenState extends State<DashboardListScreen> {
  List<Client> _clients = [];
  List<HorseWithClientInfo> _animals = [];
  List<Visit> _visits = [];
  bool _loading = true;

  String get _title {
    switch (widget.type) {
      case DashboardListType.clients:
        return 'Clients';
      case DashboardListType.animals:
        return 'Animals';
      case DashboardListType.upcomingVisits:
        return 'Upcoming Visits';
      case DashboardListType.pastDueVisits:
        return 'Past Due Visits';
      case DashboardListType.outstandingVisits:
        return 'Outstanding Visits';
      case DashboardListType.paidVisits:
        return 'Paid Visits';
    }
  }

  IconData get _emptyIcon {
    switch (widget.type) {
      case DashboardListType.clients:
        return Icons.people_outline;
      case DashboardListType.animals:
        return Icons.pets;
      case DashboardListType.upcomingVisits:
        return Icons.event_available;
      case DashboardListType.pastDueVisits:
        return Icons.warning_amber;
      case DashboardListType.outstandingVisits:
        return Icons.account_balance_wallet_outlined;
      case DashboardListType.paidVisits:
        return Icons.paid_outlined;
    }
  }

  String get _emptyTitle {
    switch (widget.type) {
      case DashboardListType.clients:
        return 'No clients yet';
      case DashboardListType.animals:
        return 'No animals yet';
      case DashboardListType.upcomingVisits:
        return 'No upcoming visits';
      case DashboardListType.pastDueVisits:
        return 'No past due visits';
      case DashboardListType.outstandingVisits:
        return 'No outstanding visits';
      case DashboardListType.paidVisits:
        return 'No paid visits yet';
    }
  }

  String get _emptySubtitle {
    switch (widget.type) {
      case DashboardListType.clients:
        return 'Add clients from the Clients tab.';
      case DashboardListType.animals:
        return 'Animals will appear here after they are added to clients.';
      case DashboardListType.upcomingVisits:
        return 'No unpaid visits are scheduled in the next 30 days.';
      case DashboardListType.pastDueVisits:
        return 'All unpaid visits are current.';
      case DashboardListType.outstandingVisits:
        return 'All visits are marked paid.';
      case DashboardListType.paidVisits:
        return 'Paid visits will appear here after invoices or visits are marked paid.';
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);

    final type = widget.type;
    final clients = type == DashboardListType.clients
        ? await DatabaseService.getClients()
        : <Client>[];
    final animals = type == DashboardListType.animals
        ? await DatabaseService.getAllHorsesWithClientInfo()
        : <HorseWithClientInfo>[];
    final visits = await _loadVisits(type);

    if (!mounted) return;
    setState(() {
      _clients = clients;
      _animals = animals;
      _visits = visits;
      _loading = false;
    });
  }

  Future<List<Visit>> _loadVisits(DashboardListType type) {
    switch (type) {
      case DashboardListType.upcomingVisits:
        return DatabaseService.getUpcomingVisits();
      case DashboardListType.pastDueVisits:
        return DatabaseService.getPastDueVisits();
      case DashboardListType.outstandingVisits:
        return DatabaseService.getUnpaidVisits();
      case DashboardListType.paidVisits:
        return DatabaseService.getPaidVisits();
      case DashboardListType.clients:
      case DashboardListType.animals:
        return Future.value(<Visit>[]);
    }
  }

  bool get _isEmpty {
    switch (widget.type) {
      case DashboardListType.clients:
        return _clients.isEmpty;
      case DashboardListType.animals:
        return _animals.isEmpty;
      case DashboardListType.upcomingVisits:
      case DashboardListType.pastDueVisits:
      case DashboardListType.outstandingVisits:
      case DashboardListType.paidVisits:
        return _visits.isEmpty;
    }
  }

  Future<void> _openClient(Client client) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ClientDetailScreen(client: client)),
    );
    _loadData();
  }

  Future<void> _openVisit(Visit visit) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => VisitDetailScreen(visit: visit)),
    );
    _loadData();
  }

  Future<void> _openAnimal(HorseWithClientInfo animal) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => HorseDetailScreen(animal: animal)),
    );
    _loadData();
  }

  Widget _buildEmptyState() {
    return EmptyState(
      icon: _emptyIcon,
      title: _emptyTitle,
      subtitle: _emptySubtitle,
    );
  }

  Widget _buildList() {
    if (_isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.65,
            child: _buildEmptyState(),
          ),
        ],
      );
    }

    switch (widget.type) {
      case DashboardListType.clients:
        return ListView.separated(
          itemCount: _clients.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, index) {
            final client = _clients[index];
            return ListTile(
              leading: ClientAvatar(client: client),
              title: Text(client.fullName),
              subtitle: Text(
                client.phone.isNotEmpty
                    ? client.phone
                    : client.email.isNotEmpty
                        ? client.email
                        : 'No contact info',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _openClient(client),
            );
          },
        );
      case DashboardListType.animals:
        return ListView.separated(
          itemCount: _animals.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, index) {
            final entry = _animals[index];
            final horse = entry.horse;
            return ListTile(
              leading: HorseAvatar(horse: horse),
              title: Text(horse.name),
              subtitle: Text(
                [
                  entry.client.fullName,
                  if (horse.breed.isNotEmpty) horse.breed,
                  if (horse.color.isNotEmpty) horse.color,
                ].join(' • '),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _openAnimal(entry),
            );
          },
        );
      case DashboardListType.upcomingVisits:
      case DashboardListType.pastDueVisits:
      case DashboardListType.outstandingVisits:
      case DashboardListType.paidVisits:
        return ListView.builder(
          itemCount: _visits.length,
          itemBuilder: (_, index) {
            final visit = _visits[index];
            return VisitListTile(
              visit: visit,
              onTap: () => _openVisit(visit),
            );
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: _buildList(),
            ),
    );
  }
}
