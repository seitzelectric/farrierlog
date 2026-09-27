// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get cancel => 'Cancelar';

  @override
  String get add => 'Agregar';

  @override
  String get save => 'Guardar';

  @override
  String get delete => 'Eliminar';

  @override
  String get edit => 'Editar';

  @override
  String get update => 'Actualizar';

  @override
  String get view => 'Ver';

  @override
  String get share => 'Compartir';

  @override
  String get print => 'Imprimir';

  @override
  String get confirm => 'Confirmar';

  @override
  String get requiredField => 'Obligatorio';

  @override
  String get generalLabel => 'General';

  @override
  String get groupLabelFallback => 'Grupo';

  @override
  String groupAnimalCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '× $count animales',
      one: '× 1 animal',
    );
    return '$_temp0';
  }

  @override
  String get noneLabel => 'Ninguno';

  @override
  String totalLabel(String amount) {
    return 'Total: $amount';
  }

  @override
  String get navClients => 'Clientes';

  @override
  String get navCalendar => 'Calendario';

  @override
  String get navDashboard => 'Panel';

  @override
  String get navInvoices => 'Facturas';

  @override
  String get navAnimals => 'Animales';

  @override
  String get deleteClientTitle => 'Eliminar cliente';

  @override
  String get noContactInfo => 'Sin datos de contacto';

  @override
  String get noClientsYet => 'Aún no hay clientes';

  @override
  String get addFirstClientSubtitle => 'Agrega tu primer cliente para comenzar';

  @override
  String get addClientButton => 'Agregar cliente';

  @override
  String clientListDeleteMessage(String name) {
    return '¿Eliminar a $name? Esto también eliminará todas las visitas, animales y fotos asociados.';
  }

  @override
  String get editClientTitle => 'Editar cliente';

  @override
  String get addClientTitle => 'Agregar cliente';

  @override
  String get nameLabel => 'Nombre';

  @override
  String get firstNameLabel => 'Nombre';

  @override
  String get lastNameLabel => 'Apellido';

  @override
  String get phoneLabel => 'Teléfono';

  @override
  String get emailLabel => 'Correo electrónico';

  @override
  String get addressLabel => 'Dirección';

  @override
  String get clientNotesLabel =>
      'Notas del cliente (privadas — no aparecen en la factura)';

  @override
  String get clientNotesHint =>
      'Códigos de acceso, preferencias de pago, notas de seguridad...';

  @override
  String get internalNotesLabel => 'Notas internas (solo para el personal)';

  @override
  String get internalNotesHintClient =>
      'Observaciones, advertencias — nunca se muestran al cliente ni en la factura';

  @override
  String get animalsTitle => 'Animales';

  @override
  String get searchAnimalsHint => 'Buscar por nombre de animal o cliente...';

  @override
  String animalCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count animales',
      one: '1 animal',
    );
    return '$_temp0';
  }

  @override
  String get noAnimalsYet => 'Aún no hay animales';

  @override
  String noAnimalsMatch(String query) {
    return 'Ningún animal coincide con \"$query\"';
  }

  @override
  String get calendarTitle => 'Calendario';

  @override
  String get appointmentConfirmedSnackbar => 'Cita confirmada';

  @override
  String get recurringVisitTitle => 'Visita recurrente';

  @override
  String get scheduleNextRecurringVisit =>
      '¿Programar la siguiente visita recurrente?';

  @override
  String noVisitsOnDate(String date) {
    return 'No hay visitas el $date';
  }

  @override
  String get newAppointmentButton => 'Nueva cita';

  @override
  String get dashListTitleClients => 'Clientes';

  @override
  String get dashListTitleAnimals => 'Animales';

  @override
  String get dashListTitleUpcoming => 'Próximas visitas';

  @override
  String get dashListTitlePastDue => 'Visitas atrasadas';

  @override
  String get dashListTitleOutstanding => 'Visitas pendientes de pago';

  @override
  String get dashListTitlePaid => 'Visitas pagadas';

  @override
  String get dashEmptyUpcomingTitle => 'No hay próximas visitas';

  @override
  String get dashEmptyPastDueTitle => 'No hay visitas atrasadas';

  @override
  String get dashEmptyOutstandingTitle => 'No hay visitas pendientes de pago';

  @override
  String get dashEmptyPaidTitle => 'Aún no hay visitas pagadas';

  @override
  String get dashEmptyClientsSubtitle =>
      'Agrega clientes desde la pestaña Clientes.';

  @override
  String get dashEmptyAnimalsSubtitle =>
      'Los animales aparecerán aquí una vez agregados a los clientes.';

  @override
  String get dashEmptyUpcomingSubtitle =>
      'No hay visitas programadas en los próximos 30 días.';

  @override
  String get dashEmptyPastDueSubtitle =>
      'Todas las visitas están marcadas como completadas.';

  @override
  String get dashEmptyOutstandingSubtitle =>
      'Todas las visitas completadas han sido pagadas.';

  @override
  String get dashEmptyPaidSubtitle =>
      'Las visitas pagadas aparecerán aquí una vez que las facturas o visitas se marquen como pagadas.';

  @override
  String get dashboardTitle => 'Panel';

  @override
  String get todaysRouteTitle => 'Ruta de hoy';

  @override
  String get todaysRouteSubtitle =>
      'Consulta todas las paradas de hoy en orden';

  @override
  String get statTotalClients => 'Total de clientes';

  @override
  String get statTotalAnimals => 'Total de animales';

  @override
  String get statUpcoming => 'Próximas';

  @override
  String get statPastDue => 'Atrasadas';

  @override
  String get statTotalRevenue => 'Ingresos totales';

  @override
  String get statOutstanding => 'Pendiente';

  @override
  String get milesDrivenTitle => 'Distancia recorrida';

  @override
  String get thisMonth => 'Este mes';

  @override
  String get thisYear => 'Este año';

  @override
  String get revenueTrendTitle => 'Tendencia de ingresos (12 meses)';

  @override
  String get next7DaysTitle => 'Próximos 7 días';

  @override
  String get newVisitLabel => 'Nueva visita';

  @override
  String get noUpcomingVisitsThisWeek => 'No hay próximas visitas esta semana';

  @override
  String get helpTitle => 'Ayuda y guía';

  @override
  String get welcomeToFarrierLog => 'Bienvenido a FarrierLog';

  @override
  String get helpIntro =>
      'Esta guía recorre todo lo que FarrierLog puede hacer, desde agregar tu primer cliente hasta respaldar tus datos. Toca una sección para expandirla.';

  @override
  String get helpSectionGettingStartedTitle => 'Primeros pasos';

  @override
  String get helpStepGettingStarted1 =>
      'Abre Configuración e ingresa el nombre, dirección, teléfono y correo de tu empresa — esto aparece en cada factura que envíes.';

  @override
  String get helpStepGettingStarted2 =>
      'Elige un tema de color y define tu moneda y unidad de distancia preferidas.';

  @override
  String get helpStepGettingStarted3 =>
      'Agrega tu primer cliente desde la pestaña Clientes y luego agrega sus animales.';

  @override
  String get helpStepGettingStarted4 =>
      'Programa una visita desde la página del cliente o con el botón de nueva cita del calendario.';

  @override
  String get helpSectionClientsAnimalsTitle => 'Clientes y animales';

  @override
  String get helpStepClientsAnimals1 =>
      'Ve a la pestaña Clientes y toca el botón de agregar para crear un nuevo cliente con sus datos de contacto y dirección.';

  @override
  String get helpStepClientsAnimals2 =>
      'Abre la página de un cliente y toca \"Agregar animal\" para añadir cada caballo u otro animal que atiendes.';

  @override
  String get helpStepClientsAnimals3 =>
      'Toca el teléfono de un cliente para llamar, o mantén presionado para enviar un mensaje.';

  @override
  String get helpStepClientsAnimals4 =>
      'Toca la dirección de un cliente para abrirla en el mapa y obtener indicaciones.';

  @override
  String get helpStepClientsAnimals5 =>
      'Usa \"Notas internas\" en un cliente o animal para notas privadas del personal — estas nunca aparecen en las facturas.';

  @override
  String get helpStepClientsAnimals6 =>
      'Desliza a la izquierda sobre un cliente o animal para eliminarlo. Eliminar un cliente también elimina sus animales, visitas y fotos.';

  @override
  String get helpSectionSchedulingTitle => 'Programar visitas';

  @override
  String get helpStepScheduling1 =>
      'Toca la pestaña del calendario para ver todas las visitas pasadas y futuras — los marcadores sólidos están confirmados, los marcadores con borde son proyecciones automáticas.';

  @override
  String get helpStepScheduling2 =>
      'Toca el botón de nueva cita en el calendario para programar una visita en una fecha específica.';

  @override
  String get helpStepScheduling3 =>
      'Busca un cliente por nombre o dirección en lugar de desplazarte por una lista larga.';

  @override
  String get helpStepScheduling4 =>
      'Define un intervalo de recurrencia (en semanas) en una visita para proyectar automáticamente la siguiente cita al confirmar la actual.';

  @override
  String get helpStepScheduling5 =>
      'Confirmar una visita generada automáticamente crea la siguiente visita proyectada en la cadena — las visitas futuras no se crean todas a la vez.';

  @override
  String get helpSectionInvoicingTitle => 'Servicios, cargos y facturación';

  @override
  String get helpStepInvoicing1 =>
      'Abre una visita y agrega líneas de servicio para cada animal — ingresa una descripción y un precio, o factura por cantidad de animales para servicios grupales.';

  @override
  String get helpStepInvoicing2 =>
      'Guarda los servicios más usados como plantillas en Configuración para agregarlos con un toque la próxima vez.';

  @override
  String get helpStepInvoicing3 =>
      'Agrega cargos de viaje e imprevistos (kilometraje, peajes, reembolsos) por separado de las líneas de servicio.';

  @override
  String get helpStepInvoicing4 =>
      'Define tu tarifa de kilometraje predeterminada en Configuración para que se complete automáticamente cada vez que agregues un cargo de viaje.';

  @override
  String get helpStepInvoicing5 =>
      'Cuando una visita esté completa, genera el PDF de la factura y luego imprímelo o compártelo directamente desde la visita.';

  @override
  String get helpSectionGettingPaidTitle => 'Cobrar';

  @override
  String get helpStepGettingPaid1 =>
      'Una visita tiene dos estados: completada (el trabajo está hecho) y pagada (se recibió el pago) — marca cada uno según ocurra.';

  @override
  String get helpStepGettingPaid2 =>
      'El panel muestra los ingresos ganados y proyectados para que veas de un vistazo lo pendiente.';

  @override
  String get helpStepGettingPaid3 =>
      'Usa la pantalla de historial de facturas para encontrar y volver a compartir cualquier factura anterior.';

  @override
  String get helpStepGettingPaid4 =>
      'Las visitas atrasadas y sin pagar se resaltan para que nada se te escape.';

  @override
  String get helpSectionPhotosTitle => 'Fotos';

  @override
  String get helpStepPhotos1 =>
      'Desde una visita, toma fotos y etiquétalas a uno o más animales usando las casillas — todos los animales de la visita están preseleccionados de forma predeterminada.';

  @override
  String get helpStepPhotos2 =>
      'Abre la página de un animal para ver su historial completo de fotos, de la más antigua a la más reciente, con el tiempo transcurrido entre herrajes y las notas de la visita como contexto.';

  @override
  String get helpStepPhotos3 =>
      'Usa la vista de comparación de fotos para colocar dos fotos del historial de un animal una junto a la otra y seguir el progreso con el tiempo.';

  @override
  String get helpStepPhotos4 =>
      'Agrega una descripción a cualquier foto para recordar qué muestra.';

  @override
  String get helpSectionFindingTitle => 'Encontrar información';

  @override
  String get helpStepFinding1 =>
      'Usa el campo de búsqueda del selector de clientes para encontrar un cliente rápidamente por nombre o dirección.';

  @override
  String get helpStepFinding2 =>
      'La pantalla de lista de animales muestra todos los animales de todos los clientes en un solo lugar.';

  @override
  String get helpStepFinding3 =>
      'Las insignias de última visita en las listas de clientes y animales muestran cuánto tiempo pasó desde su última cita.';

  @override
  String get helpStepFinding4 =>
      'La pantalla de ruta de hoy enumera las visitas del día en orden para que puedas planear tu recorrido.';

  @override
  String get helpSectionBackupsTitle => 'Copias de seguridad';

  @override
  String get helpStepBackups1 =>
      'Ve a Configuración y toca \"Crear copia de seguridad\" para guardar un archivo zip completo con tus datos y fotos, listo para compartir o guardar en un lugar seguro.';

  @override
  String get helpStepBackups2 =>
      'Haz copias de seguridad regularmente, especialmente antes de cambiar de dispositivo o borrar el almacenamiento de la app.';

  @override
  String get helpStepBackups3 =>
      'Toca \"Restaurar copia de seguridad\" y elige un archivo zip para restaurar — esto reemplaza todos los datos actuales del dispositivo, así que asegúrate de querer sobrescribirlos.';

  @override
  String get helpStepBackups4 =>
      'Usa \"Exportar datos\" para obtener una exportación CSV de clientes, animales, visitas, líneas de servicio y resúmenes de facturas — útil para hojas de cálculo o software de contabilidad.';

  @override
  String get helpSectionOfflineTitle => 'Trabajar sin conexión';

  @override
  String get helpStepOffline1 =>
      'FarrierLog guarda todo localmente en tu dispositivo — no se requiere cuenta, sincronización en la nube ni conexión a internet.';

  @override
  String get helpStepOffline2 =>
      'Puedes agregar clientes, programar visitas, tomar fotos y generar facturas en cualquier lugar, con o sin señal.';

  @override
  String get helpStepOffline3 =>
      'Como no hay copia en la nube, tus copias de seguridad son la única forma de trasladar datos a un nuevo dispositivo o recuperarte de una pérdida de datos — respalda antes de necesitarlo.';

  @override
  String get helpStepOffline4 =>
      'Compartir una factura, copia de seguridad o exportación usa las opciones normales para compartir de tu dispositivo (correo, mensajería, almacenamiento en la nube), que sí requieren conexión en ese momento.';

  @override
  String get skipButton => 'Omitir';

  @override
  String get onboardingWelcomeBody =>
      'FarrierLog te ayuda a administrar tu negocio desde el teléfono — clientes, programación, facturación y fotos. Totalmente sin conexión. Sin suscripciones.';

  @override
  String get getStartedButton => 'Comenzar';

  @override
  String get addBusinessDetailsTitle => 'Agrega los datos de tu empresa';

  @override
  String get addBusinessDetailsBody =>
      'Estos datos aparecen en tus facturas. Siempre puedes cambiarlos después en Configuración.';

  @override
  String get businessNameLabel => 'Nombre de la empresa';

  @override
  String get emailOptionalLabel => 'Correo electrónico (opcional)';

  @override
  String get continueButton => 'Continuar';

  @override
  String get skipForNow => 'Omitir por ahora';

  @override
  String get allSetTitle => '¡Todo listo!';

  @override
  String get addFirstClientBody => 'Agrega tu primer cliente para comenzar.';

  @override
  String get addFirstClientButton => 'Agregar primer cliente';

  @override
  String get illDoItLater => 'Lo haré más tarde';

  @override
  String get invoiceHistoryTitle => 'Historial de facturas';

  @override
  String get clearFiltersTooltip => 'Borrar filtros';

  @override
  String get exportCsvTooltip => 'Exportar CSV';

  @override
  String exportFailedSnackbar(String error) {
    return 'Error al exportar: $error';
  }

  @override
  String get noPdfFoundSnackbar => 'No se encontró el PDF de esta factura';

  @override
  String pdfNotFoundSnackbar(String path) {
    return 'No se encontró el archivo PDF: $path';
  }

  @override
  String get shareInvoiceOnlyTitle => 'Compartir solo la factura (sin fotos)';

  @override
  String get shareInvoiceOnlySubtitle =>
      'Factura limpia — ideal para clientes y contabilidad';

  @override
  String get shareInvoicePhotosTitle => 'Compartir factura + fotos';

  @override
  String get shareInvoicePhotosSubtitle =>
      'Documento completo con fotos de respaldo';

  @override
  String errorSharingInvoiceSnackbar(String error) {
    return 'Error al compartir la factura: $error';
  }

  @override
  String fromDateLabel(String date) {
    return 'Desde: $date';
  }

  @override
  String get fromDatePlaceholder => 'Fecha desde';

  @override
  String toDateLabel(String date) {
    return 'Hasta: $date';
  }

  @override
  String get toDatePlaceholder => 'Fecha hasta';

  @override
  String get clientDropdownLabel => 'Cliente';

  @override
  String get allClientsOption => 'Todos los clientes';

  @override
  String invoiceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count facturas',
      one: '1 factura',
    );
    return '$_temp0';
  }

  @override
  String get noInvoicesFound => 'No se encontraron facturas';

  @override
  String get paidLabel => 'Pagada';

  @override
  String get unpaidLabel => 'Sin pagar';

  @override
  String invoiceNumberSubject(String number) {
    return 'Factura $number';
  }

  @override
  String get exportCsvShareSubject => 'Exportación del historial de facturas';

  @override
  String get exportCsvShareText => 'Exportación CSV del historial de facturas';

  @override
  String get settingsTitle => 'Configuración';

  @override
  String get helpGuideTitle => 'Ayuda y guía';

  @override
  String get helpGuideSubtitle => 'Cómo usar FarrierLog';

  @override
  String get colorLabel => 'Color';

  @override
  String get companyInfoTitle => 'Información de la empresa';

  @override
  String get appearsOnInvoices => 'Aparece en las facturas';

  @override
  String get uploadLogoButton => 'Subir logotipo';

  @override
  String get companyNameLabel => 'Nombre de la empresa';

  @override
  String get currencyUnitsTitle => 'Moneda y unidades';

  @override
  String get currencyLabel => 'Moneda';

  @override
  String get currencyUsd => '\$ — dólar estadounidense';

  @override
  String get currencyEur => '€ — euro';

  @override
  String get currencyGbp => '£ — libra esterlina';

  @override
  String get currencyJpy => '¥ — yen / yuan';

  @override
  String get currencyInr => '₹ — rupia';

  @override
  String get currencyCad => 'CAD\$ — dólar canadiense';

  @override
  String get currencyAud => 'AUD\$ — dólar australiano';

  @override
  String get currencyNzd => 'NZD\$ — dólar neozelandés';

  @override
  String get currencyZar => 'R — rand sudafricano';

  @override
  String get currencyCustomOption => 'Personalizado...';

  @override
  String get customCurrencySymbolLabel => 'Símbolo de moneda personalizado';

  @override
  String get customCurrencySymbolHint => 'p. ej. CHF, kr, RM';

  @override
  String get distanceUnitLabel => 'Unidad de distancia';

  @override
  String get distanceMiles => 'Millas (mi)';

  @override
  String get distanceKm => 'Kilómetros (km)';

  @override
  String get mileageTitle => 'Kilometraje';

  @override
  String get mileageSubtitle =>
      'Tarifa predeterminada al agregar cargos de kilometraje o transporte';

  @override
  String mileageRateLabel(String unit) {
    return 'Tarifa (por $unit)';
  }

  @override
  String get startWeekMondaySwitch =>
      'Iniciar la semana del calendario en lunes';

  @override
  String get reminderMessageTitle => 'Mensaje de recordatorio';

  @override
  String get reminderTemplateLabel => 'Plantilla de recordatorio SMS';

  @override
  String reminderTemplateHelp(String token1, String token2, String token3) {
    return 'Usa \"$token1\", \"$token2\" y \"$token3\" — se completan automáticamente.';
  }

  @override
  String get saveSettingsButton => 'Guardar configuración';

  @override
  String get settingsSavedSnackbar => '¡Configuración guardada!';

  @override
  String get serviceTemplatesTitle => 'Plantillas de servicio';

  @override
  String get addTemplateTooltip => 'Agregar plantilla';

  @override
  String get noSavedTemplates => 'Aún no hay plantillas guardadas';

  @override
  String get exportDataButton => 'Exportar datos';

  @override
  String get exportingButton => 'Exportando...';

  @override
  String get importCalendarButton => 'Importar calendario (.ics)';

  @override
  String get importCalendarTitle => 'Importar calendario';

  @override
  String get noCalendarEventsFound =>
      'No se encontraron eventos de calendario en este archivo';

  @override
  String calendarFileReadFailed(String error) {
    return 'No se pudo leer el archivo de calendario: $error';
  }

  @override
  String get importSelectAll => 'Seleccionar todo';

  @override
  String get importDeselectAll => 'Deseleccionar todo';

  @override
  String importSelectedButton(int count) {
    return 'Importar seleccionados ($count)';
  }

  @override
  String get importAllDay => 'Todo el día';

  @override
  String get importSkipNoClient => 'Omitir — sin cliente';

  @override
  String get importCreateNewClient => 'Crear cliente nuevo a partir del evento';

  @override
  String get importDuplicateWarning =>
      'Este cliente ya tiene una visita a esta hora';

  @override
  String importRecurrenceWeeks(int weeks) {
    String _temp0 = intl.Intl.pluralLogic(
      weeks,
      locale: localeName,
      other:
          'Se repite cada $weeks semanas — se importa como visita recurrente',
      one: 'Se repite cada semana — se importa como visita recurrente',
    );
    return '$_temp0';
  }

  @override
  String get importRecurrenceUnsupported =>
      'Regla de repetición no compatible — se importa como visita única';

  @override
  String get importDuplicatesTitle => 'Posibles duplicados';

  @override
  String importDuplicatesMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count eventos seleccionados ya tienen una visita',
      one: '1 evento seleccionado ya tiene una visita',
    );
    return '$_temp0 para el mismo cliente a la misma hora. ¿Importar de todos modos?';
  }

  @override
  String get importAnywayButton => 'Importar de todos modos';

  @override
  String importedVisitsSnackbar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se importaron $count visitas',
      one: 'Se importó 1 visita',
    );
    return '$_temp0';
  }

  @override
  String importFilteredCount(int shown, int total) {
    return 'Mostrando $shown de $total eventos';
  }

  @override
  String get importFilterByDate => 'Filtrar por fecha';

  @override
  String get importNoEventsInRange =>
      'No hay eventos en el rango de fechas seleccionado';

  @override
  String backupFailedSnackbar(String error) {
    return 'Error al respaldar: $error';
  }

  @override
  String get createBackupButton => 'Crear copia de seguridad';

  @override
  String get creatingBackupButton => 'Creando copia de seguridad...';

  @override
  String get restoreBackupButton => 'Restaurar copia de seguridad';

  @override
  String get restoringButton => 'Restaurando...';

  @override
  String get restoreBackupTitle => '¿Restaurar copia de seguridad?';

  @override
  String get restoreBackupMessage =>
      'Esto reemplazará todos los datos actuales de FarrierLog en este dispositivo.';

  @override
  String get restoreButton => 'Restaurar';

  @override
  String restoreFailedSnackbar(String error) {
    return 'Error al restaurar: $error';
  }

  @override
  String get backupRestoredSnackbar => 'Copia de seguridad restaurada.';

  @override
  String get newServiceTemplateTitle => 'Nueva plantilla de servicio';

  @override
  String get serviceLabel => 'Servicio';

  @override
  String get priceLabel => 'Precio';

  @override
  String get showWelcomeGuideAgain => 'Mostrar de nuevo la guía de bienvenida';

  @override
  String get languageLabel => 'Idioma';

  @override
  String get languageSystemDefault => 'Predeterminado del sistema';

  @override
  String get remindTomorrowTooltip => 'Recordar a los clientes de mañana';

  @override
  String get noAddressesSnackbar =>
      'No hay direcciones registradas para las visitas de hoy';

  @override
  String get noVisitsWithPhoneSnackbar =>
      'No hay visitas con número de teléfono mañana';

  @override
  String get tomorrowsRemindersTitle => 'Recordatorios de mañana';

  @override
  String get sendButton => 'Enviar';

  @override
  String get noVisitsScheduledToday => 'No hay visitas programadas hoy';

  @override
  String get enjoyDayOffSubtitle =>
      'Disfruta el día libre, o programa una visita.';

  @override
  String visitsTodayCount(int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total visitas hoy',
      one: '1 visita hoy',
    );
    return '$_temp0';
  }

  @override
  String missingAddressCount(int missing) {
    String _temp0 = intl.Intl.pluralLogic(
      missing,
      locale: localeName,
      other: '$missing direcciones faltantes',
      one: '1 dirección faltante',
    );
    return '$_temp0';
  }

  @override
  String get navigateTooltip => 'Navegar';

  @override
  String get noAddressOnFile => 'Sin dirección registrada';

  @override
  String get openFullRouteButton => 'Abrir ruta completa';

  @override
  String get photoComparisonTitle => 'Comparación de fotos';

  @override
  String get swapPhotosTooltip => 'Intercambiar fotos';

  @override
  String elapsedBetweenVisits(String elapsed) {
    return '$elapsed entre estas visitas';
  }

  @override
  String elapsedDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días',
      one: '1 día',
    );
    return '$_temp0';
  }

  @override
  String elapsedWeeks(int weeks) {
    String _temp0 = intl.Intl.pluralLogic(
      weeks,
      locale: localeName,
      other: '$weeks semanas',
      one: '1 semana',
    );
    return '$_temp0';
  }

  @override
  String get beforeLabel => 'ANTES';

  @override
  String get afterLabel => 'DESPUÉS';

  @override
  String get animalTitle => 'Animal';

  @override
  String get progressReportTooltip => 'Informe de progreso';

  @override
  String progressReportSubject(String name) {
    return '$name — Informe de progreso';
  }

  @override
  String get photoDefaultTitle => 'Foto';

  @override
  String get ownerLabel => 'Propietario';

  @override
  String get noVisitsRecordedForAnimal =>
      'Aún no hay visitas registradas para este animal.';

  @override
  String get noPhotosForAnimal => 'Aún no hay fotos etiquetadas a este animal.';

  @override
  String get compareButton => 'Comparar';

  @override
  String get openVisitButton => 'Abrir visita';

  @override
  String daysSinceLastVisit(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días desde la última visita',
      one: '1 día desde la última visita',
    );
    return '$_temp0';
  }

  @override
  String weeksSinceLastShoeing(int weeks) {
    String _temp0 = intl.Intl.pluralLogic(
      weeks,
      locale: localeName,
      other: '$weeks semanas desde el último herraje',
      one: '1 semana desde el último herraje',
    );
    return '$_temp0';
  }

  @override
  String visitHistoryTitle(int count) {
    return 'Historial de visitas ($count)';
  }

  @override
  String get photoHistoryTitle => 'Historial de fotos';

  @override
  String get visitTitle => 'Visita';

  @override
  String get deleteServiceLineTitle => 'Eliminar línea de servicio';

  @override
  String get deleteChargeTitle => 'Eliminar cargo';

  @override
  String removeQuotedItem(String name) {
    return '¿Eliminar \"$name\"?';
  }

  @override
  String get takeAPhoto => 'Tomar una foto';

  @override
  String get chooseFromCameraRoll => 'Elegir de la galería';

  @override
  String get photoDetailsTitle => 'Detalles de la foto';

  @override
  String get tagToAnimalsLabel => 'Etiquetar a animal(es):';

  @override
  String get captionLabel => 'Descripción';

  @override
  String get includeOnInvoiceSwitch => 'Incluir en la factura';

  @override
  String addPhotosCountTitle(int count) {
    return 'Agregar $count fotos';
  }

  @override
  String photosSelectedFromGallery(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fotos seleccionadas de la galería',
      one: '1 foto seleccionada de la galería',
    );
    return '$_temp0';
  }

  @override
  String get tagAllToAnimalsLabel => 'Etiquetar todas a animal(es):';

  @override
  String get captionAllPhotosLabel => 'Descripción (todas las fotos)';

  @override
  String get saveAllButton => 'Guardar todo';

  @override
  String get deletePhotoTitle => 'Eliminar foto';

  @override
  String get removePhotoMessage => '¿Eliminar esta foto?';

  @override
  String get viewShareInvoiceTitle => 'Ver / compartir factura';

  @override
  String get regenerateInvoiceTitle => 'Regenerar factura';

  @override
  String get regenerateInvoiceSubtitle =>
      'Eliminar la actual y generar una nueva';

  @override
  String invoiceSubjectFor(String name) {
    return 'Factura para $name';
  }

  @override
  String get shareInvoicePdfTitle => 'Compartir factura (PDF)';

  @override
  String get shareInvoicePdfSubtitle =>
      'Enviar por cualquier app - Gmail, WhatsApp, etc.';

  @override
  String get printInvoiceTitle => 'Imprimir factura';

  @override
  String errorGeneratingInvoiceSnackbar(String error) {
    return 'Error al generar la factura: $error';
  }

  @override
  String get regenerateInvoiceConfirmTitle => '¿Regenerar factura?';

  @override
  String get regenerateInvoiceConfirmMessage =>
      'Esto eliminará la factura actual y generará una nueva según las líneas de servicio y cargos actuales.';

  @override
  String get regenerateButton => 'Regenerar';

  @override
  String invoicePdfNotFoundSnackbar(String name) {
    return 'No se encontró el PDF de la factura: $name';
  }

  @override
  String get deleteVisitTitle => 'Eliminar visita';

  @override
  String get deleteVisitConfirmMessage =>
      '¿Seguro que deseas eliminar esta visita?';

  @override
  String get couldNotOpenMapsSnackbar => 'No se pudo abrir Google Maps';

  @override
  String calendarEventTitle(String name) {
    return 'Herrador - $name';
  }

  @override
  String get calendarEventDefaultDescription => 'Visita del herrador';

  @override
  String get calendarEventNotAddedSnackbar =>
      'No se pudo agregar el evento al calendario.';

  @override
  String calendarEventErrorSnackbar(String error) {
    return 'No se pudo agregar el evento al calendario: $error';
  }

  @override
  String get noPhoneForClientSnackbar =>
      'No hay número de teléfono guardado para este cliente.';

  @override
  String get couldNotOpenSmsSnackbar => 'No se pudo abrir la app de SMS.';

  @override
  String get noSavedNotesSnackbar =>
      'No se encontraron notas guardadas para este cliente o sus animales.';

  @override
  String get insertFromNotesTitle => 'Insertar desde notas';

  @override
  String clientNotesHeader(String name) {
    return '📋 Cliente — $name';
  }

  @override
  String animalNotesHeader(String name) {
    return '🐾 $name';
  }

  @override
  String get insertButton => '+ Insertar';

  @override
  String get noAddressSaved => 'Sin dirección guardada';

  @override
  String get appointmentAddressTitle => 'Dirección de la cita';

  @override
  String get openInGoogleMaps => 'Abrir en Google Maps';

  @override
  String get editVisitMenuItem => 'Editar visita';

  @override
  String get deleteVisitMenuItem => 'Eliminar visita';

  @override
  String invoiceNotesPrefix(String notes) {
    return 'Notas de factura: $notes';
  }

  @override
  String get addToPhoneCalendarButton => 'Agregar al calendario del teléfono';

  @override
  String get sendReminderButton => 'Enviar recordatorio';

  @override
  String get confirmAppointmentButton => 'Confirmar esta cita';

  @override
  String get visitCompletedSwitch => 'Visita completada';

  @override
  String get paymentReceivedSwitch => 'Pago recibido';

  @override
  String animalsCountTitle(int count) {
    return 'Animales ($count)';
  }

  @override
  String get noAnimalsForVisit =>
      'No hay animales seleccionados para esta visita';

  @override
  String get billingTitle => 'Facturación';

  @override
  String get addServiceLineLabel => 'Agregar línea de servicio';

  @override
  String get noServiceLinesYet => 'Aún no hay líneas de servicio';

  @override
  String get travelIncidentalsTitle => 'Viáticos e imprevistos';

  @override
  String get addChargeLabel => 'Agregar cargo';

  @override
  String get noChargesYet => 'Aún no hay cargos de viaje o imprevistos';

  @override
  String servicesAndTravelSummary(String services, String travel) {
    return 'Servicios: $services · Viáticos e imprevistos: $travel';
  }

  @override
  String get totalLabelPlain => 'Total';

  @override
  String get invoiceNotesLabel => 'Notas de factura';

  @override
  String get invoiceNotesHint => 'Se imprime en la factura...';

  @override
  String get insertFromSavedNotesTooltip => 'Insertar desde notas guardadas';

  @override
  String get generateInvoiceButton => 'Generar factura';

  @override
  String get createInvoiceButton => 'Crear factura';

  @override
  String get addServiceLinesBeforeInvoice =>
      'Agrega líneas de servicio o cargos antes de crear una factura';

  @override
  String get paidInFull => 'Pagada en su totalidad';

  @override
  String photosCountTitle(int count) {
    return 'Fotos ($count)';
  }

  @override
  String get addPhotoLabel => 'Agregar foto';

  @override
  String get noPhotosYet => 'Aún no hay fotos';

  @override
  String get generateInvoiceTooltip => 'Generar factura';

  @override
  String get regenerateInvoiceTooltip => 'Regenerar factura';

  @override
  String get editVisitTitle => 'Editar visita';

  @override
  String get newVisitTitle => 'Nueva visita';

  @override
  String get pleaseSelectClient => 'Selecciona un cliente';

  @override
  String get searchForClientPlaceholder => 'Buscar un cliente...';

  @override
  String get dateLabel => 'Fecha';

  @override
  String get timeLabel => 'Hora';

  @override
  String get recurringLabel => 'Recurrencia';

  @override
  String get recurrenceEvery4 => 'Cada 4 semanas';

  @override
  String get recurrenceEvery6 => 'Cada 6 semanas';

  @override
  String get recurrenceEvery8 => 'Cada 8 semanas';

  @override
  String get recurrenceEvery10 => 'Cada 10 semanas';

  @override
  String get recurrenceCustom => 'Semanas personalizadas';

  @override
  String get customWeeksLabel => 'Semanas personalizadas';

  @override
  String get customWeeksMustBeGreaterThanZero =>
      'Las semanas personalizadas deben ser mayores que 0';

  @override
  String get selectAnimalsLabel => 'Seleccionar animales';

  @override
  String get noAnimalsForClient => 'Este cliente no tiene animales';

  @override
  String get groupServiceHint =>
      '¿No necesitas registrar animales individuales para esta parada? Agrega una línea de servicio grupal desde la pantalla de la visita después de guardar.';

  @override
  String get invoiceNotesHintNewVisit =>
      'Se imprime en la factura — servicios, correcciones, notas especiales...';

  @override
  String get updateVisitButton => 'Actualizar visita';

  @override
  String get saveVisitButton => 'Guardar visita';

  @override
  String get searchClientsHint => 'Buscar clientes...';

  @override
  String get noClientsFound => 'No se encontraron clientes';

  @override
  String clientDetailDeleteMessage(String name) {
    return '¿Seguro que deseas eliminar a $name? Esto también eliminará todas las visitas, animales y fotos asociados.';
  }

  @override
  String get deleteAnimalTitle => 'Eliminar animal';

  @override
  String deleteAnimalConfirmMessage(String name) {
    return '¿Seguro que deseas eliminar a $name?';
  }

  @override
  String deleteVisitConfirmMessageWithDate(String date) {
    return '¿Eliminar la visita del $date?';
  }

  @override
  String get scheduleVisitButton => 'Programar visita';

  @override
  String get tapToCallLongPressText =>
      'Toca para llamar • Mantén presionado para enviar mensaje';

  @override
  String get tapToEmail => 'Toca para enviar correo';

  @override
  String get openInMaps => 'Abrir en el mapa';

  @override
  String notesLabel(String notes) {
    return 'Notas: $notes';
  }

  @override
  String get privateStaffNotesTitle => 'Notas privadas del personal';

  @override
  String get addAnimalLabel => 'Agregar animal';

  @override
  String get noAnimalsAddedYet => 'Aún no se han agregado animales';

  @override
  String visitsCountHeader(int count) {
    return 'Visitas ($count)';
  }

  @override
  String get noVisitsYet => 'Aún no hay visitas';

  @override
  String get editAnimalTitle => 'Editar animal';

  @override
  String get newAnimalTitle => 'Nuevo animal';

  @override
  String get speciesLabel => 'Especie';

  @override
  String get descriptionLabel => 'Descripción';

  @override
  String get animalNotesLabel => 'Notas del animal (privadas)';

  @override
  String get animalNotesHint =>
      'Historial de salud, comportamiento, notas de manejo...';

  @override
  String get internalNotesHintAnimal =>
      'Observaciones privadas del personal — nunca en la factura';

  @override
  String get editServiceLineTitle => 'Editar línea de servicio';

  @override
  String get addServiceLineTitle => 'Agregar línea de servicio';

  @override
  String get savedTemplatesLabel => 'Plantillas guardadas';

  @override
  String get singleAnimalOption => 'Animal individual';

  @override
  String get groupHeadcountOption => 'Grupo / por cantidad';

  @override
  String get animalDropdownLabel => 'Animal';

  @override
  String get groupDescriptionLabel => 'Descripción del grupo';

  @override
  String get groupDescriptionHint =>
      'p. ej. Manada del potrero trasero, Rancho Smith';

  @override
  String get numberOfAnimalsLabel => 'Número de animales';

  @override
  String get enterWholeNumber => 'Ingresa un número entero de 1 o más';

  @override
  String get pricePerAnimalLabel => 'Precio por animal';

  @override
  String get saveAsTemplateButton => 'Guardar como plantilla';

  @override
  String get enterDescriptionFirstSnackbar => 'Ingresa primero una descripción';

  @override
  String templateSavedSnackbar(String description) {
    return '\"$description\" guardada como plantilla';
  }

  @override
  String get editChargeTitle => 'Editar cargo';

  @override
  String get addChargeTitle => 'Agregar cargo';

  @override
  String get typeLabel => 'Tipo';

  @override
  String distanceLabelWithUnit(String unit) {
    return 'Distancia ($unit)';
  }

  @override
  String get enterNumberZeroOrMore => 'Ingresa un número de 0 o más';

  @override
  String ratePerUnitLabel(String unit) {
    return 'Tarifa por $unit';
  }

  @override
  String get amountLabel => 'Monto';

  @override
  String get invalidNumber => 'Número no válido';

  @override
  String get chargeTypeMileage => 'Kilometraje';

  @override
  String get chargeTypeTolls => 'Peajes';

  @override
  String get chargeTypeReimbursement => 'Reembolso';

  @override
  String get chargeTypeTransport => 'Transporte';

  @override
  String get chargeTypeOther => 'Otro';

  @override
  String get statusProjected => 'Proyectada';

  @override
  String get statusPaid => 'Pagada';

  @override
  String get statusOverdue => 'Atrasada';

  @override
  String get statusToday => 'Hoy';

  @override
  String get statusUpcoming => 'Próxima';

  @override
  String get badgeScheduled => 'Programada';

  @override
  String get badgeNoVisitsYet => 'Sin visitas aún';

  @override
  String badgeWeeksAgo(int weeks) {
    String _temp0 = intl.Intl.pluralLogic(
      weeks,
      locale: localeName,
      other: 'hace $weeks sem',
      one: 'hace 1 sem',
    );
    return '$_temp0';
  }
}
