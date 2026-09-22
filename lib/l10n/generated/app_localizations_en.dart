// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get cancel => 'Cancel';

  @override
  String get add => 'Add';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get update => 'Update';

  @override
  String get view => 'View';

  @override
  String get share => 'Share';

  @override
  String get print => 'Print';

  @override
  String get confirm => 'Confirm';

  @override
  String get requiredField => 'Required';

  @override
  String get generalLabel => 'General';

  @override
  String get groupLabelFallback => 'Group';

  @override
  String groupAnimalCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '× $count animals',
      one: '× 1 animal',
    );
    return '$_temp0';
  }

  @override
  String get noneLabel => 'None';

  @override
  String totalLabel(String amount) {
    return 'Total: $amount';
  }

  @override
  String get navClients => 'Clients';

  @override
  String get navCalendar => 'Calendar';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navInvoices => 'Invoices';

  @override
  String get navAnimals => 'Animals';

  @override
  String get deleteClientTitle => 'Delete Client';

  @override
  String get noContactInfo => 'No contact info';

  @override
  String get noClientsYet => 'No clients yet';

  @override
  String get addFirstClientSubtitle => 'Add your first client to get started';

  @override
  String get addClientButton => 'Add Client';

  @override
  String clientListDeleteMessage(String name) {
    return 'Delete $name? This will also delete all associated visits, animals, and photos.';
  }

  @override
  String get editClientTitle => 'Edit Client';

  @override
  String get addClientTitle => 'Add Client';

  @override
  String get nameLabel => 'Name';

  @override
  String get firstNameLabel => 'First Name';

  @override
  String get lastNameLabel => 'Last Name';

  @override
  String get phoneLabel => 'Phone';

  @override
  String get emailLabel => 'Email';

  @override
  String get addressLabel => 'Address';

  @override
  String get clientNotesLabel => 'Client Notes (private — not on invoice)';

  @override
  String get clientNotesHint =>
      'Gate codes, payment preferences, safety notes...';

  @override
  String get internalNotesLabel => 'Internal Notes (staff only)';

  @override
  String get internalNotesHintClient =>
      'Observations, warnings — never shown to client or on invoice';

  @override
  String get animalsTitle => 'Animals';

  @override
  String get searchAnimalsHint => 'Search by animal or client name...';

  @override
  String animalCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count animals',
      one: '1 animal',
    );
    return '$_temp0';
  }

  @override
  String get noAnimalsYet => 'No animals yet';

  @override
  String noAnimalsMatch(String query) {
    return 'No animals match \"$query\"';
  }

  @override
  String get calendarTitle => 'Calendar';

  @override
  String get appointmentConfirmedSnackbar => 'Appointment confirmed';

  @override
  String get recurringVisitTitle => 'Recurring Visit';

  @override
  String get scheduleNextRecurringVisit => 'Schedule next recurring visit?';

  @override
  String noVisitsOnDate(String date) {
    return 'No visits on $date';
  }

  @override
  String get newAppointmentButton => 'New Appointment';

  @override
  String get dashListTitleClients => 'Clients';

  @override
  String get dashListTitleAnimals => 'Animals';

  @override
  String get dashListTitleUpcoming => 'Upcoming Visits';

  @override
  String get dashListTitlePastDue => 'Past Due Visits';

  @override
  String get dashListTitleOutstanding => 'Outstanding Visits';

  @override
  String get dashListTitlePaid => 'Paid Visits';

  @override
  String get dashEmptyUpcomingTitle => 'No upcoming visits';

  @override
  String get dashEmptyPastDueTitle => 'No past due visits';

  @override
  String get dashEmptyOutstandingTitle => 'No outstanding visits';

  @override
  String get dashEmptyPaidTitle => 'No paid visits yet';

  @override
  String get dashEmptyClientsSubtitle => 'Add clients from the Clients tab.';

  @override
  String get dashEmptyAnimalsSubtitle =>
      'Animals will appear here after they are added to clients.';

  @override
  String get dashEmptyUpcomingSubtitle =>
      'No visits are scheduled in the next 30 days.';

  @override
  String get dashEmptyPastDueSubtitle => 'All visits are marked complete.';

  @override
  String get dashEmptyOutstandingSubtitle =>
      'All completed visits have been paid.';

  @override
  String get dashEmptyPaidSubtitle =>
      'Paid visits will appear here after invoices or visits are marked paid.';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get todaysRouteTitle => 'Today\'s Route';

  @override
  String get todaysRouteSubtitle => 'See all of today\'s stops in order';

  @override
  String get statTotalClients => 'Total Clients';

  @override
  String get statTotalAnimals => 'Total Animals';

  @override
  String get statUpcoming => 'Upcoming';

  @override
  String get statPastDue => 'Past Due';

  @override
  String get statTotalRevenue => 'Total Revenue';

  @override
  String get statOutstanding => 'Outstanding';

  @override
  String get milesDrivenTitle => 'Miles Driven';

  @override
  String get thisMonth => 'This Month';

  @override
  String get thisYear => 'This Year';

  @override
  String get revenueTrendTitle => 'Revenue Trend (12 mo)';

  @override
  String get next7DaysTitle => 'Next 7 Days';

  @override
  String get newVisitLabel => 'New Visit';

  @override
  String get noUpcomingVisitsThisWeek => 'No upcoming visits this week';

  @override
  String get helpTitle => 'Help & Guide';

  @override
  String get welcomeToFarrierLog => 'Welcome to FarrierLog';

  @override
  String get helpIntro =>
      'This guide walks through everything FarrierLog can do, from adding your first client to backing up your data. Tap a section below to expand it.';

  @override
  String get helpSectionGettingStartedTitle => 'Getting Started';

  @override
  String get helpStepGettingStarted1 =>
      'Open Settings and fill in your company name, address, phone, and email — this appears on every invoice you send.';

  @override
  String get helpStepGettingStarted2 =>
      'Pick a color theme and set your preferred currency and distance unit.';

  @override
  String get helpStepGettingStarted3 =>
      'Add your first client from the Clients tab, then add their animals.';

  @override
  String get helpStepGettingStarted4 =>
      'Schedule a visit from the client\'s page or the calendar\'s new appointment button.';

  @override
  String get helpSectionClientsAnimalsTitle => 'Clients & Animals';

  @override
  String get helpStepClientsAnimals1 =>
      'Go to the Clients tab and tap the add button to create a new client with their contact details and address.';

  @override
  String get helpStepClientsAnimals2 =>
      'Open a client\'s page and tap \"Add Animal\" to add each horse or other animal you service for them.';

  @override
  String get helpStepClientsAnimals3 =>
      'Tap a client\'s phone number to call, or long-press it to text.';

  @override
  String get helpStepClientsAnimals4 =>
      'Tap a client\'s address to open it in maps for directions.';

  @override
  String get helpStepClientsAnimals5 =>
      'Use \"Internal Notes\" on a client or animal for private staff notes — these never appear on invoices.';

  @override
  String get helpStepClientsAnimals6 =>
      'Swipe left on a client or animal to delete it. Deleting a client also deletes their animals, visits, and photos.';

  @override
  String get helpSectionSchedulingTitle => 'Scheduling Visits';

  @override
  String get helpStepScheduling1 =>
      'Tap the calendar tab to see all upcoming and past visits — solid markers are confirmed, outlined markers are auto-generated projections.';

  @override
  String get helpStepScheduling2 =>
      'Tap the new appointment button on the calendar to schedule a visit on a specific date.';

  @override
  String get helpStepScheduling3 =>
      'Search for a client by name or address instead of scrolling a long list.';

  @override
  String get helpStepScheduling4 =>
      'Set a recurrence interval (in weeks) on a visit to automatically project the next appointment once you confirm the current one.';

  @override
  String get helpStepScheduling5 =>
      'Confirming an auto-generated visit creates the next projected visit in the chain — future visits are not created all at once.';

  @override
  String get helpSectionInvoicingTitle => 'Services, Charges & Invoicing';

  @override
  String get helpStepInvoicing1 =>
      'Open a visit and add service lines for each animal — enter a description and price, or billing by headcount for group services.';

  @override
  String get helpStepInvoicing2 =>
      'Save frequently used services as templates in Settings so you can add them with one tap next time.';

  @override
  String get helpStepInvoicing3 =>
      'Add travel and incidental charges (mileage, tolls, reimbursements) separately from service lines.';

  @override
  String get helpStepInvoicing4 =>
      'Set your default mileage rate in Settings so it\'s pre-filled every time you add a travel charge.';

  @override
  String get helpStepInvoicing5 =>
      'When a visit is complete, generate the invoice PDF, then print or share it directly from the visit.';

  @override
  String get helpSectionGettingPaidTitle => 'Getting Paid';

  @override
  String get helpStepGettingPaid1 =>
      'A visit has two states: completed (work is done) and paid (payment received) — mark each as it happens.';

  @override
  String get helpStepGettingPaid2 =>
      'The dashboard shows earned and projected revenue so you can track what\'s outstanding at a glance.';

  @override
  String get helpStepGettingPaid3 =>
      'Use the invoice history screen to find and re-share any past invoice.';

  @override
  String get helpStepGettingPaid4 =>
      'Unpaid, past-due visits are highlighted so nothing slips through.';

  @override
  String get helpSectionPhotosTitle => 'Photos';

  @override
  String get helpStepPhotos1 =>
      'From a visit, capture photos and tag them to one or more animals using the checkboxes — all animals on the visit are pre-checked by default.';

  @override
  String get helpStepPhotos2 =>
      'Open an animal\'s detail page to see its full photo history, oldest first, with the elapsed time between shoeings and the visit notes for context.';

  @override
  String get helpStepPhotos3 =>
      'Use the photo comparison view to place two photos from an animal\'s history side by side and track progress over time.';

  @override
  String get helpStepPhotos4 =>
      'Add a caption to any photo to remember what it shows.';

  @override
  String get helpSectionFindingTitle => 'Finding Things';

  @override
  String get helpStepFinding1 =>
      'Use the search field in the client picker to find a client quickly by name or address.';

  @override
  String get helpStepFinding2 =>
      'The animal list screen shows every animal across all clients in one place.';

  @override
  String get helpStepFinding3 =>
      'Last-visit badges on client and animal lists show how long it\'s been since their last appointment.';

  @override
  String get helpStepFinding4 =>
      'The today route screen lists today\'s visits in order so you can plan your driving route.';

  @override
  String get helpSectionBackupsTitle => 'Backups';

  @override
  String get helpStepBackups1 =>
      'Go to Settings and tap \"Create Backup\" to save a complete zip of your data and photos, ready to share or store somewhere safe.';

  @override
  String get helpStepBackups2 =>
      'Back up regularly, especially before switching devices or clearing app storage.';

  @override
  String get helpStepBackups3 =>
      'Tap \"Restore Backup\" and choose a backup zip file to restore — this replaces all current data on the device, so make sure you mean to overwrite it.';

  @override
  String get helpStepBackups4 =>
      'Use \"Export Data\" for a CSV export of clients, animals, visits, service lines, and invoice summaries — handy for spreadsheets or accounting software.';

  @override
  String get helpSectionOfflineTitle => 'Working Offline';

  @override
  String get helpStepOffline1 =>
      'FarrierLog stores everything locally on your device — there is no account, cloud sync, or internet connection required.';

  @override
  String get helpStepOffline2 =>
      'You can add clients, schedule visits, take photos, and generate invoices anywhere, with or without signal.';

  @override
  String get helpStepOffline3 =>
      'Because there\'s no cloud copy, your backups are the only way to move data to a new device or recover from data loss — back up before you need to.';

  @override
  String get helpStepOffline4 =>
      'Sharing an invoice, backup, or export uses your device\'s normal share options (email, messaging, cloud drive), which do require a connection at that moment.';

  @override
  String get skipButton => 'Skip';

  @override
  String get onboardingWelcomeBody =>
      'FarrierLog helps you run your business from your phone — clients, scheduling, invoicing, and photos. Fully offline. No subscriptions.';

  @override
  String get getStartedButton => 'Get Started';

  @override
  String get addBusinessDetailsTitle => 'Add your business details';

  @override
  String get addBusinessDetailsBody =>
      'These appear on your invoices. You can always change them later in Settings.';

  @override
  String get businessNameLabel => 'Business Name';

  @override
  String get emailOptionalLabel => 'Email (optional)';

  @override
  String get continueButton => 'Continue';

  @override
  String get skipForNow => 'Skip for now';

  @override
  String get allSetTitle => 'You\'re all set!';

  @override
  String get addFirstClientBody => 'Add your first client to get started.';

  @override
  String get addFirstClientButton => 'Add First Client';

  @override
  String get illDoItLater => 'I\'ll do it later';

  @override
  String get invoiceHistoryTitle => 'Invoice History';

  @override
  String get clearFiltersTooltip => 'Clear filters';

  @override
  String get exportCsvTooltip => 'Export CSV';

  @override
  String exportFailedSnackbar(String error) {
    return 'Export failed: $error';
  }

  @override
  String get noPdfFoundSnackbar => 'No PDF file found for this invoice';

  @override
  String pdfNotFoundSnackbar(String path) {
    return 'PDF file not found: $path';
  }

  @override
  String get shareInvoiceOnlyTitle => 'Share Invoice Only (no photos)';

  @override
  String get shareInvoiceOnlySubtitle =>
      'Clean invoice — ideal for clients and accounting';

  @override
  String get shareInvoicePhotosTitle => 'Share Invoice + Photos';

  @override
  String get shareInvoicePhotosSubtitle =>
      'Full document with photo documentation';

  @override
  String errorSharingInvoiceSnackbar(String error) {
    return 'Error sharing invoice: $error';
  }

  @override
  String fromDateLabel(String date) {
    return 'From: $date';
  }

  @override
  String get fromDatePlaceholder => 'From date';

  @override
  String toDateLabel(String date) {
    return 'To: $date';
  }

  @override
  String get toDatePlaceholder => 'To date';

  @override
  String get clientDropdownLabel => 'Client';

  @override
  String get allClientsOption => 'All clients';

  @override
  String invoiceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count invoices',
      one: '1 invoice',
    );
    return '$_temp0';
  }

  @override
  String get noInvoicesFound => 'No invoices found';

  @override
  String get paidLabel => 'Paid';

  @override
  String get unpaidLabel => 'Unpaid';

  @override
  String invoiceNumberSubject(String number) {
    return 'Invoice $number';
  }

  @override
  String get exportCsvShareSubject => 'Invoice History Export';

  @override
  String get exportCsvShareText => 'Invoice history CSV export';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get helpGuideTitle => 'Help & Guide';

  @override
  String get helpGuideSubtitle => 'How to use FarrierLog';

  @override
  String get colorLabel => 'Color';

  @override
  String get companyInfoTitle => 'Company Information';

  @override
  String get appearsOnInvoices => 'Appears on invoices';

  @override
  String get uploadLogoButton => 'Upload Logo';

  @override
  String get companyNameLabel => 'Company Name';

  @override
  String get currencyUnitsTitle => 'Currency & Units';

  @override
  String get currencyLabel => 'Currency';

  @override
  String get currencyUsd => '\$ — US Dollar';

  @override
  String get currencyEur => '€ — Euro';

  @override
  String get currencyGbp => '£ — Pound';

  @override
  String get currencyJpy => '¥ — Yen / Yuan';

  @override
  String get currencyInr => '₹ — Rupee';

  @override
  String get currencyCad => 'CAD\$ — Canadian Dollar';

  @override
  String get currencyAud => 'AUD\$ — Australian Dollar';

  @override
  String get currencyNzd => 'NZD\$ — New Zealand Dollar';

  @override
  String get currencyZar => 'R — South African Rand';

  @override
  String get currencyCustomOption => 'Custom...';

  @override
  String get customCurrencySymbolLabel => 'Custom currency symbol';

  @override
  String get customCurrencySymbolHint => 'e.g. CHF, kr, RM';

  @override
  String get distanceUnitLabel => 'Distance unit';

  @override
  String get distanceMiles => 'Miles (mi)';

  @override
  String get distanceKm => 'Kilometres (km)';

  @override
  String get mileageTitle => 'Mileage';

  @override
  String get mileageSubtitle =>
      'Default rate used when adding mileage or transport charges';

  @override
  String mileageRateLabel(String unit) {
    return 'Rate (per $unit)';
  }

  @override
  String get startWeekMondaySwitch => 'Start calendar week on Monday';

  @override
  String get reminderMessageTitle => 'Reminder Message';

  @override
  String get reminderTemplateLabel => 'SMS Reminder Template';

  @override
  String reminderTemplateHelp(String token1, String token2, String token3) {
    return 'Use \"$token1\", \"$token2\", and \"$token3\" — these fill in automatically.';
  }

  @override
  String get saveSettingsButton => 'Save Settings';

  @override
  String get settingsSavedSnackbar => 'Settings saved!';

  @override
  String get serviceTemplatesTitle => 'Service Templates';

  @override
  String get addTemplateTooltip => 'Add template';

  @override
  String get noSavedTemplates => 'No saved templates yet';

  @override
  String get exportDataButton => 'Export Data';

  @override
  String get exportingButton => 'Exporting...';

  @override
  String backupFailedSnackbar(String error) {
    return 'Backup failed: $error';
  }

  @override
  String get createBackupButton => 'Create Backup';

  @override
  String get creatingBackupButton => 'Creating Backup...';

  @override
  String get restoreBackupButton => 'Restore Backup';

  @override
  String get restoringButton => 'Restoring...';

  @override
  String get restoreBackupTitle => 'Restore Backup?';

  @override
  String get restoreBackupMessage =>
      'This will replace all current FarrierLog data on this device.';

  @override
  String get restoreButton => 'Restore';

  @override
  String restoreFailedSnackbar(String error) {
    return 'Restore failed: $error';
  }

  @override
  String get backupRestoredSnackbar => 'Backup restored.';

  @override
  String get newServiceTemplateTitle => 'New Service Template';

  @override
  String get serviceLabel => 'Service';

  @override
  String get priceLabel => 'Price';

  @override
  String get showWelcomeGuideAgain => 'Show welcome guide again';

  @override
  String get languageLabel => 'Language';

  @override
  String get languageSystemDefault => 'System default';

  @override
  String get remindTomorrowTooltip => 'Remind Tomorrow\'s Clients';

  @override
  String get noAddressesSnackbar => 'No addresses on file for today\'s visits';

  @override
  String get noVisitsWithPhoneSnackbar =>
      'No visits with phone numbers tomorrow';

  @override
  String get tomorrowsRemindersTitle => 'Tomorrow\'s Reminders';

  @override
  String get sendButton => 'Send';

  @override
  String get noVisitsScheduledToday => 'No visits scheduled today';

  @override
  String get enjoyDayOffSubtitle => 'Enjoy the day off, or schedule a visit.';

  @override
  String visitsTodayCount(int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total visits today',
      one: '1 visit today',
    );
    return '$_temp0';
  }

  @override
  String missingAddressCount(int missing) {
    String _temp0 = intl.Intl.pluralLogic(
      missing,
      locale: localeName,
      other: '$missing missing addresses',
      one: '1 missing address',
    );
    return '$_temp0';
  }

  @override
  String get navigateTooltip => 'Navigate';

  @override
  String get noAddressOnFile => 'No address on file';

  @override
  String get openFullRouteButton => 'Open Full Route';

  @override
  String get photoComparisonTitle => 'Photo Comparison';

  @override
  String get swapPhotosTooltip => 'Swap photos';

  @override
  String elapsedBetweenVisits(String elapsed) {
    return '$elapsed between these visits';
  }

  @override
  String elapsedDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String elapsedWeeks(int weeks) {
    String _temp0 = intl.Intl.pluralLogic(
      weeks,
      locale: localeName,
      other: '$weeks weeks',
      one: '1 week',
    );
    return '$_temp0';
  }

  @override
  String get beforeLabel => 'BEFORE';

  @override
  String get afterLabel => 'AFTER';

  @override
  String get animalTitle => 'Animal';

  @override
  String get progressReportTooltip => 'Progress Report';

  @override
  String progressReportSubject(String name) {
    return '$name — Progress Report';
  }

  @override
  String get photoDefaultTitle => 'Photo';

  @override
  String get ownerLabel => 'Owner';

  @override
  String get noVisitsRecordedForAnimal =>
      'No visits recorded for this animal yet.';

  @override
  String get noPhotosForAnimal => 'No photos tagged to this animal yet.';

  @override
  String get compareButton => 'Compare';

  @override
  String get openVisitButton => 'Open visit';

  @override
  String daysSinceLastVisit(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days since last visit',
      one: '1 day since last visit',
    );
    return '$_temp0';
  }

  @override
  String weeksSinceLastShoeing(int weeks) {
    String _temp0 = intl.Intl.pluralLogic(
      weeks,
      locale: localeName,
      other: '$weeks weeks since last shoeing',
      one: '1 week since last shoeing',
    );
    return '$_temp0';
  }

  @override
  String visitHistoryTitle(int count) {
    return 'Visit History ($count)';
  }

  @override
  String get photoHistoryTitle => 'Photo History';

  @override
  String get visitTitle => 'Visit';

  @override
  String get deleteServiceLineTitle => 'Delete Service Line';

  @override
  String get deleteChargeTitle => 'Delete Charge';

  @override
  String removeQuotedItem(String name) {
    return 'Remove \"$name\"?';
  }

  @override
  String get takeAPhoto => 'Take a photo';

  @override
  String get chooseFromCameraRoll => 'Choose from camera roll';

  @override
  String get photoDetailsTitle => 'Photo Details';

  @override
  String get tagToAnimalsLabel => 'Tag to animal(s):';

  @override
  String get captionLabel => 'Caption';

  @override
  String get includeOnInvoiceSwitch => 'Include on invoice';

  @override
  String addPhotosCountTitle(int count) {
    return 'Add $count Photos';
  }

  @override
  String photosSelectedFromGallery(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count photos selected from gallery',
      one: '1 photo selected from gallery',
    );
    return '$_temp0';
  }

  @override
  String get tagAllToAnimalsLabel => 'Tag all to animal(s):';

  @override
  String get captionAllPhotosLabel => 'Caption (all photos)';

  @override
  String get saveAllButton => 'Save All';

  @override
  String get deletePhotoTitle => 'Delete Photo';

  @override
  String get removePhotoMessage => 'Remove this photo?';

  @override
  String get viewShareInvoiceTitle => 'View / Share Invoice';

  @override
  String get regenerateInvoiceTitle => 'Regenerate Invoice';

  @override
  String get regenerateInvoiceSubtitle =>
      'Delete current and generate a new one';

  @override
  String invoiceSubjectFor(String name) {
    return 'Invoice for $name';
  }

  @override
  String get shareInvoicePdfTitle => 'Share Invoice (PDF)';

  @override
  String get shareInvoicePdfSubtitle =>
      'Send via any app - Gmail, WhatsApp, etc.';

  @override
  String get printInvoiceTitle => 'Print Invoice';

  @override
  String errorGeneratingInvoiceSnackbar(String error) {
    return 'Error generating invoice: $error';
  }

  @override
  String get regenerateInvoiceConfirmTitle => 'Regenerate Invoice?';

  @override
  String get regenerateInvoiceConfirmMessage =>
      'This will delete the current invoice and generate a new one based on current service lines and charges.';

  @override
  String get regenerateButton => 'Regenerate';

  @override
  String invoicePdfNotFoundSnackbar(String name) {
    return 'Invoice PDF not found: $name';
  }

  @override
  String get deleteVisitTitle => 'Delete Visit';

  @override
  String get deleteVisitConfirmMessage =>
      'Are you sure you want to delete this visit?';

  @override
  String get couldNotOpenMapsSnackbar => 'Could not open Google Maps';

  @override
  String calendarEventTitle(String name) {
    return 'Farrier - $name';
  }

  @override
  String get calendarEventDefaultDescription => 'Farrier visit';

  @override
  String get calendarEventNotAddedSnackbar =>
      'Calendar event could not be added.';

  @override
  String calendarEventErrorSnackbar(String error) {
    return 'Calendar event could not be added: $error';
  }

  @override
  String get noPhoneForClientSnackbar =>
      'No phone number is saved for this client.';

  @override
  String get couldNotOpenSmsSnackbar => 'Could not open the SMS app.';

  @override
  String get noSavedNotesSnackbar =>
      'No saved notes found for this client or their animals.';

  @override
  String get insertFromNotesTitle => 'Insert from Notes';

  @override
  String clientNotesHeader(String name) {
    return '📋 Client — $name';
  }

  @override
  String animalNotesHeader(String name) {
    return '🐾 $name';
  }

  @override
  String get insertButton => '+ Insert';

  @override
  String get noAddressSaved => 'No address saved';

  @override
  String get appointmentAddressTitle => 'Appointment Address';

  @override
  String get openInGoogleMaps => 'Open in Google Maps';

  @override
  String get editVisitMenuItem => 'Edit Visit';

  @override
  String get deleteVisitMenuItem => 'Delete Visit';

  @override
  String invoiceNotesPrefix(String notes) {
    return 'Invoice Notes: $notes';
  }

  @override
  String get addToPhoneCalendarButton => 'Add to Phone Calendar';

  @override
  String get sendReminderButton => 'Send Reminder';

  @override
  String get confirmAppointmentButton => 'Confirm this appointment';

  @override
  String get visitCompletedSwitch => 'Visit completed';

  @override
  String get paymentReceivedSwitch => 'Payment received';

  @override
  String animalsCountTitle(int count) {
    return 'Animals ($count)';
  }

  @override
  String get noAnimalsForVisit => 'No animals selected for this visit';

  @override
  String get billingTitle => 'Billing';

  @override
  String get addServiceLineLabel => 'Add Service Line';

  @override
  String get noServiceLinesYet => 'No service lines yet';

  @override
  String get travelIncidentalsTitle => 'Travel & Incidentals';

  @override
  String get addChargeLabel => 'Add Charge';

  @override
  String get noChargesYet => 'No travel or incidental charges yet';

  @override
  String servicesAndTravelSummary(String services, String travel) {
    return 'Services: $services · Travel & Incidentals: $travel';
  }

  @override
  String get totalLabelPlain => 'Total';

  @override
  String get invoiceNotesLabel => 'Invoice Notes';

  @override
  String get invoiceNotesHint => 'Printed on invoice...';

  @override
  String get insertFromSavedNotesTooltip => 'Insert from saved notes';

  @override
  String get generateInvoiceButton => 'Generate Invoice';

  @override
  String get createInvoiceButton => 'Create Invoice';

  @override
  String get addServiceLinesBeforeInvoice =>
      'Add service lines or charges before creating an invoice';

  @override
  String get paidInFull => 'Paid in Full';

  @override
  String photosCountTitle(int count) {
    return 'Photos ($count)';
  }

  @override
  String get addPhotoLabel => 'Add Photo';

  @override
  String get noPhotosYet => 'No photos yet';

  @override
  String get generateInvoiceTooltip => 'Generate Invoice';

  @override
  String get regenerateInvoiceTooltip => 'Regenerate Invoice';

  @override
  String get editVisitTitle => 'Edit Visit';

  @override
  String get newVisitTitle => 'New Visit';

  @override
  String get pleaseSelectClient => 'Please select a client';

  @override
  String get searchForClientPlaceholder => 'Search for a client...';

  @override
  String get dateLabel => 'Date';

  @override
  String get timeLabel => 'Time';

  @override
  String get recurringLabel => 'Recurring';

  @override
  String get recurrenceEvery4 => 'Every 4 weeks';

  @override
  String get recurrenceEvery6 => 'Every 6 weeks';

  @override
  String get recurrenceEvery8 => 'Every 8 weeks';

  @override
  String get recurrenceEvery10 => 'Every 10 weeks';

  @override
  String get recurrenceCustom => 'Custom weeks';

  @override
  String get customWeeksLabel => 'Custom weeks';

  @override
  String get customWeeksMustBeGreaterThanZero =>
      'Custom weeks must be greater than 0';

  @override
  String get selectAnimalsLabel => 'Select Animals';

  @override
  String get noAnimalsForClient => 'No animals for this client';

  @override
  String get groupServiceHint =>
      'Don\'t need to track individual animals for this stop? Add a group service line from the visit screen after saving.';

  @override
  String get invoiceNotesHintNewVisit =>
      'Printed on invoice — services, corrections, special notes...';

  @override
  String get updateVisitButton => 'Update Visit';

  @override
  String get saveVisitButton => 'Save Visit';

  @override
  String get searchClientsHint => 'Search clients...';

  @override
  String get noClientsFound => 'No clients found';

  @override
  String clientDetailDeleteMessage(String name) {
    return 'Are you sure you want to delete $name? This will also delete all associated visits, animals, and photos.';
  }

  @override
  String get deleteAnimalTitle => 'Delete Animal';

  @override
  String deleteAnimalConfirmMessage(String name) {
    return 'Are you sure you want to delete $name?';
  }

  @override
  String deleteVisitConfirmMessageWithDate(String date) {
    return 'Delete the visit on $date?';
  }

  @override
  String get scheduleVisitButton => 'Schedule Visit';

  @override
  String get tapToCallLongPressText => 'Tap to call • Long-press to text';

  @override
  String get tapToEmail => 'Tap to email';

  @override
  String get openInMaps => 'Open in maps';

  @override
  String notesLabel(String notes) {
    return 'Notes: $notes';
  }

  @override
  String get privateStaffNotesTitle => 'Private Staff Notes';

  @override
  String get addAnimalLabel => 'Add Animal';

  @override
  String get noAnimalsAddedYet => 'No animals added yet';

  @override
  String visitsCountHeader(int count) {
    return 'Visits ($count)';
  }

  @override
  String get noVisitsYet => 'No visits yet';

  @override
  String get editAnimalTitle => 'Edit Animal';

  @override
  String get newAnimalTitle => 'New Animal';

  @override
  String get speciesLabel => 'Species';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get animalNotesLabel => 'Animal Notes (private)';

  @override
  String get animalNotesHint => 'Health history, behaviour, handling notes...';

  @override
  String get internalNotesHintAnimal =>
      'Private staff observations — never on invoice';

  @override
  String get editServiceLineTitle => 'Edit Service Line';

  @override
  String get addServiceLineTitle => 'Add Service Line';

  @override
  String get savedTemplatesLabel => 'Saved Templates';

  @override
  String get singleAnimalOption => 'Single Animal';

  @override
  String get groupHeadcountOption => 'Group / Headcount';

  @override
  String get animalDropdownLabel => 'Animal';

  @override
  String get groupDescriptionLabel => 'Group description';

  @override
  String get groupDescriptionHint => 'e.g. Back pasture herd, Smith Ranch';

  @override
  String get numberOfAnimalsLabel => 'Number of animals';

  @override
  String get enterWholeNumber => 'Enter a whole number of 1 or more';

  @override
  String get pricePerAnimalLabel => 'Price per animal';

  @override
  String get saveAsTemplateButton => 'Save as template';

  @override
  String get enterDescriptionFirstSnackbar => 'Enter a description first';

  @override
  String templateSavedSnackbar(String description) {
    return '\"$description\" saved as template';
  }

  @override
  String get editChargeTitle => 'Edit Charge';

  @override
  String get addChargeTitle => 'Add Charge';

  @override
  String get typeLabel => 'Type';

  @override
  String distanceLabelWithUnit(String unit) {
    return 'Distance ($unit)';
  }

  @override
  String get enterNumberZeroOrMore => 'Enter a number 0 or more';

  @override
  String ratePerUnitLabel(String unit) {
    return 'Rate per $unit';
  }

  @override
  String get amountLabel => 'Amount';

  @override
  String get invalidNumber => 'Invalid number';

  @override
  String get chargeTypeMileage => 'Mileage';

  @override
  String get chargeTypeTolls => 'Tolls';

  @override
  String get chargeTypeReimbursement => 'Reimbursement';

  @override
  String get chargeTypeTransport => 'Transport';

  @override
  String get chargeTypeOther => 'Other';

  @override
  String get statusProjected => 'Projected';

  @override
  String get statusPaid => 'Paid';

  @override
  String get statusOverdue => 'Overdue';

  @override
  String get statusToday => 'Today';

  @override
  String get statusUpcoming => 'Upcoming';

  @override
  String get badgeScheduled => 'Scheduled';

  @override
  String get badgeNoVisitsYet => 'No visits yet';

  @override
  String badgeWeeksAgo(int weeks) {
    String _temp0 = intl.Intl.pluralLogic(
      weeks,
      locale: localeName,
      other: '$weeks wk ago',
      one: '1 wk ago',
    );
    return '$_temp0';
  }
}
