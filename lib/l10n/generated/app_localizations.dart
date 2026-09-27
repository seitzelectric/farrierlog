import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
  ];

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @print.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get print;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredField;

  /// No description provided for @generalLabel.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get generalLabel;

  /// No description provided for @groupLabelFallback.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get groupLabelFallback;

  /// No description provided for @groupAnimalCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{× 1 animal} other{× {count} animals}}'**
  String groupAnimalCount(int count);

  /// No description provided for @noneLabel.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get noneLabel;

  /// No description provided for @totalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total: {amount}'**
  String totalLabel(String amount);

  /// No description provided for @navClients.
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get navClients;

  /// No description provided for @navCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get navCalendar;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navInvoices.
  ///
  /// In en, this message translates to:
  /// **'Invoices'**
  String get navInvoices;

  /// No description provided for @navAnimals.
  ///
  /// In en, this message translates to:
  /// **'Animals'**
  String get navAnimals;

  /// No description provided for @deleteClientTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Client'**
  String get deleteClientTitle;

  /// No description provided for @noContactInfo.
  ///
  /// In en, this message translates to:
  /// **'No contact info'**
  String get noContactInfo;

  /// No description provided for @noClientsYet.
  ///
  /// In en, this message translates to:
  /// **'No clients yet'**
  String get noClientsYet;

  /// No description provided for @addFirstClientSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add your first client to get started'**
  String get addFirstClientSubtitle;

  /// No description provided for @addClientButton.
  ///
  /// In en, this message translates to:
  /// **'Add Client'**
  String get addClientButton;

  /// No description provided for @clientListDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}? This will also delete all associated visits, animals, and photos.'**
  String clientListDeleteMessage(String name);

  /// No description provided for @editClientTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Client'**
  String get editClientTitle;

  /// No description provided for @addClientTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Client'**
  String get addClientTitle;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @firstNameLabel.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstNameLabel;

  /// No description provided for @lastNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastNameLabel;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @addressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressLabel;

  /// No description provided for @clientNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Client Notes (private — not on invoice)'**
  String get clientNotesLabel;

  /// No description provided for @clientNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Gate codes, payment preferences, safety notes...'**
  String get clientNotesHint;

  /// No description provided for @internalNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Internal Notes (staff only)'**
  String get internalNotesLabel;

  /// No description provided for @internalNotesHintClient.
  ///
  /// In en, this message translates to:
  /// **'Observations, warnings — never shown to client or on invoice'**
  String get internalNotesHintClient;

  /// No description provided for @animalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Animals'**
  String get animalsTitle;

  /// No description provided for @searchAnimalsHint.
  ///
  /// In en, this message translates to:
  /// **'Search by animal or client name...'**
  String get searchAnimalsHint;

  /// No description provided for @animalCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 animal} other{{count} animals}}'**
  String animalCount(int count);

  /// No description provided for @noAnimalsYet.
  ///
  /// In en, this message translates to:
  /// **'No animals yet'**
  String get noAnimalsYet;

  /// No description provided for @noAnimalsMatch.
  ///
  /// In en, this message translates to:
  /// **'No animals match \"{query}\"'**
  String noAnimalsMatch(String query);

  /// No description provided for @calendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendarTitle;

  /// No description provided for @appointmentConfirmedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Appointment confirmed'**
  String get appointmentConfirmedSnackbar;

  /// No description provided for @recurringVisitTitle.
  ///
  /// In en, this message translates to:
  /// **'Recurring Visit'**
  String get recurringVisitTitle;

  /// No description provided for @scheduleNextRecurringVisit.
  ///
  /// In en, this message translates to:
  /// **'Schedule next recurring visit?'**
  String get scheduleNextRecurringVisit;

  /// No description provided for @noVisitsOnDate.
  ///
  /// In en, this message translates to:
  /// **'No visits on {date}'**
  String noVisitsOnDate(String date);

  /// No description provided for @newAppointmentButton.
  ///
  /// In en, this message translates to:
  /// **'New Appointment'**
  String get newAppointmentButton;

  /// No description provided for @dashListTitleClients.
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get dashListTitleClients;

  /// No description provided for @dashListTitleAnimals.
  ///
  /// In en, this message translates to:
  /// **'Animals'**
  String get dashListTitleAnimals;

  /// No description provided for @dashListTitleUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Visits'**
  String get dashListTitleUpcoming;

  /// No description provided for @dashListTitlePastDue.
  ///
  /// In en, this message translates to:
  /// **'Past Due Visits'**
  String get dashListTitlePastDue;

  /// No description provided for @dashListTitleOutstanding.
  ///
  /// In en, this message translates to:
  /// **'Outstanding Visits'**
  String get dashListTitleOutstanding;

  /// No description provided for @dashListTitlePaid.
  ///
  /// In en, this message translates to:
  /// **'Paid Visits'**
  String get dashListTitlePaid;

  /// No description provided for @dashEmptyUpcomingTitle.
  ///
  /// In en, this message translates to:
  /// **'No upcoming visits'**
  String get dashEmptyUpcomingTitle;

  /// No description provided for @dashEmptyPastDueTitle.
  ///
  /// In en, this message translates to:
  /// **'No past due visits'**
  String get dashEmptyPastDueTitle;

  /// No description provided for @dashEmptyOutstandingTitle.
  ///
  /// In en, this message translates to:
  /// **'No outstanding visits'**
  String get dashEmptyOutstandingTitle;

  /// No description provided for @dashEmptyPaidTitle.
  ///
  /// In en, this message translates to:
  /// **'No paid visits yet'**
  String get dashEmptyPaidTitle;

  /// No description provided for @dashEmptyClientsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add clients from the Clients tab.'**
  String get dashEmptyClientsSubtitle;

  /// No description provided for @dashEmptyAnimalsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Animals will appear here after they are added to clients.'**
  String get dashEmptyAnimalsSubtitle;

  /// No description provided for @dashEmptyUpcomingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'No visits are scheduled in the next 30 days.'**
  String get dashEmptyUpcomingSubtitle;

  /// No description provided for @dashEmptyPastDueSubtitle.
  ///
  /// In en, this message translates to:
  /// **'All visits are marked complete.'**
  String get dashEmptyPastDueSubtitle;

  /// No description provided for @dashEmptyOutstandingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'All completed visits have been paid.'**
  String get dashEmptyOutstandingSubtitle;

  /// No description provided for @dashEmptyPaidSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Paid visits will appear here after invoices or visits are marked paid.'**
  String get dashEmptyPaidSubtitle;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// No description provided for @todaysRouteTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Route'**
  String get todaysRouteTitle;

  /// No description provided for @todaysRouteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'See all of today\'s stops in order'**
  String get todaysRouteSubtitle;

  /// No description provided for @statTotalClients.
  ///
  /// In en, this message translates to:
  /// **'Total Clients'**
  String get statTotalClients;

  /// No description provided for @statTotalAnimals.
  ///
  /// In en, this message translates to:
  /// **'Total Animals'**
  String get statTotalAnimals;

  /// No description provided for @statUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get statUpcoming;

  /// No description provided for @statPastDue.
  ///
  /// In en, this message translates to:
  /// **'Past Due'**
  String get statPastDue;

  /// No description provided for @statTotalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get statTotalRevenue;

  /// No description provided for @statOutstanding.
  ///
  /// In en, this message translates to:
  /// **'Outstanding'**
  String get statOutstanding;

  /// No description provided for @milesDrivenTitle.
  ///
  /// In en, this message translates to:
  /// **'Miles Driven'**
  String get milesDrivenTitle;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @thisYear.
  ///
  /// In en, this message translates to:
  /// **'This Year'**
  String get thisYear;

  /// No description provided for @revenueTrendTitle.
  ///
  /// In en, this message translates to:
  /// **'Revenue Trend (12 mo)'**
  String get revenueTrendTitle;

  /// No description provided for @next7DaysTitle.
  ///
  /// In en, this message translates to:
  /// **'Next 7 Days'**
  String get next7DaysTitle;

  /// No description provided for @newVisitLabel.
  ///
  /// In en, this message translates to:
  /// **'New Visit'**
  String get newVisitLabel;

  /// No description provided for @noUpcomingVisitsThisWeek.
  ///
  /// In en, this message translates to:
  /// **'No upcoming visits this week'**
  String get noUpcomingVisitsThisWeek;

  /// No description provided for @helpTitle.
  ///
  /// In en, this message translates to:
  /// **'Help & Guide'**
  String get helpTitle;

  /// No description provided for @welcomeToFarrierLog.
  ///
  /// In en, this message translates to:
  /// **'Welcome to FarrierLog'**
  String get welcomeToFarrierLog;

  /// No description provided for @helpIntro.
  ///
  /// In en, this message translates to:
  /// **'This guide walks through everything FarrierLog can do, from adding your first client to backing up your data. Tap a section below to expand it.'**
  String get helpIntro;

  /// No description provided for @helpSectionGettingStartedTitle.
  ///
  /// In en, this message translates to:
  /// **'Getting Started'**
  String get helpSectionGettingStartedTitle;

  /// No description provided for @helpStepGettingStarted1.
  ///
  /// In en, this message translates to:
  /// **'Open Settings and fill in your company name, address, phone, and email — this appears on every invoice you send.'**
  String get helpStepGettingStarted1;

  /// No description provided for @helpStepGettingStarted2.
  ///
  /// In en, this message translates to:
  /// **'Pick a color theme and set your preferred currency and distance unit.'**
  String get helpStepGettingStarted2;

  /// No description provided for @helpStepGettingStarted3.
  ///
  /// In en, this message translates to:
  /// **'Add your first client from the Clients tab, then add their animals.'**
  String get helpStepGettingStarted3;

  /// No description provided for @helpStepGettingStarted4.
  ///
  /// In en, this message translates to:
  /// **'Schedule a visit from the client\'s page or the calendar\'s new appointment button.'**
  String get helpStepGettingStarted4;

  /// No description provided for @helpSectionClientsAnimalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Clients & Animals'**
  String get helpSectionClientsAnimalsTitle;

  /// No description provided for @helpStepClientsAnimals1.
  ///
  /// In en, this message translates to:
  /// **'Go to the Clients tab and tap the add button to create a new client with their contact details and address.'**
  String get helpStepClientsAnimals1;

  /// No description provided for @helpStepClientsAnimals2.
  ///
  /// In en, this message translates to:
  /// **'Open a client\'s page and tap \"Add Animal\" to add each horse or other animal you service for them.'**
  String get helpStepClientsAnimals2;

  /// No description provided for @helpStepClientsAnimals3.
  ///
  /// In en, this message translates to:
  /// **'Tap a client\'s phone number to call, or long-press it to text.'**
  String get helpStepClientsAnimals3;

  /// No description provided for @helpStepClientsAnimals4.
  ///
  /// In en, this message translates to:
  /// **'Tap a client\'s address to open it in maps for directions.'**
  String get helpStepClientsAnimals4;

  /// No description provided for @helpStepClientsAnimals5.
  ///
  /// In en, this message translates to:
  /// **'Use \"Internal Notes\" on a client or animal for private staff notes — these never appear on invoices.'**
  String get helpStepClientsAnimals5;

  /// No description provided for @helpStepClientsAnimals6.
  ///
  /// In en, this message translates to:
  /// **'Swipe left on a client or animal to delete it. Deleting a client also deletes their animals, visits, and photos.'**
  String get helpStepClientsAnimals6;

  /// No description provided for @helpSectionSchedulingTitle.
  ///
  /// In en, this message translates to:
  /// **'Scheduling Visits'**
  String get helpSectionSchedulingTitle;

  /// No description provided for @helpStepScheduling1.
  ///
  /// In en, this message translates to:
  /// **'Tap the calendar tab to see all upcoming and past visits — solid markers are confirmed, outlined markers are auto-generated projections.'**
  String get helpStepScheduling1;

  /// No description provided for @helpStepScheduling2.
  ///
  /// In en, this message translates to:
  /// **'Tap the new appointment button on the calendar to schedule a visit on a specific date.'**
  String get helpStepScheduling2;

  /// No description provided for @helpStepScheduling3.
  ///
  /// In en, this message translates to:
  /// **'Search for a client by name or address instead of scrolling a long list.'**
  String get helpStepScheduling3;

  /// No description provided for @helpStepScheduling4.
  ///
  /// In en, this message translates to:
  /// **'Set a recurrence interval (in weeks) on a visit to automatically project the next appointment once you confirm the current one.'**
  String get helpStepScheduling4;

  /// No description provided for @helpStepScheduling5.
  ///
  /// In en, this message translates to:
  /// **'Confirming an auto-generated visit creates the next projected visit in the chain — future visits are not created all at once.'**
  String get helpStepScheduling5;

  /// No description provided for @helpSectionInvoicingTitle.
  ///
  /// In en, this message translates to:
  /// **'Services, Charges & Invoicing'**
  String get helpSectionInvoicingTitle;

  /// No description provided for @helpStepInvoicing1.
  ///
  /// In en, this message translates to:
  /// **'Open a visit and add service lines for each animal — enter a description and price, or billing by headcount for group services.'**
  String get helpStepInvoicing1;

  /// No description provided for @helpStepInvoicing2.
  ///
  /// In en, this message translates to:
  /// **'Save frequently used services as templates in Settings so you can add them with one tap next time.'**
  String get helpStepInvoicing2;

  /// No description provided for @helpStepInvoicing3.
  ///
  /// In en, this message translates to:
  /// **'Add travel and incidental charges (mileage, tolls, reimbursements) separately from service lines.'**
  String get helpStepInvoicing3;

  /// No description provided for @helpStepInvoicing4.
  ///
  /// In en, this message translates to:
  /// **'Set your default mileage rate in Settings so it\'s pre-filled every time you add a travel charge.'**
  String get helpStepInvoicing4;

  /// No description provided for @helpStepInvoicing5.
  ///
  /// In en, this message translates to:
  /// **'When a visit is complete, generate the invoice PDF, then print or share it directly from the visit.'**
  String get helpStepInvoicing5;

  /// No description provided for @helpSectionGettingPaidTitle.
  ///
  /// In en, this message translates to:
  /// **'Getting Paid'**
  String get helpSectionGettingPaidTitle;

  /// No description provided for @helpStepGettingPaid1.
  ///
  /// In en, this message translates to:
  /// **'A visit has two states: completed (work is done) and paid (payment received) — mark each as it happens.'**
  String get helpStepGettingPaid1;

  /// No description provided for @helpStepGettingPaid2.
  ///
  /// In en, this message translates to:
  /// **'The dashboard shows earned and projected revenue so you can track what\'s outstanding at a glance.'**
  String get helpStepGettingPaid2;

  /// No description provided for @helpStepGettingPaid3.
  ///
  /// In en, this message translates to:
  /// **'Use the invoice history screen to find and re-share any past invoice.'**
  String get helpStepGettingPaid3;

  /// No description provided for @helpStepGettingPaid4.
  ///
  /// In en, this message translates to:
  /// **'Unpaid, past-due visits are highlighted so nothing slips through.'**
  String get helpStepGettingPaid4;

  /// No description provided for @helpSectionPhotosTitle.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get helpSectionPhotosTitle;

  /// No description provided for @helpStepPhotos1.
  ///
  /// In en, this message translates to:
  /// **'From a visit, capture photos and tag them to one or more animals using the checkboxes — all animals on the visit are pre-checked by default.'**
  String get helpStepPhotos1;

  /// No description provided for @helpStepPhotos2.
  ///
  /// In en, this message translates to:
  /// **'Open an animal\'s detail page to see its full photo history, oldest first, with the elapsed time between shoeings and the visit notes for context.'**
  String get helpStepPhotos2;

  /// No description provided for @helpStepPhotos3.
  ///
  /// In en, this message translates to:
  /// **'Use the photo comparison view to place two photos from an animal\'s history side by side and track progress over time.'**
  String get helpStepPhotos3;

  /// No description provided for @helpStepPhotos4.
  ///
  /// In en, this message translates to:
  /// **'Add a caption to any photo to remember what it shows.'**
  String get helpStepPhotos4;

  /// No description provided for @helpSectionFindingTitle.
  ///
  /// In en, this message translates to:
  /// **'Finding Things'**
  String get helpSectionFindingTitle;

  /// No description provided for @helpStepFinding1.
  ///
  /// In en, this message translates to:
  /// **'Use the search field in the client picker to find a client quickly by name or address.'**
  String get helpStepFinding1;

  /// No description provided for @helpStepFinding2.
  ///
  /// In en, this message translates to:
  /// **'The animal list screen shows every animal across all clients in one place.'**
  String get helpStepFinding2;

  /// No description provided for @helpStepFinding3.
  ///
  /// In en, this message translates to:
  /// **'Last-visit badges on client and animal lists show how long it\'s been since their last appointment.'**
  String get helpStepFinding3;

  /// No description provided for @helpStepFinding4.
  ///
  /// In en, this message translates to:
  /// **'The today route screen lists today\'s visits in order so you can plan your driving route.'**
  String get helpStepFinding4;

  /// No description provided for @helpSectionBackupsTitle.
  ///
  /// In en, this message translates to:
  /// **'Backups'**
  String get helpSectionBackupsTitle;

  /// No description provided for @helpStepBackups1.
  ///
  /// In en, this message translates to:
  /// **'Go to Settings and tap \"Create Backup\" to save a complete zip of your data and photos, ready to share or store somewhere safe.'**
  String get helpStepBackups1;

  /// No description provided for @helpStepBackups2.
  ///
  /// In en, this message translates to:
  /// **'Back up regularly, especially before switching devices or clearing app storage.'**
  String get helpStepBackups2;

  /// No description provided for @helpStepBackups3.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Restore Backup\" and choose a backup zip file to restore — this replaces all current data on the device, so make sure you mean to overwrite it.'**
  String get helpStepBackups3;

  /// No description provided for @helpStepBackups4.
  ///
  /// In en, this message translates to:
  /// **'Use \"Export Data\" for a CSV export of clients, animals, visits, service lines, and invoice summaries — handy for spreadsheets or accounting software.'**
  String get helpStepBackups4;

  /// No description provided for @helpSectionOfflineTitle.
  ///
  /// In en, this message translates to:
  /// **'Working Offline'**
  String get helpSectionOfflineTitle;

  /// No description provided for @helpStepOffline1.
  ///
  /// In en, this message translates to:
  /// **'FarrierLog stores everything locally on your device — there is no account, cloud sync, or internet connection required.'**
  String get helpStepOffline1;

  /// No description provided for @helpStepOffline2.
  ///
  /// In en, this message translates to:
  /// **'You can add clients, schedule visits, take photos, and generate invoices anywhere, with or without signal.'**
  String get helpStepOffline2;

  /// No description provided for @helpStepOffline3.
  ///
  /// In en, this message translates to:
  /// **'Because there\'s no cloud copy, your backups are the only way to move data to a new device or recover from data loss — back up before you need to.'**
  String get helpStepOffline3;

  /// No description provided for @helpStepOffline4.
  ///
  /// In en, this message translates to:
  /// **'Sharing an invoice, backup, or export uses your device\'s normal share options (email, messaging, cloud drive), which do require a connection at that moment.'**
  String get helpStepOffline4;

  /// No description provided for @skipButton.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skipButton;

  /// No description provided for @onboardingWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'FarrierLog helps you run your business from your phone — clients, scheduling, invoicing, and photos. Fully offline. No subscriptions.'**
  String get onboardingWelcomeBody;

  /// No description provided for @getStartedButton.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStartedButton;

  /// No description provided for @addBusinessDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Add your business details'**
  String get addBusinessDetailsTitle;

  /// No description provided for @addBusinessDetailsBody.
  ///
  /// In en, this message translates to:
  /// **'These appear on your invoices. You can always change them later in Settings.'**
  String get addBusinessDetailsBody;

  /// No description provided for @businessNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Business Name'**
  String get businessNameLabel;

  /// No description provided for @emailOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Email (optional)'**
  String get emailOptionalLabel;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get skipForNow;

  /// No description provided for @allSetTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re all set!'**
  String get allSetTitle;

  /// No description provided for @addFirstClientBody.
  ///
  /// In en, this message translates to:
  /// **'Add your first client to get started.'**
  String get addFirstClientBody;

  /// No description provided for @addFirstClientButton.
  ///
  /// In en, this message translates to:
  /// **'Add First Client'**
  String get addFirstClientButton;

  /// No description provided for @illDoItLater.
  ///
  /// In en, this message translates to:
  /// **'I\'ll do it later'**
  String get illDoItLater;

  /// No description provided for @invoiceHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Invoice History'**
  String get invoiceHistoryTitle;

  /// No description provided for @clearFiltersTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clearFiltersTooltip;

  /// No description provided for @exportCsvTooltip.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get exportCsvTooltip;

  /// No description provided for @exportFailedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Export failed: {error}'**
  String exportFailedSnackbar(String error);

  /// No description provided for @noPdfFoundSnackbar.
  ///
  /// In en, this message translates to:
  /// **'No PDF file found for this invoice'**
  String get noPdfFoundSnackbar;

  /// No description provided for @pdfNotFoundSnackbar.
  ///
  /// In en, this message translates to:
  /// **'PDF file not found: {path}'**
  String pdfNotFoundSnackbar(String path);

  /// No description provided for @shareInvoiceOnlyTitle.
  ///
  /// In en, this message translates to:
  /// **'Share Invoice Only (no photos)'**
  String get shareInvoiceOnlyTitle;

  /// No description provided for @shareInvoiceOnlySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Clean invoice — ideal for clients and accounting'**
  String get shareInvoiceOnlySubtitle;

  /// No description provided for @shareInvoicePhotosTitle.
  ///
  /// In en, this message translates to:
  /// **'Share Invoice + Photos'**
  String get shareInvoicePhotosTitle;

  /// No description provided for @shareInvoicePhotosSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Full document with photo documentation'**
  String get shareInvoicePhotosSubtitle;

  /// No description provided for @errorSharingInvoiceSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Error sharing invoice: {error}'**
  String errorSharingInvoiceSnackbar(String error);

  /// No description provided for @fromDateLabel.
  ///
  /// In en, this message translates to:
  /// **'From: {date}'**
  String fromDateLabel(String date);

  /// No description provided for @fromDatePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'From date'**
  String get fromDatePlaceholder;

  /// No description provided for @toDateLabel.
  ///
  /// In en, this message translates to:
  /// **'To: {date}'**
  String toDateLabel(String date);

  /// No description provided for @toDatePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'To date'**
  String get toDatePlaceholder;

  /// No description provided for @clientDropdownLabel.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get clientDropdownLabel;

  /// No description provided for @allClientsOption.
  ///
  /// In en, this message translates to:
  /// **'All clients'**
  String get allClientsOption;

  /// No description provided for @invoiceCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 invoice} other{{count} invoices}}'**
  String invoiceCount(int count);

  /// No description provided for @noInvoicesFound.
  ///
  /// In en, this message translates to:
  /// **'No invoices found'**
  String get noInvoicesFound;

  /// No description provided for @paidLabel.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paidLabel;

  /// No description provided for @unpaidLabel.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get unpaidLabel;

  /// No description provided for @invoiceNumberSubject.
  ///
  /// In en, this message translates to:
  /// **'Invoice {number}'**
  String invoiceNumberSubject(String number);

  /// No description provided for @exportCsvShareSubject.
  ///
  /// In en, this message translates to:
  /// **'Invoice History Export'**
  String get exportCsvShareSubject;

  /// No description provided for @exportCsvShareText.
  ///
  /// In en, this message translates to:
  /// **'Invoice history CSV export'**
  String get exportCsvShareText;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @helpGuideTitle.
  ///
  /// In en, this message translates to:
  /// **'Help & Guide'**
  String get helpGuideTitle;

  /// No description provided for @helpGuideSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How to use FarrierLog'**
  String get helpGuideSubtitle;

  /// No description provided for @colorLabel.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get colorLabel;

  /// No description provided for @companyInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Company Information'**
  String get companyInfoTitle;

  /// No description provided for @appearsOnInvoices.
  ///
  /// In en, this message translates to:
  /// **'Appears on invoices'**
  String get appearsOnInvoices;

  /// No description provided for @uploadLogoButton.
  ///
  /// In en, this message translates to:
  /// **'Upload Logo'**
  String get uploadLogoButton;

  /// No description provided for @companyNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Company Name'**
  String get companyNameLabel;

  /// No description provided for @currencyUnitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Currency & Units'**
  String get currencyUnitsTitle;

  /// No description provided for @currencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currencyLabel;

  /// No description provided for @currencyUsd.
  ///
  /// In en, this message translates to:
  /// **'\$ — US Dollar'**
  String get currencyUsd;

  /// No description provided for @currencyEur.
  ///
  /// In en, this message translates to:
  /// **'€ — Euro'**
  String get currencyEur;

  /// No description provided for @currencyGbp.
  ///
  /// In en, this message translates to:
  /// **'£ — Pound'**
  String get currencyGbp;

  /// No description provided for @currencyJpy.
  ///
  /// In en, this message translates to:
  /// **'¥ — Yen / Yuan'**
  String get currencyJpy;

  /// No description provided for @currencyInr.
  ///
  /// In en, this message translates to:
  /// **'₹ — Rupee'**
  String get currencyInr;

  /// No description provided for @currencyCad.
  ///
  /// In en, this message translates to:
  /// **'CAD\$ — Canadian Dollar'**
  String get currencyCad;

  /// No description provided for @currencyAud.
  ///
  /// In en, this message translates to:
  /// **'AUD\$ — Australian Dollar'**
  String get currencyAud;

  /// No description provided for @currencyNzd.
  ///
  /// In en, this message translates to:
  /// **'NZD\$ — New Zealand Dollar'**
  String get currencyNzd;

  /// No description provided for @currencyZar.
  ///
  /// In en, this message translates to:
  /// **'R — South African Rand'**
  String get currencyZar;

  /// No description provided for @currencyCustomOption.
  ///
  /// In en, this message translates to:
  /// **'Custom...'**
  String get currencyCustomOption;

  /// No description provided for @customCurrencySymbolLabel.
  ///
  /// In en, this message translates to:
  /// **'Custom currency symbol'**
  String get customCurrencySymbolLabel;

  /// No description provided for @customCurrencySymbolHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. CHF, kr, RM'**
  String get customCurrencySymbolHint;

  /// No description provided for @distanceUnitLabel.
  ///
  /// In en, this message translates to:
  /// **'Distance unit'**
  String get distanceUnitLabel;

  /// No description provided for @distanceMiles.
  ///
  /// In en, this message translates to:
  /// **'Miles (mi)'**
  String get distanceMiles;

  /// No description provided for @distanceKm.
  ///
  /// In en, this message translates to:
  /// **'Kilometres (km)'**
  String get distanceKm;

  /// No description provided for @mileageTitle.
  ///
  /// In en, this message translates to:
  /// **'Mileage'**
  String get mileageTitle;

  /// No description provided for @mileageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Default rate used when adding mileage or transport charges'**
  String get mileageSubtitle;

  /// No description provided for @mileageRateLabel.
  ///
  /// In en, this message translates to:
  /// **'Rate (per {unit})'**
  String mileageRateLabel(String unit);

  /// No description provided for @startWeekMondaySwitch.
  ///
  /// In en, this message translates to:
  /// **'Start calendar week on Monday'**
  String get startWeekMondaySwitch;

  /// No description provided for @reminderMessageTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder Message'**
  String get reminderMessageTitle;

  /// No description provided for @reminderTemplateLabel.
  ///
  /// In en, this message translates to:
  /// **'SMS Reminder Template'**
  String get reminderTemplateLabel;

  /// No description provided for @reminderTemplateHelp.
  ///
  /// In en, this message translates to:
  /// **'Use \"{token1}\", \"{token2}\", and \"{token3}\" — these fill in automatically.'**
  String reminderTemplateHelp(String token1, String token2, String token3);

  /// No description provided for @saveSettingsButton.
  ///
  /// In en, this message translates to:
  /// **'Save Settings'**
  String get saveSettingsButton;

  /// No description provided for @settingsSavedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Settings saved!'**
  String get settingsSavedSnackbar;

  /// No description provided for @serviceTemplatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Service Templates'**
  String get serviceTemplatesTitle;

  /// No description provided for @addTemplateTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add template'**
  String get addTemplateTooltip;

  /// No description provided for @noSavedTemplates.
  ///
  /// In en, this message translates to:
  /// **'No saved templates yet'**
  String get noSavedTemplates;

  /// No description provided for @exportDataButton.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportDataButton;

  /// No description provided for @exportingButton.
  ///
  /// In en, this message translates to:
  /// **'Exporting...'**
  String get exportingButton;

  /// No description provided for @importCalendarButton.
  ///
  /// In en, this message translates to:
  /// **'Import Calendar (.ics)'**
  String get importCalendarButton;

  /// No description provided for @importCalendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Import Calendar'**
  String get importCalendarTitle;

  /// No description provided for @noCalendarEventsFound.
  ///
  /// In en, this message translates to:
  /// **'No calendar events found in this file'**
  String get noCalendarEventsFound;

  /// No description provided for @calendarFileReadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t read calendar file: {error}'**
  String calendarFileReadFailed(String error);

  /// No description provided for @importSelectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get importSelectAll;

  /// No description provided for @importDeselectAll.
  ///
  /// In en, this message translates to:
  /// **'Deselect All'**
  String get importDeselectAll;

  /// No description provided for @importSelectedButton.
  ///
  /// In en, this message translates to:
  /// **'Import Selected ({count})'**
  String importSelectedButton(int count);

  /// No description provided for @importAllDay.
  ///
  /// In en, this message translates to:
  /// **'All day'**
  String get importAllDay;

  /// No description provided for @importSkipNoClient.
  ///
  /// In en, this message translates to:
  /// **'Skip — no client'**
  String get importSkipNoClient;

  /// No description provided for @importCreateNewClient.
  ///
  /// In en, this message translates to:
  /// **'Create new client from event'**
  String get importCreateNewClient;

  /// No description provided for @importDuplicateWarning.
  ///
  /// In en, this message translates to:
  /// **'This client already has a visit at this time'**
  String get importDuplicateWarning;

  /// No description provided for @importRecurrenceWeeks.
  ///
  /// In en, this message translates to:
  /// **'{weeks, plural, one{Repeats every week — imported as a recurring visit} other{Repeats every {weeks} weeks — imported as a recurring visit}}'**
  String importRecurrenceWeeks(int weeks);

  /// No description provided for @importRecurrenceUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Repeat rule not supported — imported as a one-time visit'**
  String get importRecurrenceUnsupported;

  /// No description provided for @importDuplicatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Possible Duplicates'**
  String get importDuplicatesTitle;

  /// No description provided for @importDuplicatesMessage.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 selected event already has a visit} other{{count} selected events already have a visit}} for the same client at the same time. Import anyway?'**
  String importDuplicatesMessage(int count);

  /// No description provided for @importAnywayButton.
  ///
  /// In en, this message translates to:
  /// **'Import Anyway'**
  String get importAnywayButton;

  /// No description provided for @importedVisitsSnackbar.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{Imported 1 visit} other{Imported {count} visits}}'**
  String importedVisitsSnackbar(int count);

  /// No description provided for @importFilteredCount.
  ///
  /// In en, this message translates to:
  /// **'Showing {shown} of {total} events'**
  String importFilteredCount(int shown, int total);

  /// No description provided for @importFilterByDate.
  ///
  /// In en, this message translates to:
  /// **'Filter by date'**
  String get importFilterByDate;

  /// No description provided for @importNoEventsInRange.
  ///
  /// In en, this message translates to:
  /// **'No events in the selected date range'**
  String get importNoEventsInRange;

  /// No description provided for @backupFailedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Backup failed: {error}'**
  String backupFailedSnackbar(String error);

  /// No description provided for @createBackupButton.
  ///
  /// In en, this message translates to:
  /// **'Create Backup'**
  String get createBackupButton;

  /// No description provided for @creatingBackupButton.
  ///
  /// In en, this message translates to:
  /// **'Creating Backup...'**
  String get creatingBackupButton;

  /// No description provided for @restoreBackupButton.
  ///
  /// In en, this message translates to:
  /// **'Restore Backup'**
  String get restoreBackupButton;

  /// No description provided for @restoringButton.
  ///
  /// In en, this message translates to:
  /// **'Restoring...'**
  String get restoringButton;

  /// No description provided for @restoreBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore Backup?'**
  String get restoreBackupTitle;

  /// No description provided for @restoreBackupMessage.
  ///
  /// In en, this message translates to:
  /// **'This will replace all current FarrierLog data on this device.'**
  String get restoreBackupMessage;

  /// No description provided for @restoreButton.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restoreButton;

  /// No description provided for @restoreFailedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Restore failed: {error}'**
  String restoreFailedSnackbar(String error);

  /// No description provided for @backupRestoredSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Backup restored.'**
  String get backupRestoredSnackbar;

  /// No description provided for @newServiceTemplateTitle.
  ///
  /// In en, this message translates to:
  /// **'New Service Template'**
  String get newServiceTemplateTitle;

  /// No description provided for @serviceLabel.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get serviceLabel;

  /// No description provided for @priceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get priceLabel;

  /// No description provided for @showWelcomeGuideAgain.
  ///
  /// In en, this message translates to:
  /// **'Show welcome guide again'**
  String get showWelcomeGuideAgain;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @languageSystemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystemDefault;

  /// No description provided for @remindTomorrowTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remind Tomorrow\'s Clients'**
  String get remindTomorrowTooltip;

  /// No description provided for @noAddressesSnackbar.
  ///
  /// In en, this message translates to:
  /// **'No addresses on file for today\'s visits'**
  String get noAddressesSnackbar;

  /// No description provided for @noVisitsWithPhoneSnackbar.
  ///
  /// In en, this message translates to:
  /// **'No visits with phone numbers tomorrow'**
  String get noVisitsWithPhoneSnackbar;

  /// No description provided for @tomorrowsRemindersTitle.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow\'s Reminders'**
  String get tomorrowsRemindersTitle;

  /// No description provided for @sendButton.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get sendButton;

  /// No description provided for @noVisitsScheduledToday.
  ///
  /// In en, this message translates to:
  /// **'No visits scheduled today'**
  String get noVisitsScheduledToday;

  /// No description provided for @enjoyDayOffSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enjoy the day off, or schedule a visit.'**
  String get enjoyDayOffSubtitle;

  /// No description provided for @visitsTodayCount.
  ///
  /// In en, this message translates to:
  /// **'{total, plural, one{1 visit today} other{{total} visits today}}'**
  String visitsTodayCount(int total);

  /// No description provided for @missingAddressCount.
  ///
  /// In en, this message translates to:
  /// **'{missing, plural, one{1 missing address} other{{missing} missing addresses}}'**
  String missingAddressCount(int missing);

  /// No description provided for @navigateTooltip.
  ///
  /// In en, this message translates to:
  /// **'Navigate'**
  String get navigateTooltip;

  /// No description provided for @noAddressOnFile.
  ///
  /// In en, this message translates to:
  /// **'No address on file'**
  String get noAddressOnFile;

  /// No description provided for @openFullRouteButton.
  ///
  /// In en, this message translates to:
  /// **'Open Full Route'**
  String get openFullRouteButton;

  /// No description provided for @photoComparisonTitle.
  ///
  /// In en, this message translates to:
  /// **'Photo Comparison'**
  String get photoComparisonTitle;

  /// No description provided for @swapPhotosTooltip.
  ///
  /// In en, this message translates to:
  /// **'Swap photos'**
  String get swapPhotosTooltip;

  /// No description provided for @elapsedBetweenVisits.
  ///
  /// In en, this message translates to:
  /// **'{elapsed} between these visits'**
  String elapsedBetweenVisits(String elapsed);

  /// No description provided for @elapsedDays.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, one{1 day} other{{days} days}}'**
  String elapsedDays(int days);

  /// No description provided for @elapsedWeeks.
  ///
  /// In en, this message translates to:
  /// **'{weeks, plural, one{1 week} other{{weeks} weeks}}'**
  String elapsedWeeks(int weeks);

  /// No description provided for @beforeLabel.
  ///
  /// In en, this message translates to:
  /// **'BEFORE'**
  String get beforeLabel;

  /// No description provided for @afterLabel.
  ///
  /// In en, this message translates to:
  /// **'AFTER'**
  String get afterLabel;

  /// No description provided for @animalTitle.
  ///
  /// In en, this message translates to:
  /// **'Animal'**
  String get animalTitle;

  /// No description provided for @progressReportTooltip.
  ///
  /// In en, this message translates to:
  /// **'Progress Report'**
  String get progressReportTooltip;

  /// No description provided for @progressReportSubject.
  ///
  /// In en, this message translates to:
  /// **'{name} — Progress Report'**
  String progressReportSubject(String name);

  /// No description provided for @photoDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get photoDefaultTitle;

  /// No description provided for @ownerLabel.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get ownerLabel;

  /// No description provided for @noVisitsRecordedForAnimal.
  ///
  /// In en, this message translates to:
  /// **'No visits recorded for this animal yet.'**
  String get noVisitsRecordedForAnimal;

  /// No description provided for @noPhotosForAnimal.
  ///
  /// In en, this message translates to:
  /// **'No photos tagged to this animal yet.'**
  String get noPhotosForAnimal;

  /// No description provided for @compareButton.
  ///
  /// In en, this message translates to:
  /// **'Compare'**
  String get compareButton;

  /// No description provided for @openVisitButton.
  ///
  /// In en, this message translates to:
  /// **'Open visit'**
  String get openVisitButton;

  /// No description provided for @daysSinceLastVisit.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, one{1 day since last visit} other{{days} days since last visit}}'**
  String daysSinceLastVisit(int days);

  /// No description provided for @weeksSinceLastShoeing.
  ///
  /// In en, this message translates to:
  /// **'{weeks, plural, one{1 week since last shoeing} other{{weeks} weeks since last shoeing}}'**
  String weeksSinceLastShoeing(int weeks);

  /// No description provided for @visitHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Visit History ({count})'**
  String visitHistoryTitle(int count);

  /// No description provided for @photoHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Photo History'**
  String get photoHistoryTitle;

  /// No description provided for @visitTitle.
  ///
  /// In en, this message translates to:
  /// **'Visit'**
  String get visitTitle;

  /// No description provided for @deleteServiceLineTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Service Line'**
  String get deleteServiceLineTitle;

  /// No description provided for @deleteChargeTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Charge'**
  String get deleteChargeTitle;

  /// No description provided for @removeQuotedItem.
  ///
  /// In en, this message translates to:
  /// **'Remove \"{name}\"?'**
  String removeQuotedItem(String name);

  /// No description provided for @takeAPhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takeAPhoto;

  /// No description provided for @chooseFromCameraRoll.
  ///
  /// In en, this message translates to:
  /// **'Choose from camera roll'**
  String get chooseFromCameraRoll;

  /// No description provided for @photoDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Photo Details'**
  String get photoDetailsTitle;

  /// No description provided for @tagToAnimalsLabel.
  ///
  /// In en, this message translates to:
  /// **'Tag to animal(s):'**
  String get tagToAnimalsLabel;

  /// No description provided for @captionLabel.
  ///
  /// In en, this message translates to:
  /// **'Caption'**
  String get captionLabel;

  /// No description provided for @includeOnInvoiceSwitch.
  ///
  /// In en, this message translates to:
  /// **'Include on invoice'**
  String get includeOnInvoiceSwitch;

  /// No description provided for @addPhotosCountTitle.
  ///
  /// In en, this message translates to:
  /// **'Add {count} Photos'**
  String addPhotosCountTitle(int count);

  /// No description provided for @photosSelectedFromGallery.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 photo selected from gallery} other{{count} photos selected from gallery}}'**
  String photosSelectedFromGallery(int count);

  /// No description provided for @tagAllToAnimalsLabel.
  ///
  /// In en, this message translates to:
  /// **'Tag all to animal(s):'**
  String get tagAllToAnimalsLabel;

  /// No description provided for @captionAllPhotosLabel.
  ///
  /// In en, this message translates to:
  /// **'Caption (all photos)'**
  String get captionAllPhotosLabel;

  /// No description provided for @saveAllButton.
  ///
  /// In en, this message translates to:
  /// **'Save All'**
  String get saveAllButton;

  /// No description provided for @deletePhotoTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Photo'**
  String get deletePhotoTitle;

  /// No description provided for @removePhotoMessage.
  ///
  /// In en, this message translates to:
  /// **'Remove this photo?'**
  String get removePhotoMessage;

  /// No description provided for @viewShareInvoiceTitle.
  ///
  /// In en, this message translates to:
  /// **'View / Share Invoice'**
  String get viewShareInvoiceTitle;

  /// No description provided for @regenerateInvoiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Regenerate Invoice'**
  String get regenerateInvoiceTitle;

  /// No description provided for @regenerateInvoiceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Delete current and generate a new one'**
  String get regenerateInvoiceSubtitle;

  /// No description provided for @invoiceSubjectFor.
  ///
  /// In en, this message translates to:
  /// **'Invoice for {name}'**
  String invoiceSubjectFor(String name);

  /// No description provided for @shareInvoicePdfTitle.
  ///
  /// In en, this message translates to:
  /// **'Share Invoice (PDF)'**
  String get shareInvoicePdfTitle;

  /// No description provided for @shareInvoicePdfSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Send via any app - Gmail, WhatsApp, etc.'**
  String get shareInvoicePdfSubtitle;

  /// No description provided for @printInvoiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Print Invoice'**
  String get printInvoiceTitle;

  /// No description provided for @errorGeneratingInvoiceSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Error generating invoice: {error}'**
  String errorGeneratingInvoiceSnackbar(String error);

  /// No description provided for @regenerateInvoiceConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Regenerate Invoice?'**
  String get regenerateInvoiceConfirmTitle;

  /// No description provided for @regenerateInvoiceConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This will delete the current invoice and generate a new one based on current service lines and charges.'**
  String get regenerateInvoiceConfirmMessage;

  /// No description provided for @regenerateButton.
  ///
  /// In en, this message translates to:
  /// **'Regenerate'**
  String get regenerateButton;

  /// No description provided for @invoicePdfNotFoundSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Invoice PDF not found: {name}'**
  String invoicePdfNotFoundSnackbar(String name);

  /// No description provided for @deleteVisitTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Visit'**
  String get deleteVisitTitle;

  /// No description provided for @deleteVisitConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this visit?'**
  String get deleteVisitConfirmMessage;

  /// No description provided for @couldNotOpenMapsSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Could not open Google Maps'**
  String get couldNotOpenMapsSnackbar;

  /// No description provided for @calendarEventTitle.
  ///
  /// In en, this message translates to:
  /// **'Farrier - {name}'**
  String calendarEventTitle(String name);

  /// No description provided for @calendarEventDefaultDescription.
  ///
  /// In en, this message translates to:
  /// **'Farrier visit'**
  String get calendarEventDefaultDescription;

  /// No description provided for @calendarEventNotAddedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Calendar event could not be added.'**
  String get calendarEventNotAddedSnackbar;

  /// No description provided for @calendarEventErrorSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Calendar event could not be added: {error}'**
  String calendarEventErrorSnackbar(String error);

  /// No description provided for @noPhoneForClientSnackbar.
  ///
  /// In en, this message translates to:
  /// **'No phone number is saved for this client.'**
  String get noPhoneForClientSnackbar;

  /// No description provided for @couldNotOpenSmsSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Could not open the SMS app.'**
  String get couldNotOpenSmsSnackbar;

  /// No description provided for @noSavedNotesSnackbar.
  ///
  /// In en, this message translates to:
  /// **'No saved notes found for this client or their animals.'**
  String get noSavedNotesSnackbar;

  /// No description provided for @insertFromNotesTitle.
  ///
  /// In en, this message translates to:
  /// **'Insert from Notes'**
  String get insertFromNotesTitle;

  /// No description provided for @clientNotesHeader.
  ///
  /// In en, this message translates to:
  /// **'📋 Client — {name}'**
  String clientNotesHeader(String name);

  /// No description provided for @animalNotesHeader.
  ///
  /// In en, this message translates to:
  /// **'🐾 {name}'**
  String animalNotesHeader(String name);

  /// No description provided for @insertButton.
  ///
  /// In en, this message translates to:
  /// **'+ Insert'**
  String get insertButton;

  /// No description provided for @noAddressSaved.
  ///
  /// In en, this message translates to:
  /// **'No address saved'**
  String get noAddressSaved;

  /// No description provided for @appointmentAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Appointment Address'**
  String get appointmentAddressTitle;

  /// No description provided for @openInGoogleMaps.
  ///
  /// In en, this message translates to:
  /// **'Open in Google Maps'**
  String get openInGoogleMaps;

  /// No description provided for @editVisitMenuItem.
  ///
  /// In en, this message translates to:
  /// **'Edit Visit'**
  String get editVisitMenuItem;

  /// No description provided for @deleteVisitMenuItem.
  ///
  /// In en, this message translates to:
  /// **'Delete Visit'**
  String get deleteVisitMenuItem;

  /// No description provided for @invoiceNotesPrefix.
  ///
  /// In en, this message translates to:
  /// **'Invoice Notes: {notes}'**
  String invoiceNotesPrefix(String notes);

  /// No description provided for @addToPhoneCalendarButton.
  ///
  /// In en, this message translates to:
  /// **'Add to Phone Calendar'**
  String get addToPhoneCalendarButton;

  /// No description provided for @sendReminderButton.
  ///
  /// In en, this message translates to:
  /// **'Send Reminder'**
  String get sendReminderButton;

  /// No description provided for @confirmAppointmentButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm this appointment'**
  String get confirmAppointmentButton;

  /// No description provided for @visitCompletedSwitch.
  ///
  /// In en, this message translates to:
  /// **'Visit completed'**
  String get visitCompletedSwitch;

  /// No description provided for @paymentReceivedSwitch.
  ///
  /// In en, this message translates to:
  /// **'Payment received'**
  String get paymentReceivedSwitch;

  /// No description provided for @animalsCountTitle.
  ///
  /// In en, this message translates to:
  /// **'Animals ({count})'**
  String animalsCountTitle(int count);

  /// No description provided for @noAnimalsForVisit.
  ///
  /// In en, this message translates to:
  /// **'No animals selected for this visit'**
  String get noAnimalsForVisit;

  /// No description provided for @billingTitle.
  ///
  /// In en, this message translates to:
  /// **'Billing'**
  String get billingTitle;

  /// No description provided for @addServiceLineLabel.
  ///
  /// In en, this message translates to:
  /// **'Add Service Line'**
  String get addServiceLineLabel;

  /// No description provided for @noServiceLinesYet.
  ///
  /// In en, this message translates to:
  /// **'No service lines yet'**
  String get noServiceLinesYet;

  /// No description provided for @travelIncidentalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Travel & Incidentals'**
  String get travelIncidentalsTitle;

  /// No description provided for @addChargeLabel.
  ///
  /// In en, this message translates to:
  /// **'Add Charge'**
  String get addChargeLabel;

  /// No description provided for @noChargesYet.
  ///
  /// In en, this message translates to:
  /// **'No travel or incidental charges yet'**
  String get noChargesYet;

  /// No description provided for @servicesAndTravelSummary.
  ///
  /// In en, this message translates to:
  /// **'Services: {services} · Travel & Incidentals: {travel}'**
  String servicesAndTravelSummary(String services, String travel);

  /// No description provided for @totalLabelPlain.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalLabelPlain;

  /// No description provided for @invoiceNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Invoice Notes'**
  String get invoiceNotesLabel;

  /// No description provided for @invoiceNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Printed on invoice...'**
  String get invoiceNotesHint;

  /// No description provided for @insertFromSavedNotesTooltip.
  ///
  /// In en, this message translates to:
  /// **'Insert from saved notes'**
  String get insertFromSavedNotesTooltip;

  /// No description provided for @generateInvoiceButton.
  ///
  /// In en, this message translates to:
  /// **'Generate Invoice'**
  String get generateInvoiceButton;

  /// No description provided for @createInvoiceButton.
  ///
  /// In en, this message translates to:
  /// **'Create Invoice'**
  String get createInvoiceButton;

  /// No description provided for @addServiceLinesBeforeInvoice.
  ///
  /// In en, this message translates to:
  /// **'Add service lines or charges before creating an invoice'**
  String get addServiceLinesBeforeInvoice;

  /// No description provided for @paidInFull.
  ///
  /// In en, this message translates to:
  /// **'Paid in Full'**
  String get paidInFull;

  /// No description provided for @photosCountTitle.
  ///
  /// In en, this message translates to:
  /// **'Photos ({count})'**
  String photosCountTitle(int count);

  /// No description provided for @addPhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get addPhotoLabel;

  /// No description provided for @noPhotosYet.
  ///
  /// In en, this message translates to:
  /// **'No photos yet'**
  String get noPhotosYet;

  /// No description provided for @generateInvoiceTooltip.
  ///
  /// In en, this message translates to:
  /// **'Generate Invoice'**
  String get generateInvoiceTooltip;

  /// No description provided for @regenerateInvoiceTooltip.
  ///
  /// In en, this message translates to:
  /// **'Regenerate Invoice'**
  String get regenerateInvoiceTooltip;

  /// No description provided for @editVisitTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Visit'**
  String get editVisitTitle;

  /// No description provided for @newVisitTitle.
  ///
  /// In en, this message translates to:
  /// **'New Visit'**
  String get newVisitTitle;

  /// No description provided for @pleaseSelectClient.
  ///
  /// In en, this message translates to:
  /// **'Please select a client'**
  String get pleaseSelectClient;

  /// No description provided for @searchForClientPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search for a client...'**
  String get searchForClientPlaceholder;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @timeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeLabel;

  /// No description provided for @recurringLabel.
  ///
  /// In en, this message translates to:
  /// **'Recurring'**
  String get recurringLabel;

  /// No description provided for @recurrenceEvery4.
  ///
  /// In en, this message translates to:
  /// **'Every 4 weeks'**
  String get recurrenceEvery4;

  /// No description provided for @recurrenceEvery6.
  ///
  /// In en, this message translates to:
  /// **'Every 6 weeks'**
  String get recurrenceEvery6;

  /// No description provided for @recurrenceEvery8.
  ///
  /// In en, this message translates to:
  /// **'Every 8 weeks'**
  String get recurrenceEvery8;

  /// No description provided for @recurrenceEvery10.
  ///
  /// In en, this message translates to:
  /// **'Every 10 weeks'**
  String get recurrenceEvery10;

  /// No description provided for @recurrenceCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom weeks'**
  String get recurrenceCustom;

  /// No description provided for @customWeeksLabel.
  ///
  /// In en, this message translates to:
  /// **'Custom weeks'**
  String get customWeeksLabel;

  /// No description provided for @customWeeksMustBeGreaterThanZero.
  ///
  /// In en, this message translates to:
  /// **'Custom weeks must be greater than 0'**
  String get customWeeksMustBeGreaterThanZero;

  /// No description provided for @selectAnimalsLabel.
  ///
  /// In en, this message translates to:
  /// **'Select Animals'**
  String get selectAnimalsLabel;

  /// No description provided for @noAnimalsForClient.
  ///
  /// In en, this message translates to:
  /// **'No animals for this client'**
  String get noAnimalsForClient;

  /// No description provided for @groupServiceHint.
  ///
  /// In en, this message translates to:
  /// **'Don\'t need to track individual animals for this stop? Add a group service line from the visit screen after saving.'**
  String get groupServiceHint;

  /// No description provided for @invoiceNotesHintNewVisit.
  ///
  /// In en, this message translates to:
  /// **'Printed on invoice — services, corrections, special notes...'**
  String get invoiceNotesHintNewVisit;

  /// No description provided for @updateVisitButton.
  ///
  /// In en, this message translates to:
  /// **'Update Visit'**
  String get updateVisitButton;

  /// No description provided for @saveVisitButton.
  ///
  /// In en, this message translates to:
  /// **'Save Visit'**
  String get saveVisitButton;

  /// No description provided for @searchClientsHint.
  ///
  /// In en, this message translates to:
  /// **'Search clients...'**
  String get searchClientsHint;

  /// No description provided for @noClientsFound.
  ///
  /// In en, this message translates to:
  /// **'No clients found'**
  String get noClientsFound;

  /// No description provided for @clientDetailDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {name}? This will also delete all associated visits, animals, and photos.'**
  String clientDetailDeleteMessage(String name);

  /// No description provided for @deleteAnimalTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Animal'**
  String get deleteAnimalTitle;

  /// No description provided for @deleteAnimalConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {name}?'**
  String deleteAnimalConfirmMessage(String name);

  /// No description provided for @deleteVisitConfirmMessageWithDate.
  ///
  /// In en, this message translates to:
  /// **'Delete the visit on {date}?'**
  String deleteVisitConfirmMessageWithDate(String date);

  /// No description provided for @scheduleVisitButton.
  ///
  /// In en, this message translates to:
  /// **'Schedule Visit'**
  String get scheduleVisitButton;

  /// No description provided for @tapToCallLongPressText.
  ///
  /// In en, this message translates to:
  /// **'Tap to call • Long-press to text'**
  String get tapToCallLongPressText;

  /// No description provided for @tapToEmail.
  ///
  /// In en, this message translates to:
  /// **'Tap to email'**
  String get tapToEmail;

  /// No description provided for @openInMaps.
  ///
  /// In en, this message translates to:
  /// **'Open in maps'**
  String get openInMaps;

  /// No description provided for @notesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes: {notes}'**
  String notesLabel(String notes);

  /// No description provided for @privateStaffNotesTitle.
  ///
  /// In en, this message translates to:
  /// **'Private Staff Notes'**
  String get privateStaffNotesTitle;

  /// No description provided for @addAnimalLabel.
  ///
  /// In en, this message translates to:
  /// **'Add Animal'**
  String get addAnimalLabel;

  /// No description provided for @noAnimalsAddedYet.
  ///
  /// In en, this message translates to:
  /// **'No animals added yet'**
  String get noAnimalsAddedYet;

  /// No description provided for @visitsCountHeader.
  ///
  /// In en, this message translates to:
  /// **'Visits ({count})'**
  String visitsCountHeader(int count);

  /// No description provided for @noVisitsYet.
  ///
  /// In en, this message translates to:
  /// **'No visits yet'**
  String get noVisitsYet;

  /// No description provided for @editAnimalTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Animal'**
  String get editAnimalTitle;

  /// No description provided for @newAnimalTitle.
  ///
  /// In en, this message translates to:
  /// **'New Animal'**
  String get newAnimalTitle;

  /// No description provided for @speciesLabel.
  ///
  /// In en, this message translates to:
  /// **'Species'**
  String get speciesLabel;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @animalNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Animal Notes (private)'**
  String get animalNotesLabel;

  /// No description provided for @animalNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Health history, behaviour, handling notes...'**
  String get animalNotesHint;

  /// No description provided for @internalNotesHintAnimal.
  ///
  /// In en, this message translates to:
  /// **'Private staff observations — never on invoice'**
  String get internalNotesHintAnimal;

  /// No description provided for @editServiceLineTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Service Line'**
  String get editServiceLineTitle;

  /// No description provided for @addServiceLineTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Service Line'**
  String get addServiceLineTitle;

  /// No description provided for @savedTemplatesLabel.
  ///
  /// In en, this message translates to:
  /// **'Saved Templates'**
  String get savedTemplatesLabel;

  /// No description provided for @singleAnimalOption.
  ///
  /// In en, this message translates to:
  /// **'Single Animal'**
  String get singleAnimalOption;

  /// No description provided for @groupHeadcountOption.
  ///
  /// In en, this message translates to:
  /// **'Group / Headcount'**
  String get groupHeadcountOption;

  /// No description provided for @animalDropdownLabel.
  ///
  /// In en, this message translates to:
  /// **'Animal'**
  String get animalDropdownLabel;

  /// No description provided for @groupDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Group description'**
  String get groupDescriptionLabel;

  /// No description provided for @groupDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Back pasture herd, Smith Ranch'**
  String get groupDescriptionHint;

  /// No description provided for @numberOfAnimalsLabel.
  ///
  /// In en, this message translates to:
  /// **'Number of animals'**
  String get numberOfAnimalsLabel;

  /// No description provided for @enterWholeNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a whole number of 1 or more'**
  String get enterWholeNumber;

  /// No description provided for @pricePerAnimalLabel.
  ///
  /// In en, this message translates to:
  /// **'Price per animal'**
  String get pricePerAnimalLabel;

  /// No description provided for @saveAsTemplateButton.
  ///
  /// In en, this message translates to:
  /// **'Save as template'**
  String get saveAsTemplateButton;

  /// No description provided for @enterDescriptionFirstSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Enter a description first'**
  String get enterDescriptionFirstSnackbar;

  /// No description provided for @templateSavedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'\"{description}\" saved as template'**
  String templateSavedSnackbar(String description);

  /// No description provided for @editChargeTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Charge'**
  String get editChargeTitle;

  /// No description provided for @addChargeTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Charge'**
  String get addChargeTitle;

  /// No description provided for @typeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get typeLabel;

  /// No description provided for @distanceLabelWithUnit.
  ///
  /// In en, this message translates to:
  /// **'Distance ({unit})'**
  String distanceLabelWithUnit(String unit);

  /// No description provided for @enterNumberZeroOrMore.
  ///
  /// In en, this message translates to:
  /// **'Enter a number 0 or more'**
  String get enterNumberZeroOrMore;

  /// No description provided for @ratePerUnitLabel.
  ///
  /// In en, this message translates to:
  /// **'Rate per {unit}'**
  String ratePerUnitLabel(String unit);

  /// No description provided for @amountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amountLabel;

  /// No description provided for @invalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid number'**
  String get invalidNumber;

  /// No description provided for @chargeTypeMileage.
  ///
  /// In en, this message translates to:
  /// **'Mileage'**
  String get chargeTypeMileage;

  /// No description provided for @chargeTypeTolls.
  ///
  /// In en, this message translates to:
  /// **'Tolls'**
  String get chargeTypeTolls;

  /// No description provided for @chargeTypeReimbursement.
  ///
  /// In en, this message translates to:
  /// **'Reimbursement'**
  String get chargeTypeReimbursement;

  /// No description provided for @chargeTypeTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get chargeTypeTransport;

  /// No description provided for @chargeTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get chargeTypeOther;

  /// No description provided for @statusProjected.
  ///
  /// In en, this message translates to:
  /// **'Projected'**
  String get statusProjected;

  /// No description provided for @statusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get statusPaid;

  /// No description provided for @statusOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get statusOverdue;

  /// No description provided for @statusToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get statusToday;

  /// No description provided for @statusUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get statusUpcoming;

  /// No description provided for @badgeScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get badgeScheduled;

  /// No description provided for @badgeNoVisitsYet.
  ///
  /// In en, this message translates to:
  /// **'No visits yet'**
  String get badgeNoVisitsYet;

  /// No description provided for @badgeWeeksAgo.
  ///
  /// In en, this message translates to:
  /// **'{weeks, plural, one{1 wk ago} other{{weeks} wk ago}}'**
  String badgeWeeksAgo(int weeks);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
