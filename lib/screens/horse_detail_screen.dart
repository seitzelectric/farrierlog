import 'dart:io';

import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/models.dart';
import '../services/database_service.dart';
import '../services/invoice_service.dart';
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

  Future<void> _shareProgressReport() async {
    if (_photos.isEmpty) return;
    final file = await InvoiceService.generateProgressReport(
      horse: _animal.horse,
      client: _animal.client,
      photos: _photos,
    );
    if (!mounted) return;
    await InvoiceService.shareInvoice(
      file,
      subject: AppLocalizations.of(context)!.progressReportSubject(_animal.horse.name),
    );
  }

  void _showPhotoFullScreen(VisitPhoto photo) {
    final l10n = AppLocalizations.of(context)!;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: Text(photo.caption.isNotEmpty ? photo.caption : l10n.photoDefaultTitle),
          ),
          body: Center(
            child: InteractiveViewer(
              child: Image.file(
                File(photo.path),
                cacheWidth: AppUtils.cachePixels(
                  context,
                  MediaQuery.of(context).size.width,
                ),
              ),
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

  Widget _buildAnimalSummary(AppLocalizations l10n) {
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
              subtitle: Text(l10n.ownerLabel),
              trailing: const Icon(Icons.chevron_right),
              onTap: _openClient,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisitHistory(AppLocalizations l10n) {
    if (_visits.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(l10n.noVisitsRecordedForAnimal),
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

  Widget _buildPhotoHistory(AppLocalizations l10n) {
    final grouped = _photosByVisit;
    if (grouped.isEmpty) {
      return EmptyState(
        icon: Icons.photo_library_outlined,
        title: l10n.noPhotosForAnimal,
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
            elapsedLabel = l10n.daysSinceLastVisit(days);
          } else {
            final weeks = (days / 7).round();
            elapsedLabel = l10n.weeksSinceLastShoeing(weeks);
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
                    if (index == 0 && _photos.length >= 2)
                      TextButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PhotoComparisonScreen(
                              photos: _photos,
                              initialLeftIndex: 0,
                              initialRightIndex: _photos.length - 1,
                            ),
                          ),
                        ),
                        icon: const Icon(Icons.compare, size: 18),
                        label: Text(l10n.compareButton),
                      ),
                    TextButton.icon(
                      onPressed: () => _openVisit(visit),
                      icon: const Icon(Icons.open_in_new, size: 18),
                      label: Text(l10n.openVisitButton),
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.animalTitle),
        actions: [
          if (_photos.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              tooltip: l10n.progressReportTooltip,
              onPressed: _shareProgressReport,
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildAnimalSummary(l10n),
                  const SizedBox(height: 16),
                  SectionHeader(title: l10n.visitHistoryTitle(_visits.length)),
                  _buildVisitHistory(l10n),
                  const SizedBox(height: 16),
                  SectionHeader(
                    title: l10n.photoHistoryTitle,
                    onAdd: _photos.length >= 2
                        ? () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    PhotoComparisonScreen(photos: _photos),
                              ),
                            )
                        : null,
                    addLabel: l10n.compareButton,
                  ),
                  _buildPhotoHistory(l10n),
                ],
              ),
            ),
    );
  }
}
