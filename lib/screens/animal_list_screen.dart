import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/database_service.dart';
import '../widgets/widgets.dart';
import 'horse_detail_screen.dart';

class AnimalListScreen extends StatefulWidget {
  const AnimalListScreen({super.key});

  @override
  State<AnimalListScreen> createState() => _AnimalListScreenState();
}

class _AnimalListScreenState extends State<AnimalListScreen> {
  List<HorseWithClientInfo> _all = [];
  List<HorseWithClientInfo> _filtered = [];
  final _searchCtrl = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_onSearch);
    _loadData();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final animals = await DatabaseService.getAllHorsesWithClientInfo();
    if (mounted) {
      setState(() {
        _all = animals;
        _applyFilter(_searchCtrl.text);
        _loading = false;
      });
    }
  }

  void _onSearch() => setState(() => _applyFilter(_searchCtrl.text));

  void _applyFilter(String query) {
    final q = query.toLowerCase().trim();
    _filtered = q.isEmpty
        ? List.of(_all)
        : _all
            .where((a) =>
                a.horse.name.toLowerCase().contains(q) ||
                a.client.fullName.toLowerCase().contains(q) ||
                a.horse.breed.toLowerCase().contains(q))
            .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animals'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchCtrl,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Search by animal or client name...',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                isDense: true,
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchCtrl.clear();
                        },
                      )
                    : null,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Text(
                  '${_filtered.length} animal${_filtered.length == 1 ? '' : 's'}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.pets_outlined,
                                size: 64,
                                color: Theme.of(context).colorScheme.outline),
                            const SizedBox(height: 16),
                            Text(
                              _searchCtrl.text.isEmpty
                                  ? 'No animals yet'
                                  : 'No animals match "${_searchCtrl.text}"',
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadData,
                        child: ListView.separated(
                          padding: const EdgeInsets.only(bottom: 16),
                          itemCount: _filtered.length,
                          separatorBuilder: (_, __) =>
                              const Divider(height: 1, indent: 72),
                          itemBuilder: (context, index) {
                            final animal = _filtered[index];
                            return ListTile(
                              leading: HorseAvatar(
                                  horse: animal.horse, radius: 22),
                              title: Text(animal.horse.name),
                              subtitle: Text(
                                [
                                  animal.client.fullName,
                                  if (animal.horse.breed.isNotEmpty)
                                    animal.horse.breed,
                                ].join(' · '),
                              ),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        HorseDetailScreen(animal: animal),
                                  ),
                                );
                                _loadData();
                              },
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
