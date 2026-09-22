import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';
import '../models/models.dart';
import '../services/database_service.dart';
import '../widgets/widgets.dart';
import 'screens.dart';

class ClientListScreen extends StatefulWidget {
  final bool autoOpenAddDialog;

  const ClientListScreen({super.key, this.autoOpenAddDialog = false});

  @override
  State<ClientListScreen> createState() => _ClientListScreenState();
}

class _ClientListScreenState extends State<ClientListScreen> {
  List<Map<String, dynamic>> _clients = [];
  bool _loading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadClients();
    if (widget.autoOpenAddDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _addClientDialog();
      });
    }
  }

  Future<void> _loadClients() async {
    final clients = await DatabaseService.getClientsWithLastVisit(
      searchQuery: _searchQuery.isEmpty ? null : _searchQuery,
    );

    if (mounted) {
      setState(() {
        _clients = clients;
        _loading = false;
      });
    }
  }

  Future<void> _addClientDialog() async {
    final result = await showDialog<Client>(
      context: context,
      builder: (_) => const ClientFormDialog(),
    );

    if (result != null) {
      await DatabaseService.insertClient(result);
      _loadClients();
    }
  }

  Future<bool> _confirmDeleteClient(Client client) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await ConfirmationDialog.show(
      context,
      title: l10n.deleteClientTitle,
      message: l10n.clientListDeleteMessage(client.fullName),
    );
    if (confirmed == true) {
      await DatabaseService.deleteClient(client.id!);
      await _loadClients();
    }
    return false;
  }

  void _showSearch() {
    showSearch(
      context: context,
      delegate: _ClientSearchDelegate(
        onQueryChanged: (query) {
          _searchQuery = query;
          _loadClients();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navClients),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearch,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _clients.isEmpty
              ? EmptyState(
                  icon: Icons.people_outline,
                  title: l10n.noClientsYet,
                  subtitle: l10n.addFirstClientSubtitle,
                  action: ElevatedButton.icon(
                    onPressed: _addClientDialog,
                    icon: const Icon(Icons.add),
                    label: Text(l10n.addClientButton),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadClients,
                  child: ListView.separated(
                    itemCount: _clients.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final row = _clients[i];
                      final client = Client.fromMap(row);
                      final lastVisitDate = row['last_visit_date'] as String?;
                      final upcomingCount =
                          (row['upcoming_count'] as int?) ?? 0;

                      return Dismissible(
                        key: ValueKey('client-${client.id}'),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (_) => _confirmDeleteClient(client),
                        child: ListTile(
                          leading: ClientAvatar(client: client),
                          title: Text(client.fullName),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                client.phone.isNotEmpty
                                    ? client.phone
                                    : client.email.isNotEmpty
                                        ? client.email
                                        : l10n.noContactInfo,
                              ),
                              const SizedBox(height: 2),
                              LastVisitBadge(
                                lastVisitDateStr: lastVisitDate,
                                upcomingCount: upcomingCount,
                              ),
                            ],
                          ),
                          isThreeLine: true,
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ClientDetailScreen(client: client),
                              ),
                            );
                            _loadClients();
                          },
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addClientDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ClientSearchDelegate extends SearchDelegate<String> {
  final Function(String) onQueryChanged;

  _ClientSearchDelegate({required this.onQueryChanged});

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, ''),
      );

  @override
  Widget buildResults(BuildContext context) => buildSuggestions(context);

  @override
  Widget buildSuggestions(BuildContext context) {
    onQueryChanged(query);
    return const SizedBox.shrink();
  }
}
