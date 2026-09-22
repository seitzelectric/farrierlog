// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get cancel => 'Annuler';

  @override
  String get add => 'Ajouter';

  @override
  String get save => 'Enregistrer';

  @override
  String get delete => 'Supprimer';

  @override
  String get edit => 'Modifier';

  @override
  String get update => 'Mettre à jour';

  @override
  String get view => 'Afficher';

  @override
  String get share => 'Partager';

  @override
  String get print => 'Imprimer';

  @override
  String get confirm => 'Confirmer';

  @override
  String get requiredField => 'Obligatoire';

  @override
  String get generalLabel => 'Général';

  @override
  String get groupLabelFallback => 'Groupe';

  @override
  String groupAnimalCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '× $count animaux',
      one: '× $count animal',
    );
    return '$_temp0';
  }

  @override
  String get noneLabel => 'Aucune';

  @override
  String totalLabel(String amount) {
    return 'Total : $amount';
  }

  @override
  String get navClients => 'Clients';

  @override
  String get navCalendar => 'Calendrier';

  @override
  String get navDashboard => 'Tableau de bord';

  @override
  String get navInvoices => 'Factures';

  @override
  String get navAnimals => 'Animaux';

  @override
  String get deleteClientTitle => 'Supprimer le client';

  @override
  String get noContactInfo => 'Aucune coordonnée';

  @override
  String get noClientsYet => 'Aucun client pour l\'instant';

  @override
  String get addFirstClientSubtitle =>
      'Ajoutez votre premier client pour commencer';

  @override
  String get addClientButton => 'Ajouter un client';

  @override
  String clientListDeleteMessage(String name) {
    return 'Supprimer $name ? Cela supprimera aussi toutes les visites, tous les animaux et toutes les photos associés.';
  }

  @override
  String get editClientTitle => 'Modifier le client';

  @override
  String get addClientTitle => 'Ajouter un client';

  @override
  String get nameLabel => 'Nom';

  @override
  String get firstNameLabel => 'Prénom';

  @override
  String get lastNameLabel => 'Nom';

  @override
  String get phoneLabel => 'Téléphone';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get addressLabel => 'Adresse';

  @override
  String get clientNotesLabel =>
      'Notes du client (privées — absentes de la facture)';

  @override
  String get clientNotesHint =>
      'Codes de portail, préférences de paiement, consignes de sécurité...';

  @override
  String get internalNotesLabel => 'Notes internes (réservées au personnel)';

  @override
  String get internalNotesHintClient =>
      'Observations, mises en garde — jamais visibles du client ni sur la facture';

  @override
  String get animalsTitle => 'Animaux';

  @override
  String get searchAnimalsHint =>
      'Rechercher par nom d\'animal ou de client...';

  @override
  String animalCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count animaux',
      one: '$count animal',
    );
    return '$_temp0';
  }

  @override
  String get noAnimalsYet => 'Aucun animal pour l\'instant';

  @override
  String noAnimalsMatch(String query) {
    return 'Aucun animal ne correspond à « $query »';
  }

  @override
  String get calendarTitle => 'Calendrier';

  @override
  String get appointmentConfirmedSnackbar => 'Rendez-vous confirmé';

  @override
  String get recurringVisitTitle => 'Visite récurrente';

  @override
  String get scheduleNextRecurringVisit =>
      'Planifier la prochaine visite récurrente ?';

  @override
  String noVisitsOnDate(String date) {
    return 'Aucune visite le $date';
  }

  @override
  String get newAppointmentButton => 'Nouveau rendez-vous';

  @override
  String get dashListTitleClients => 'Clients';

  @override
  String get dashListTitleAnimals => 'Animaux';

  @override
  String get dashListTitleUpcoming => 'Visites à venir';

  @override
  String get dashListTitlePastDue => 'Visites en retard';

  @override
  String get dashListTitleOutstanding => 'Visites impayées';

  @override
  String get dashListTitlePaid => 'Visites payées';

  @override
  String get dashEmptyUpcomingTitle => 'Aucune visite à venir';

  @override
  String get dashEmptyPastDueTitle => 'Aucune visite en retard';

  @override
  String get dashEmptyOutstandingTitle => 'Aucune visite impayée';

  @override
  String get dashEmptyPaidTitle => 'Aucune visite payée pour l\'instant';

  @override
  String get dashEmptyClientsSubtitle =>
      'Ajoutez des clients depuis l\'onglet Clients.';

  @override
  String get dashEmptyAnimalsSubtitle =>
      'Les animaux apparaîtront ici une fois ajoutés aux clients.';

  @override
  String get dashEmptyUpcomingSubtitle =>
      'Aucune visite n\'est prévue dans les 30 prochains jours.';

  @override
  String get dashEmptyPastDueSubtitle =>
      'Toutes les visites sont marquées comme terminées.';

  @override
  String get dashEmptyOutstandingSubtitle =>
      'Toutes les visites terminées ont été payées.';

  @override
  String get dashEmptyPaidSubtitle =>
      'Les visites payées apparaîtront ici une fois les factures ou visites marquées comme payées.';

  @override
  String get dashboardTitle => 'Tableau de bord';

  @override
  String get todaysRouteTitle => 'Tournée du jour';

  @override
  String get todaysRouteSubtitle =>
      'Voir tous les arrêts d\'aujourd\'hui dans l\'ordre';

  @override
  String get statTotalClients => 'Total des clients';

  @override
  String get statTotalAnimals => 'Total des animaux';

  @override
  String get statUpcoming => 'À venir';

  @override
  String get statPastDue => 'En retard';

  @override
  String get statTotalRevenue => 'Revenu total';

  @override
  String get statOutstanding => 'Impayé';

  @override
  String get milesDrivenTitle => 'Distance parcourue';

  @override
  String get thisMonth => 'Ce mois-ci';

  @override
  String get thisYear => 'Cette année';

  @override
  String get revenueTrendTitle => 'Tendance des revenus (12 mois)';

  @override
  String get next7DaysTitle => '7 prochains jours';

  @override
  String get newVisitLabel => 'Nouvelle visite';

  @override
  String get noUpcomingVisitsThisWeek => 'Aucune visite à venir cette semaine';

  @override
  String get helpTitle => 'Aide et guide';

  @override
  String get welcomeToFarrierLog => 'Bienvenue sur FarrierLog';

  @override
  String get helpIntro =>
      'Ce guide couvre tout ce que FarrierLog peut faire, de l\'ajout de votre premier client à la sauvegarde de vos données. Touchez une section ci-dessous pour la développer.';

  @override
  String get helpSectionGettingStartedTitle => 'Premiers pas';

  @override
  String get helpStepGettingStarted1 =>
      'Ouvrez les Paramètres et renseignez le nom, l\'adresse, le téléphone et l\'e-mail de votre entreprise — ces informations apparaissent sur chaque facture envoyée.';

  @override
  String get helpStepGettingStarted2 =>
      'Choisissez un thème de couleur et définissez votre devise et votre unité de distance préférées.';

  @override
  String get helpStepGettingStarted3 =>
      'Ajoutez votre premier client depuis l\'onglet Clients, puis ajoutez ses animaux.';

  @override
  String get helpStepGettingStarted4 =>
      'Planifiez une visite depuis la page du client ou avec le bouton de nouveau rendez-vous du calendrier.';

  @override
  String get helpSectionClientsAnimalsTitle => 'Clients et animaux';

  @override
  String get helpStepClientsAnimals1 =>
      'Allez dans l\'onglet Clients et touchez le bouton d\'ajout pour créer un nouveau client avec ses coordonnées et son adresse.';

  @override
  String get helpStepClientsAnimals2 =>
      'Ouvrez la page d\'un client et touchez « Ajouter un animal » pour ajouter chaque cheval ou autre animal que vous ferrez pour lui.';

  @override
  String get helpStepClientsAnimals3 =>
      'Touchez le numéro de téléphone d\'un client pour appeler, ou maintenez pour envoyer un SMS.';

  @override
  String get helpStepClientsAnimals4 =>
      'Touchez l\'adresse d\'un client pour l\'ouvrir dans le plan et obtenir l\'itinéraire.';

  @override
  String get helpStepClientsAnimals5 =>
      'Utilisez les « Notes internes » d\'un client ou d\'un animal pour des notes privées réservées au personnel — elles n\'apparaissent jamais sur les factures.';

  @override
  String get helpStepClientsAnimals6 =>
      'Balayez vers la gauche sur un client ou un animal pour le supprimer. Supprimer un client supprime aussi ses animaux, ses visites et ses photos.';

  @override
  String get helpSectionSchedulingTitle => 'Planifier les visites';

  @override
  String get helpStepScheduling1 =>
      'Touchez l\'onglet calendrier pour voir toutes les visites passées et à venir — les marqueurs pleins sont confirmés, les marqueurs contourés sont des projections automatiques.';

  @override
  String get helpStepScheduling2 =>
      'Touchez le bouton de nouveau rendez-vous du calendrier pour planifier une visite à une date précise.';

  @override
  String get helpStepScheduling3 =>
      'Recherchez un client par nom ou adresse plutôt que de parcourir une longue liste.';

  @override
  String get helpStepScheduling4 =>
      'Définissez un intervalle de récurrence (en semaines) sur une visite pour projeter automatiquement le prochain rendez-vous une fois l\'actuel confirmé.';

  @override
  String get helpStepScheduling5 =>
      'Confirmer une visite générée automatiquement crée la visite projetée suivante dans la chaîne — les visites futures ne sont pas toutes créées d\'un coup.';

  @override
  String get helpSectionInvoicingTitle => 'Services, frais et facturation';

  @override
  String get helpStepInvoicing1 =>
      'Ouvrez une visite et ajoutez des lignes de service pour chaque animal — saisissez une description et un prix, ou facturez au nombre d\'animaux pour les services de groupe.';

  @override
  String get helpStepInvoicing2 =>
      'Enregistrez les services fréquemment utilisés comme modèles dans Paramètres pour les ajouter en un seul geste la prochaine fois.';

  @override
  String get helpStepInvoicing3 =>
      'Ajoutez les frais de déplacement et divers (kilométrage, péages, remboursements) séparément des lignes de service.';

  @override
  String get helpStepInvoicing4 =>
      'Définissez votre tarif kilométrique par défaut dans Paramètres pour qu\'il soit prérempli à chaque ajout d\'un frais de déplacement.';

  @override
  String get helpStepInvoicing5 =>
      'Une fois la visite terminée, générez le PDF de la facture, puis imprimez-le ou partagez-le directement depuis la visite.';

  @override
  String get helpSectionGettingPaidTitle => 'Se faire payer';

  @override
  String get helpStepGettingPaid1 =>
      'Une visite a deux états : terminée (le travail est fait) et payée (le paiement est reçu) — cochez chacun au fur et à mesure.';

  @override
  String get helpStepGettingPaid2 =>
      'Le tableau de bord affiche les revenus acquis et prévus pour suivre d\'un coup d\'œil ce qui reste dû.';

  @override
  String get helpStepGettingPaid3 =>
      'Utilisez l\'écran d\'historique des factures pour retrouver et repartager toute facture passée.';

  @override
  String get helpStepGettingPaid4 =>
      'Les visites impayées et en retard sont mises en évidence pour que rien ne vous échappe.';

  @override
  String get helpSectionPhotosTitle => 'Photos';

  @override
  String get helpStepPhotos1 =>
      'Depuis une visite, prenez des photos et associez-les à un ou plusieurs animaux à l\'aide des cases à cocher — tous les animaux de la visite sont précochés par défaut.';

  @override
  String get helpStepPhotos2 =>
      'Ouvrez la fiche d\'un animal pour voir tout son historique de photos, de la plus ancienne à la plus récente, avec le temps écoulé entre les ferrages et les notes de visite pour le contexte.';

  @override
  String get helpStepPhotos3 =>
      'Utilisez la vue de comparaison de photos pour placer deux photos de l\'historique d\'un animal côte à côte et suivre les progrès dans le temps.';

  @override
  String get helpStepPhotos4 =>
      'Ajoutez une légende à n\'importe quelle photo pour vous rappeler ce qu\'elle montre.';

  @override
  String get helpSectionFindingTitle => 'Retrouver des informations';

  @override
  String get helpStepFinding1 =>
      'Utilisez le champ de recherche du sélecteur de client pour trouver rapidement un client par nom ou adresse.';

  @override
  String get helpStepFinding2 =>
      'L\'écran de liste des animaux affiche tous les animaux de tous les clients au même endroit.';

  @override
  String get helpStepFinding3 =>
      'Les badges de dernière visite sur les listes de clients et d\'animaux indiquent depuis combien de temps a eu lieu leur dernier rendez-vous.';

  @override
  String get helpStepFinding4 =>
      'L\'écran de tournée du jour liste les visites du jour dans l\'ordre pour planifier votre itinéraire.';

  @override
  String get helpSectionBackupsTitle => 'Sauvegardes';

  @override
  String get helpStepBackups1 =>
      'Allez dans Paramètres et touchez « Créer une sauvegarde » pour enregistrer une archive zip complète de vos données et photos, prête à partager ou à ranger en lieu sûr.';

  @override
  String get helpStepBackups2 =>
      'Sauvegardez régulièrement, surtout avant de changer d\'appareil ou d\'effacer le stockage de l\'application.';

  @override
  String get helpStepBackups3 =>
      'Touchez « Restaurer une sauvegarde » et choisissez un fichier zip de sauvegarde à restaurer — cela remplace toutes les données actuelles de l\'appareil, alors assurez-vous de vouloir les écraser.';

  @override
  String get helpStepBackups4 =>
      'Utilisez « Exporter les données » pour obtenir un export CSV des clients, animaux, visites, lignes de service et résumés de factures — pratique pour les tableurs ou les logiciels de comptabilité.';

  @override
  String get helpSectionOfflineTitle => 'Travailler hors ligne';

  @override
  String get helpStepOffline1 =>
      'FarrierLog stocke tout localement sur votre appareil — aucun compte, synchronisation infonuagique ou connexion internet n\'est requis.';

  @override
  String get helpStepOffline2 =>
      'Vous pouvez ajouter des clients, planifier des visites, prendre des photos et générer des factures partout, avec ou sans signal.';

  @override
  String get helpStepOffline3 =>
      'Comme il n\'y a pas de copie infonuagique, vos sauvegardes sont le seul moyen de transférer les données vers un nouvel appareil ou de récupérer après une perte de données — sauvegardez avant d\'en avoir besoin.';

  @override
  String get helpStepOffline4 =>
      'Partager une facture, une sauvegarde ou un export utilise les options de partage habituelles de votre appareil (e-mail, messagerie, stockage infonuagique), qui nécessitent bien une connexion à ce moment-là.';

  @override
  String get skipButton => 'Passer';

  @override
  String get onboardingWelcomeBody =>
      'FarrierLog vous aide à gérer votre entreprise depuis votre téléphone — clients, planification, facturation et photos. Entièrement hors ligne. Sans abonnement.';

  @override
  String get getStartedButton => 'Commencer';

  @override
  String get addBusinessDetailsTitle =>
      'Ajoutez les informations de votre entreprise';

  @override
  String get addBusinessDetailsBody =>
      'Elles apparaissent sur vos factures. Vous pourrez toujours les modifier plus tard dans Paramètres.';

  @override
  String get businessNameLabel => 'Nom de l\'entreprise';

  @override
  String get emailOptionalLabel => 'E-mail (facultatif)';

  @override
  String get continueButton => 'Continuer';

  @override
  String get skipForNow => 'Passer pour l\'instant';

  @override
  String get allSetTitle => 'Tout est prêt !';

  @override
  String get addFirstClientBody =>
      'Ajoutez votre premier client pour commencer.';

  @override
  String get addFirstClientButton => 'Ajouter le premier client';

  @override
  String get illDoItLater => 'Je le ferai plus tard';

  @override
  String get invoiceHistoryTitle => 'Historique des factures';

  @override
  String get clearFiltersTooltip => 'Effacer les filtres';

  @override
  String get exportCsvTooltip => 'Exporter en CSV';

  @override
  String exportFailedSnackbar(String error) {
    return 'Échec de l\'export : $error';
  }

  @override
  String get noPdfFoundSnackbar =>
      'Aucun fichier PDF trouvé pour cette facture';

  @override
  String pdfNotFoundSnackbar(String path) {
    return 'Fichier PDF introuvable : $path';
  }

  @override
  String get shareInvoiceOnlyTitle =>
      'Partager seulement la facture (sans photos)';

  @override
  String get shareInvoiceOnlySubtitle =>
      'Facture épurée — idéale pour les clients et la comptabilité';

  @override
  String get shareInvoicePhotosTitle => 'Partager la facture + les photos';

  @override
  String get shareInvoicePhotosSubtitle =>
      'Document complet avec photos justificatives';

  @override
  String errorSharingInvoiceSnackbar(String error) {
    return 'Erreur lors du partage de la facture : $error';
  }

  @override
  String fromDateLabel(String date) {
    return 'Du : $date';
  }

  @override
  String get fromDatePlaceholder => 'Date de début';

  @override
  String toDateLabel(String date) {
    return 'Au : $date';
  }

  @override
  String get toDatePlaceholder => 'Date de fin';

  @override
  String get clientDropdownLabel => 'Client';

  @override
  String get allClientsOption => 'Tous les clients';

  @override
  String invoiceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count factures',
      one: '$count facture',
    );
    return '$_temp0';
  }

  @override
  String get noInvoicesFound => 'Aucune facture trouvée';

  @override
  String get paidLabel => 'Payée';

  @override
  String get unpaidLabel => 'Impayée';

  @override
  String invoiceNumberSubject(String number) {
    return 'Facture $number';
  }

  @override
  String get exportCsvShareSubject => 'Export de l\'historique des factures';

  @override
  String get exportCsvShareText => 'Export CSV de l\'historique des factures';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get helpGuideTitle => 'Aide et guide';

  @override
  String get helpGuideSubtitle => 'Comment utiliser FarrierLog';

  @override
  String get colorLabel => 'Couleur';

  @override
  String get companyInfoTitle => 'Informations sur l\'entreprise';

  @override
  String get appearsOnInvoices => 'Apparaît sur les factures';

  @override
  String get uploadLogoButton => 'Ajouter un logo';

  @override
  String get companyNameLabel => 'Nom de l\'entreprise';

  @override
  String get currencyUnitsTitle => 'Devise et unités';

  @override
  String get currencyLabel => 'Devise';

  @override
  String get currencyUsd => '\$ — dollar américain';

  @override
  String get currencyEur => '€ — euro';

  @override
  String get currencyGbp => '£ — livre sterling';

  @override
  String get currencyJpy => '¥ — yen / yuan';

  @override
  String get currencyInr => '₹ — roupie';

  @override
  String get currencyCad => 'CAD\$ — dollar canadien';

  @override
  String get currencyAud => 'AUD\$ — dollar australien';

  @override
  String get currencyNzd => 'NZD\$ — dollar néo-zélandais';

  @override
  String get currencyZar => 'R — rand sud-africain';

  @override
  String get currencyCustomOption => 'Personnalisée...';

  @override
  String get customCurrencySymbolLabel => 'Symbole de devise personnalisé';

  @override
  String get customCurrencySymbolHint => 'p. ex. CHF, kr, RM';

  @override
  String get distanceUnitLabel => 'Unité de distance';

  @override
  String get distanceMiles => 'Milles (mi)';

  @override
  String get distanceKm => 'Kilomètres (km)';

  @override
  String get mileageTitle => 'Kilométrage';

  @override
  String get mileageSubtitle =>
      'Tarif par défaut utilisé pour les frais de kilométrage ou de transport';

  @override
  String mileageRateLabel(String unit) {
    return 'Tarif (par $unit)';
  }

  @override
  String get startWeekMondaySwitch =>
      'Commencer la semaine du calendrier le lundi';

  @override
  String get reminderMessageTitle => 'Message de rappel';

  @override
  String get reminderTemplateLabel => 'Modèle de rappel SMS';

  @override
  String reminderTemplateHelp(String token1, String token2, String token3) {
    return 'Utilisez « $token1 », « $token2 » et « $token3 » — ils seront remplis automatiquement.';
  }

  @override
  String get saveSettingsButton => 'Enregistrer les paramètres';

  @override
  String get settingsSavedSnackbar => 'Paramètres enregistrés !';

  @override
  String get serviceTemplatesTitle => 'Modèles de service';

  @override
  String get addTemplateTooltip => 'Ajouter un modèle';

  @override
  String get noSavedTemplates => 'Aucun modèle enregistré pour l\'instant';

  @override
  String get exportDataButton => 'Exporter les données';

  @override
  String get exportingButton => 'Exportation en cours...';

  @override
  String backupFailedSnackbar(String error) {
    return 'Échec de la sauvegarde : $error';
  }

  @override
  String get createBackupButton => 'Créer une sauvegarde';

  @override
  String get creatingBackupButton => 'Création de la sauvegarde...';

  @override
  String get restoreBackupButton => 'Restaurer une sauvegarde';

  @override
  String get restoringButton => 'Restauration en cours...';

  @override
  String get restoreBackupTitle => 'Restaurer la sauvegarde ?';

  @override
  String get restoreBackupMessage =>
      'Cela remplacera toutes les données FarrierLog actuelles sur cet appareil.';

  @override
  String get restoreButton => 'Restaurer';

  @override
  String restoreFailedSnackbar(String error) {
    return 'Échec de la restauration : $error';
  }

  @override
  String get backupRestoredSnackbar => 'Sauvegarde restaurée.';

  @override
  String get newServiceTemplateTitle => 'Nouveau modèle de service';

  @override
  String get serviceLabel => 'Service';

  @override
  String get priceLabel => 'Prix';

  @override
  String get showWelcomeGuideAgain => 'Réafficher le guide de bienvenue';

  @override
  String get languageLabel => 'Langue';

  @override
  String get languageSystemDefault => 'Système par défaut';

  @override
  String get remindTomorrowTooltip => 'Rappeler aux clients de demain';

  @override
  String get noAddressesSnackbar =>
      'Aucune adresse enregistrée pour les visites d\'aujourd\'hui';

  @override
  String get noVisitsWithPhoneSnackbar =>
      'Aucune visite avec un numéro de téléphone demain';

  @override
  String get tomorrowsRemindersTitle => 'Rappels de demain';

  @override
  String get sendButton => 'Envoyer';

  @override
  String get noVisitsScheduledToday => 'Aucune visite prévue aujourd\'hui';

  @override
  String get enjoyDayOffSubtitle =>
      'Profitez de votre jour de congé, ou planifiez une visite.';

  @override
  String visitsTodayCount(int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total visites aujourd\'hui',
      one: '$total visite aujourd\'hui',
    );
    return '$_temp0';
  }

  @override
  String missingAddressCount(int missing) {
    String _temp0 = intl.Intl.pluralLogic(
      missing,
      locale: localeName,
      other: '$missing adresses manquantes',
      one: '$missing adresse manquante',
    );
    return '$_temp0';
  }

  @override
  String get navigateTooltip => 'Naviguer';

  @override
  String get noAddressOnFile => 'Aucune adresse enregistrée';

  @override
  String get openFullRouteButton => 'Ouvrir l\'itinéraire complet';

  @override
  String get photoComparisonTitle => 'Comparaison de photos';

  @override
  String get swapPhotosTooltip => 'Permuter les photos';

  @override
  String elapsedBetweenVisits(String elapsed) {
    return '$elapsed entre ces visites';
  }

  @override
  String elapsedDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days jours',
      one: '$days jour',
    );
    return '$_temp0';
  }

  @override
  String elapsedWeeks(int weeks) {
    String _temp0 = intl.Intl.pluralLogic(
      weeks,
      locale: localeName,
      other: '$weeks semaines',
      one: '$weeks semaine',
    );
    return '$_temp0';
  }

  @override
  String get beforeLabel => 'AVANT';

  @override
  String get afterLabel => 'APRÈS';

  @override
  String get animalTitle => 'Animal';

  @override
  String get progressReportTooltip => 'Rapport de progression';

  @override
  String progressReportSubject(String name) {
    return '$name — Rapport de progression';
  }

  @override
  String get photoDefaultTitle => 'Photo';

  @override
  String get ownerLabel => 'Propriétaire';

  @override
  String get noVisitsRecordedForAnimal =>
      'Aucune visite enregistrée pour cet animal pour l\'instant.';

  @override
  String get noPhotosForAnimal =>
      'Aucune photo associée à cet animal pour l\'instant.';

  @override
  String get compareButton => 'Comparer';

  @override
  String get openVisitButton => 'Ouvrir la visite';

  @override
  String daysSinceLastVisit(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days jours depuis la dernière visite',
      one: '$days jour depuis la dernière visite',
    );
    return '$_temp0';
  }

  @override
  String weeksSinceLastShoeing(int weeks) {
    String _temp0 = intl.Intl.pluralLogic(
      weeks,
      locale: localeName,
      other: '$weeks semaines depuis le dernier ferrage',
      one: '$weeks semaine depuis le dernier ferrage',
    );
    return '$_temp0';
  }

  @override
  String visitHistoryTitle(int count) {
    return 'Historique des visites ($count)';
  }

  @override
  String get photoHistoryTitle => 'Historique des photos';

  @override
  String get visitTitle => 'Visite';

  @override
  String get deleteServiceLineTitle => 'Supprimer la ligne de service';

  @override
  String get deleteChargeTitle => 'Supprimer le frais';

  @override
  String removeQuotedItem(String name) {
    return 'Supprimer « $name » ?';
  }

  @override
  String get takeAPhoto => 'Prendre une photo';

  @override
  String get chooseFromCameraRoll => 'Choisir dans la pellicule';

  @override
  String get photoDetailsTitle => 'Détails de la photo';

  @override
  String get tagToAnimalsLabel => 'Associer à l\'animal / aux animaux :';

  @override
  String get captionLabel => 'Légende';

  @override
  String get includeOnInvoiceSwitch => 'Inclure sur la facture';

  @override
  String addPhotosCountTitle(int count) {
    return 'Ajouter $count photos';
  }

  @override
  String photosSelectedFromGallery(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count photos sélectionnées dans la galerie',
      one: '$count photo sélectionnée dans la galerie',
    );
    return '$_temp0';
  }

  @override
  String get tagAllToAnimalsLabel =>
      'Tout associer à l\'animal / aux animaux :';

  @override
  String get captionAllPhotosLabel => 'Légende (toutes les photos)';

  @override
  String get saveAllButton => 'Tout enregistrer';

  @override
  String get deletePhotoTitle => 'Supprimer la photo';

  @override
  String get removePhotoMessage => 'Supprimer cette photo ?';

  @override
  String get viewShareInvoiceTitle => 'Afficher / partager la facture';

  @override
  String get regenerateInvoiceTitle => 'Régénérer la facture';

  @override
  String get regenerateInvoiceSubtitle =>
      'Supprimer l\'actuelle et en générer une nouvelle';

  @override
  String invoiceSubjectFor(String name) {
    return 'Facture pour $name';
  }

  @override
  String get shareInvoicePdfTitle => 'Partager la facture (PDF)';

  @override
  String get shareInvoicePdfSubtitle =>
      'Envoyer via n\'importe quelle appli - Gmail, WhatsApp, etc.';

  @override
  String get printInvoiceTitle => 'Imprimer la facture';

  @override
  String errorGeneratingInvoiceSnackbar(String error) {
    return 'Erreur lors de la génération de la facture : $error';
  }

  @override
  String get regenerateInvoiceConfirmTitle => 'Régénérer la facture ?';

  @override
  String get regenerateInvoiceConfirmMessage =>
      'Cela supprimera la facture actuelle et en générera une nouvelle à partir des lignes de service et frais actuels.';

  @override
  String get regenerateButton => 'Régénérer';

  @override
  String invoicePdfNotFoundSnackbar(String name) {
    return 'PDF de facture introuvable : $name';
  }

  @override
  String get deleteVisitTitle => 'Supprimer la visite';

  @override
  String get deleteVisitConfirmMessage =>
      'Voulez-vous vraiment supprimer cette visite ?';

  @override
  String get couldNotOpenMapsSnackbar => 'Impossible d\'ouvrir Google Maps';

  @override
  String calendarEventTitle(String name) {
    return 'Maréchal-ferrant - $name';
  }

  @override
  String get calendarEventDefaultDescription => 'Visite du maréchal-ferrant';

  @override
  String get calendarEventNotAddedSnackbar =>
      'Impossible d\'ajouter l\'événement au calendrier.';

  @override
  String calendarEventErrorSnackbar(String error) {
    return 'Impossible d\'ajouter l\'événement au calendrier : $error';
  }

  @override
  String get noPhoneForClientSnackbar =>
      'Aucun numéro de téléphone enregistré pour ce client.';

  @override
  String get couldNotOpenSmsSnackbar =>
      'Impossible d\'ouvrir l\'application SMS.';

  @override
  String get noSavedNotesSnackbar =>
      'Aucune note enregistrée trouvée pour ce client ou ses animaux.';

  @override
  String get insertFromNotesTitle => 'Insérer depuis les notes';

  @override
  String clientNotesHeader(String name) {
    return '📋 Client — $name';
  }

  @override
  String animalNotesHeader(String name) {
    return '🐾 $name';
  }

  @override
  String get insertButton => '+ Insérer';

  @override
  String get noAddressSaved => 'Aucune adresse enregistrée';

  @override
  String get appointmentAddressTitle => 'Adresse du rendez-vous';

  @override
  String get openInGoogleMaps => 'Ouvrir dans Google Maps';

  @override
  String get editVisitMenuItem => 'Modifier la visite';

  @override
  String get deleteVisitMenuItem => 'Supprimer la visite';

  @override
  String invoiceNotesPrefix(String notes) {
    return 'Notes de facture : $notes';
  }

  @override
  String get addToPhoneCalendarButton => 'Ajouter au calendrier du téléphone';

  @override
  String get sendReminderButton => 'Envoyer un rappel';

  @override
  String get confirmAppointmentButton => 'Confirmer ce rendez-vous';

  @override
  String get visitCompletedSwitch => 'Visite terminée';

  @override
  String get paymentReceivedSwitch => 'Paiement reçu';

  @override
  String animalsCountTitle(int count) {
    return 'Animaux ($count)';
  }

  @override
  String get noAnimalsForVisit => 'Aucun animal sélectionné pour cette visite';

  @override
  String get billingTitle => 'Facturation';

  @override
  String get addServiceLineLabel => 'Ajouter une ligne de service';

  @override
  String get noServiceLinesYet => 'Aucune ligne de service pour l\'instant';

  @override
  String get travelIncidentalsTitle => 'Déplacements et frais divers';

  @override
  String get addChargeLabel => 'Ajouter un frais';

  @override
  String get noChargesYet =>
      'Aucun frais de déplacement ou divers pour l\'instant';

  @override
  String servicesAndTravelSummary(String services, String travel) {
    return 'Services : $services · Déplacements et frais divers : $travel';
  }

  @override
  String get totalLabelPlain => 'Total';

  @override
  String get invoiceNotesLabel => 'Notes de facture';

  @override
  String get invoiceNotesHint => 'Imprimé sur la facture...';

  @override
  String get insertFromSavedNotesTooltip =>
      'Insérer depuis les notes enregistrées';

  @override
  String get generateInvoiceButton => 'Générer la facture';

  @override
  String get createInvoiceButton => 'Créer la facture';

  @override
  String get addServiceLinesBeforeInvoice =>
      'Ajoutez des lignes de service ou des frais avant de créer une facture';

  @override
  String get paidInFull => 'Payée intégralement';

  @override
  String photosCountTitle(int count) {
    return 'Photos ($count)';
  }

  @override
  String get addPhotoLabel => 'Ajouter une photo';

  @override
  String get noPhotosYet => 'Aucune photo pour l\'instant';

  @override
  String get generateInvoiceTooltip => 'Générer la facture';

  @override
  String get regenerateInvoiceTooltip => 'Régénérer la facture';

  @override
  String get editVisitTitle => 'Modifier la visite';

  @override
  String get newVisitTitle => 'Nouvelle visite';

  @override
  String get pleaseSelectClient => 'Veuillez sélectionner un client';

  @override
  String get searchForClientPlaceholder => 'Rechercher un client...';

  @override
  String get dateLabel => 'Date';

  @override
  String get timeLabel => 'Heure';

  @override
  String get recurringLabel => 'Récurrence';

  @override
  String get recurrenceEvery4 => 'Toutes les 4 semaines';

  @override
  String get recurrenceEvery6 => 'Toutes les 6 semaines';

  @override
  String get recurrenceEvery8 => 'Toutes les 8 semaines';

  @override
  String get recurrenceEvery10 => 'Toutes les 10 semaines';

  @override
  String get recurrenceCustom => 'Semaines personnalisées';

  @override
  String get customWeeksLabel => 'Semaines personnalisées';

  @override
  String get customWeeksMustBeGreaterThanZero =>
      'Le nombre de semaines personnalisé doit être supérieur à 0';

  @override
  String get selectAnimalsLabel => 'Sélectionner les animaux';

  @override
  String get noAnimalsForClient => 'Ce client n\'a aucun animal';

  @override
  String get groupServiceHint =>
      'Pas besoin de suivre les animaux individuellement pour cet arrêt ? Ajoutez une ligne de service de groupe depuis l\'écran de la visite après l\'enregistrement.';

  @override
  String get invoiceNotesHintNewVisit =>
      'Imprimé sur la facture — services, corrections, notes particulières...';

  @override
  String get updateVisitButton => 'Mettre à jour la visite';

  @override
  String get saveVisitButton => 'Enregistrer la visite';

  @override
  String get searchClientsHint => 'Rechercher des clients...';

  @override
  String get noClientsFound => 'Aucun client trouvé';

  @override
  String clientDetailDeleteMessage(String name) {
    return 'Voulez-vous vraiment supprimer $name ? Cela supprimera aussi toutes les visites, tous les animaux et toutes les photos associés.';
  }

  @override
  String get deleteAnimalTitle => 'Supprimer l\'animal';

  @override
  String deleteAnimalConfirmMessage(String name) {
    return 'Voulez-vous vraiment supprimer $name ?';
  }

  @override
  String deleteVisitConfirmMessageWithDate(String date) {
    return 'Supprimer la visite du $date ?';
  }

  @override
  String get scheduleVisitButton => 'Planifier une visite';

  @override
  String get tapToCallLongPressText =>
      'Touchez pour appeler • Maintenez pour envoyer un SMS';

  @override
  String get tapToEmail => 'Touchez pour envoyer un e-mail';

  @override
  String get openInMaps => 'Ouvrir dans le plan';

  @override
  String notesLabel(String notes) {
    return 'Notes : $notes';
  }

  @override
  String get privateStaffNotesTitle => 'Notes privées du personnel';

  @override
  String get addAnimalLabel => 'Ajouter un animal';

  @override
  String get noAnimalsAddedYet => 'Aucun animal ajouté pour l\'instant';

  @override
  String visitsCountHeader(int count) {
    return 'Visites ($count)';
  }

  @override
  String get noVisitsYet => 'Aucune visite pour l\'instant';

  @override
  String get editAnimalTitle => 'Modifier l\'animal';

  @override
  String get newAnimalTitle => 'Nouvel animal';

  @override
  String get speciesLabel => 'Espèce';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get animalNotesLabel => 'Notes de l\'animal (privées)';

  @override
  String get animalNotesHint =>
      'Antécédents de santé, comportement, notes de manipulation...';

  @override
  String get internalNotesHintAnimal =>
      'Observations privées du personnel — jamais sur la facture';

  @override
  String get editServiceLineTitle => 'Modifier la ligne de service';

  @override
  String get addServiceLineTitle => 'Ajouter une ligne de service';

  @override
  String get savedTemplatesLabel => 'Modèles enregistrés';

  @override
  String get singleAnimalOption => 'Animal unique';

  @override
  String get groupHeadcountOption => 'Groupe / au nombre d\'animaux';

  @override
  String get animalDropdownLabel => 'Animal';

  @override
  String get groupDescriptionLabel => 'Description du groupe';

  @override
  String get groupDescriptionHint =>
      'p. ex. Troupeau du pâturage arrière, Ranch Smith';

  @override
  String get numberOfAnimalsLabel => 'Nombre d\'animaux';

  @override
  String get enterWholeNumber => 'Saisissez un nombre entier de 1 ou plus';

  @override
  String get pricePerAnimalLabel => 'Prix par animal';

  @override
  String get saveAsTemplateButton => 'Enregistrer comme modèle';

  @override
  String get enterDescriptionFirstSnackbar =>
      'Saisissez d\'abord une description';

  @override
  String templateSavedSnackbar(String description) {
    return '« $description » enregistré comme modèle';
  }

  @override
  String get editChargeTitle => 'Modifier le frais';

  @override
  String get addChargeTitle => 'Ajouter un frais';

  @override
  String get typeLabel => 'Type';

  @override
  String distanceLabelWithUnit(String unit) {
    return 'Distance ($unit)';
  }

  @override
  String get enterNumberZeroOrMore =>
      'Saisissez un nombre supérieur ou égal à 0';

  @override
  String ratePerUnitLabel(String unit) {
    return 'Tarif par $unit';
  }

  @override
  String get amountLabel => 'Montant';

  @override
  String get invalidNumber => 'Nombre non valide';

  @override
  String get chargeTypeMileage => 'Kilométrage';

  @override
  String get chargeTypeTolls => 'Péages';

  @override
  String get chargeTypeReimbursement => 'Remboursement';

  @override
  String get chargeTypeTransport => 'Transport';

  @override
  String get chargeTypeOther => 'Autre';

  @override
  String get statusProjected => 'Projetée';

  @override
  String get statusPaid => 'Payée';

  @override
  String get statusOverdue => 'En retard';

  @override
  String get statusToday => 'Aujourd\'hui';

  @override
  String get statusUpcoming => 'À venir';

  @override
  String get badgeScheduled => 'Planifiée';

  @override
  String get badgeNoVisitsYet => 'Aucune visite pour l\'instant';

  @override
  String badgeWeeksAgo(int weeks) {
    String _temp0 = intl.Intl.pluralLogic(
      weeks,
      locale: localeName,
      other: 'il y a $weeks sem',
      one: 'il y a $weeks sem',
    );
    return '$_temp0';
  }
}
