import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
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

  String _title(AppLocalizations l10n) {
    switch (widget.type) {
      case DashboardListType.clients:
        return l10n.dashListTitleClients;
      case DashboardListType.animals:
        return l10n.dashListTitleAnimals;
      case DashboardListType.upcomingVisits:
        return l10n.dashListTitleUpcoming;
      case DashboardListType.pastDueVisits:
        return l10n.dashListTitlePastDue;
      case DashboardListType.outstandingVisits:
        return l10n.dashListTitleOutstanding;
      case DashboardListType.paidVisits:
        return l10n.dashListTitlePaid;
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

  String _emptyTitle(AppLocalizations l10n) {
    switch (widget.type) {
      case DashboardListType.clients:
        return l10n.noClientsYet;
      case DashboardListType.animals:
        return l10n.noAnimalsYet;
      case DashboardListType.upcomingVisits:
        return l10n.dashEmptyUpcomingTitle;
      case DashboardListType.pastDueVisits:
        return l10n.dashEmptyPastDueTitle;
      case DashboardListType.outstandingVisits:
        return l10n.dashEmptyOutstandingTitle;
      case DashboardListType.paidVisits:
        return l10n.dashEmptyPaidTitle;
    }
  }

  String _emptySubtitle(AppLocalizations l10n) {
    switch (widget.type) {
      case DashboardListType.clients:
        return l10n.dashEmptyClientsSubtitle;
      case DashboardListType.animals:
        return l10n.dashEmptyAnimalsSubtitle;
      case DashboardListType.upcomingVisits:
        return l10n.dashEmptyUpcomingSubtitle;
      case DashboardListType.pastDueVisits:
        return l10n.dashEmptyPastDueSubtitle;
      case DashboardListType.outstandingVisits:
        return l10n.dashEmptyOutstandingSubtitle;
      case DashboardListType.paidVisits:
        return l10n.dashEmptyPaidSubtitle;
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
        return DatabaseService.getUnpaidCompletedVisits();
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

  Widget _buildEmptyState(AppLocalizations l10n) {
    return EmptyState(
      icon: _emptyIcon,
      title: _emptyTitle(l10n),
      subtitle: _emptySubtitle(l10n),
    );
  }

  Widget _buildList(AppLocalizations l10n) {
    if (_isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.65,
            child: _buildEmptyState(l10n),
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
                        : l10n.noContactInfo,
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(_title(l10n))),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: _buildList(l10n),
            ),
    );
  }
}
