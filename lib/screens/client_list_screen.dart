import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/database_service.dart';
import '../widgets/widgets.dart';
import 'screens.dart';

class ClientListScreen extends StatefulWidget {
  const ClientListScreen({super.key});

  @override
  State<ClientListScreen> createState() => _ClientListScreenState();
}

class _ClientListScreenState extends State<ClientListScreen> {
  List<Client> _clients = [];
  bool _loading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  Future<void> _loadClients() async {
    final clients = await DatabaseService.getClients(
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clients'),
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
                  title: 'No clients yet',
                  subtitle: 'Add your first client to get started',
                  action: ElevatedButton.icon(
                    onPressed: _addClientDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Client'),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadClients,
                  child: ListView.separated(
                    itemCount: _clients.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final client = _clients[i];

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
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ClientDetailScreen(client: client),
                            ),
                          );
                          _loadClients();
                        },
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
