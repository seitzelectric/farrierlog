import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  List<_HelpSection> _sections(AppLocalizations l10n) => [
    _HelpSection(
      icon: Icons.rocket_launch_outlined,
      title: l10n.helpSectionGettingStartedTitle,
      steps: [
        l10n.helpStepGettingStarted1,
        l10n.helpStepGettingStarted2,
        l10n.helpStepGettingStarted3,
        l10n.helpStepGettingStarted4,
      ],
    ),
    _HelpSection(
      icon: Icons.people_outline,
      title: l10n.helpSectionClientsAnimalsTitle,
      steps: [
        l10n.helpStepClientsAnimals1,
        l10n.helpStepClientsAnimals2,
        l10n.helpStepClientsAnimals3,
        l10n.helpStepClientsAnimals4,
        l10n.helpStepClientsAnimals5,
        l10n.helpStepClientsAnimals6,
      ],
    ),
    _HelpSection(
      icon: Icons.calendar_month_outlined,
      title: l10n.helpSectionSchedulingTitle,
      steps: [
        l10n.helpStepScheduling1,
        l10n.helpStepScheduling2,
        l10n.helpStepScheduling3,
        l10n.helpStepScheduling4,
        l10n.helpStepScheduling5,
      ],
    ),
    _HelpSection(
      icon: Icons.receipt_long_outlined,
      title: l10n.helpSectionInvoicingTitle,
      steps: [
        l10n.helpStepInvoicing1,
        l10n.helpStepInvoicing2,
        l10n.helpStepInvoicing3,
        l10n.helpStepInvoicing4,
        l10n.helpStepInvoicing5,
      ],
    ),
    _HelpSection(
      icon: Icons.payments_outlined,
      title: l10n.helpSectionGettingPaidTitle,
      steps: [
        l10n.helpStepGettingPaid1,
        l10n.helpStepGettingPaid2,
        l10n.helpStepGettingPaid3,
        l10n.helpStepGettingPaid4,
      ],
    ),
    _HelpSection(
      icon: Icons.photo_camera_outlined,
      title: l10n.helpSectionPhotosTitle,
      steps: [
        l10n.helpStepPhotos1,
        l10n.helpStepPhotos2,
        l10n.helpStepPhotos3,
        l10n.helpStepPhotos4,
      ],
    ),
    _HelpSection(
      icon: Icons.search_outlined,
      title: l10n.helpSectionFindingTitle,
      steps: [
        l10n.helpStepFinding1,
        l10n.helpStepFinding2,
        l10n.helpStepFinding3,
        l10n.helpStepFinding4,
      ],
    ),
    _HelpSection(
      icon: Icons.backup_outlined,
      title: l10n.helpSectionBackupsTitle,
      steps: [
        l10n.helpStepBackups1,
        l10n.helpStepBackups2,
        l10n.helpStepBackups3,
        l10n.helpStepBackups4,
      ],
    ),
    _HelpSection(
      icon: Icons.wifi_off_outlined,
      title: l10n.helpSectionOfflineTitle,
      steps: [
        l10n.helpStepOffline1,
        l10n.helpStepOffline2,
        l10n.helpStepOffline3,
        l10n.helpStepOffline4,
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.helpTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.menu_book_outlined,
                          color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l10n.welcomeToFarrierLog,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.helpIntro,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ..._sections(l10n).map((section) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                clipBehavior: Clip.antiAlias,
                child: ExpansionTile(
                  leading: Icon(section.icon),
                  title: Text(
                    section.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  childrenPadding:
                      const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < section.steps.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 24,
                              child: Text(
                                '${i + 1}.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                section.steps[i],
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _HelpSection {
  final IconData icon;
  final String title;
  final List<String> steps;

  const _HelpSection({
    required this.icon,
    required this.title,
    required this.steps,
  });
}
