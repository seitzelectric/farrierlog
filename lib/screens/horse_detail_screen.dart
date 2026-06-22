import 'dart:io';

import 'package:flutter/material.dart';

import '../models/models.dart';
import '../services/database_service.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';
import 'screens.dart';

class HorseDetailScreen extends StatefulWidget {
  final HorseWithClientInfo animal;

  const HorseDetailScreen({
    super.key,
    required this.animal,
  });

  @override
  State<HorseDetailScreen> createState() => _HorseDetailScreenState();
}

class _HorseDetailScreenState extends State<HorseDetailScreen> {
  late HorseWithClientInfo _animal;
  List<Visit> _visits = [];
  List<VisitPhotoWithVisit> _photos = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _animal = widget.animal;
    _loadData();
  }

  Future<void> _loadData() async {
    final horseId = _animal.horse.id!;
    final animal = await DatabaseService.getHorseWithClientInfo(horseId);
    final visits = await DatabaseService.getVisitsForHorse(horseId);
    final photos = await DatabaseService.getPhotosForHorse(horseId);

    if (!mounted) return;
    setState(() {
      if (animal != null) _animal = animal;
      _visits = visits;
      _photos = photos;
      _loading = false;
    });
  }

  Future<void> _openClient() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ClientDetailScreen(client: _animal.client),
      ),
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

  void _showPhotoFullScreen(VisitPhoto photo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: Text(photo.caption.isNotEmpty ? photo.caption : 'Photo'),
          ),
          body: Center(
            child: InteractiveViewer(
              child: Image.file(File(photo.path)),
            ),
          ),
        ),
      ),
    );
  }

  Map<int, List<VisitPhotoWithVisit>> get _photosByVisit {
    final grouped = <int, List<VisitPhotoWithVisit>>{};
    for (final entry in _photos) {
      grouped.putIfAbsent(entry.visit.id!, () => []).add(entry);
    }
    return grouped;
  }

  Widget _buildAnimalSummary() {
    final horse = _animal.horse;
    final details = [
      if (horse.breed.isNotEmpty) horse.breed,
      if (horse.color.isNotEmpty) horse.color,
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                HorseAvatar(horse: horse, radius: 30),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        horse.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      if (details.isNotEmpty)
                        Text(
                          details.join(' • '),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (horse.notes.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(horse.notes),
            ],
            const Divider(height: 32),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: ClientAvatar(client: _animal.client),
              title: Text(_animal.client.fullName),
              subtitle: const Text('Owner'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _openClient,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisitHistory() {
    if (_visits.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('No visits recorded for this animal yet.'),
      );
    }

    return Column(
      children: _visits.map((visit) {
        return VisitListTile(
          visit: visit,
          onTap: () => _openVisit(visit),
        );
      }).toList(),
    );
  }

  Widget _buildPhotoHistory() {
    final grouped = _photosByVisit;
    if (grouped.isEmpty) {
      return const EmptyState(
        icon: Icons.photo_library_outlined,
        title: 'No photos tagged to this animal yet.',
      );
    }

    // Sort entries oldest-first so progression reads top-to-bottom
    final entries = grouped.entries.toList()
      ..sort((a, b) {
        final aDate = a.value.first.visit.dateTime;
        final bDate = b.value.first.visit.dateTime;
        return aDate.compareTo(bDate);
      });

    return Column(
      children: List.generate(entries.length, (index) {
        final entry = entries[index];
        final visit = entry.value.first.visit;
        final photos = entry.value.map((item) => item.photo).toList();

        // Calculate elapsed time since previous visit
        String? elapsedLabel;
        if (index > 0) {
          final previousVisit = entries[index - 1].value.first.visit;
          final days =
              visit.dateTime.difference(previousVisit.dateTime).inDays.abs();
          if (days < 7) {
            elapsedLabel = '$days day${days == 1 ? '' : 's'} since last visit';
          } else {
            final weeks = (days / 7).round();
            elapsedLabel =
                '$weeks week${weeks == 1 ? '' : 's'} since last shoeing';
          }
        }

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppUtils.formatDate(visit.dateTime),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          if (elapsedLabel != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              elapsedLabel,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _openVisit(visit),
                      icon: const Icon(Icons.open_in_new, size: 18),
                      label: const Text('Open visit'),
                    ),
                  ],
                ),
                if (visit.notes.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    visit.notes,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 12),
                PhotoGrid(
                  photos: photos,
                  onTap: _showPhotoFullScreen,
                  showCaptionBelow: true,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animal')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildAnimalSummary(),
                  const SizedBox(height: 16),
                  SectionHeader(title: 'Visit History (${_visits.length})'),
                  _buildVisitHistory(),
                  const SizedBox(height: 16),
                  const SectionHeader(title: 'Photo History'),
                  _buildPhotoHistory(),
                ],
              ),
            ),
    );
  }
}
