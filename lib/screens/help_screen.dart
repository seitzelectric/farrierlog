import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const List<_HelpSection> _sections = [
    _HelpSection(
      icon: Icons.rocket_launch_outlined,
      title: 'Getting Started',
      steps: [
        'Open Settings and fill in your company name, address, phone, and email — this appears on every invoice you send.',
        'Pick a color theme and set your preferred currency and distance unit.',
        'Add your first client from the Clients tab, then add their animals.',
        'Schedule a visit from the client\'s page or the calendar\'s new appointment button.',
      ],
    ),
    _HelpSection(
      icon: Icons.people_outline,
      title: 'Clients & Animals',
      steps: [
        'Go to the Clients tab and tap the add button to create a new client with their contact details and address.',
        'Open a client\'s page and tap "Add Animal" to add each horse or other animal you service for them.',
        'Tap a client\'s phone number to call, or long-press it to text.',
        'Tap a client\'s address to open it in maps for directions.',
        'Use "Internal Notes" on a client or animal for private staff notes — these never appear on invoices.',
        'Swipe left on a client or animal to delete it. Deleting a client also deletes their animals, visits, and photos.',
      ],
    ),
    _HelpSection(
      icon: Icons.calendar_month_outlined,
      title: 'Scheduling Visits',
      steps: [
        'Tap the calendar tab to see all upcoming and past visits — solid markers are confirmed, outlined markers are auto-generated projections.',
        'Tap the new appointment button on the calendar to schedule a visit on a specific date.',
        'Search for a client by name or address instead of scrolling a long list.',
        'Set a recurrence interval (in weeks) on a visit to automatically project the next appointment once you confirm the current one.',
        'Confirming an auto-generated visit creates the next projected visit in the chain — future visits are not created all at once.',
      ],
    ),
    _HelpSection(
      icon: Icons.receipt_long_outlined,
      title: 'Services, Charges & Invoicing',
      steps: [
        'Open a visit and add service lines for each animal — enter a description and price, or billing by headcount for group services.',
        'Save frequently used services as templates in Settings so you can add them with one tap next time.',
        'Add travel and incidental charges (mileage, tolls, reimbursements) separately from service lines.',
        'Set your default mileage rate in Settings so it\'s pre-filled every time you add a travel charge.',
        'When a visit is complete, generate the invoice PDF, then print or share it directly from the visit.',
      ],
    ),
    _HelpSection(
      icon: Icons.payments_outlined,
      title: 'Getting Paid',
      steps: [
        'A visit has two states: completed (work is done) and paid (payment received) — mark each as it happens.',
        'The dashboard shows earned and projected revenue so you can track what\'s outstanding at a glance.',
        'Use the invoice history screen to find and re-share any past invoice.',
        'Unpaid, past-due visits are highlighted so nothing slips through.',
      ],
    ),
    _HelpSection(
      icon: Icons.photo_camera_outlined,
      title: 'Photos',
      steps: [
        'From a visit, capture photos and tag them to one or more animals using the checkboxes — all animals on the visit are pre-checked by default.',
        'Open an animal\'s detail page to see its full photo history, oldest first, with the elapsed time between shoeings and the visit notes for context.',
        'Use the photo comparison view to place two photos from an animal\'s history side by side and track progress over time.',
        'Add a caption to any photo to remember what it shows.',
      ],
    ),
    _HelpSection(
      icon: Icons.search_outlined,
      title: 'Finding Things',
      steps: [
        'Use the search field in the client picker to find a client quickly by name or address.',
        'The animal list screen shows every animal across all clients in one place.',
        'Last-visit badges on client and animal lists show how long it\'s been since their last appointment.',
        'The today route screen lists today\'s visits in order so you can plan your driving route.',
      ],
    ),
    _HelpSection(
      icon: Icons.backup_outlined,
      title: 'Backups',
      steps: [
        'Go to Settings and tap "Create Backup" to save a complete zip of your data and photos, ready to share or store somewhere safe.',
        'Back up regularly, especially before switching devices or clearing app storage.',
        'Tap "Restore Backup" and choose a backup zip file to restore — this replaces all current data on the device, so make sure you mean to overwrite it.',
        'Use "Export Data" for a CSV export of clients, animals, visits, service lines, and invoice summaries — handy for spreadsheets or accounting software.',
      ],
    ),
    _HelpSection(
      icon: Icons.wifi_off_outlined,
      title: 'Working Offline',
      steps: [
        'FarrierLog stores everything locally on your device — there is no account, cloud sync, or internet connection required.',
        'You can add clients, schedule visits, take photos, and generate invoices anywhere, with or without signal.',
        'Because there\'s no cloud copy, your backups are the only way to move data to a new device or recover from data loss — back up before you need to.',
        'Sharing an invoice, backup, or export uses your device\'s normal share options (email, messaging, cloud drive), which do require a connection at that moment.',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Guide')),
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
                          'Welcome to FarrierLog',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This guide walks through everything FarrierLog can do, '
                    'from adding your first client to backing up your data. '
                    'Tap a section below to expand it.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ..._sections.map((section) => Card(
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
