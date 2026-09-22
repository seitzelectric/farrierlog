import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class TerrainTheme {
  final String id;
  final String name;
  final Color seed;

  const TerrainTheme({
    required this.id,
    required this.name,
    required this.seed,
  });
}

const List<TerrainTheme> terrainThemes = [
  TerrainTheme(
    id: 'navy_cream',
    name: 'Navy & Cream',
    seed: Color(0xFF1B3A6B),
  ),
  TerrainTheme(
    id: 'terracotta_sage',
    name: 'Terracotta & Sage',
    seed: Color(0xFFB5541C),
  ),
  TerrainTheme(
    id: 'charcoal_yellow',
    name: 'Charcoal & Yellow',
    seed: Color(0xFF3D3D3D),
  ),
  TerrainTheme(
    id: 'dusty_rose_olive',
    name: 'Dusty Rose & Olive',
    seed: Color(0xFFB07080),
  ),
];

class AppUtils {
  static String _currencySymbol = '\$';
  static String _distanceUnit = 'mi';
  static String _terrainThemeId = 'terracotta_sage';
  static Locale? _locale;
  static VoidCallback? _onThemeChanged;

  static void initCurrencySymbol(String symbol) =>
      _currencySymbol = symbol.isEmpty ? '\$' : symbol;
  static void initDistanceUnit(String unit) =>
      _distanceUnit = unit == 'km' ? 'km' : 'mi';
  static void initTerrainTheme(String id) => _terrainThemeId = id;
  static String get terrainThemeId => _terrainThemeId;
  static Color get terrainSeedColor => terrainThemes
      .firstWhere(
        (t) => t.id == _terrainThemeId,
        orElse: () => terrainThemes.first,
      )
      .seed;
  static void setThemeChangedCallback(VoidCallback cb) =>
      _onThemeChanged = cb;
  static void applyTerrainTheme(String id) {
    initTerrainTheme(id);
    _onThemeChanged?.call();
  }

  /// A saved language code ('en', 'es', 'fr') or null to follow the device
  /// locale (only used if the device locale isn't one FarrierLog supports).
  static Locale? get locale => _locale;
  static void initLocale(String code) {
    _locale = code.isEmpty ? null : Locale(code);
  }

  static void applyLocale(String code) {
    initLocale(code);
    _onThemeChanged?.call();
  }

  static String get distanceUnit => _distanceUnit;

  static Uri googleMapsSearchUri(String address) {
    final encoded = Uri.encodeComponent(address);
    return Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$encoded',
    );
  }

  static Future<bool> openGoogleMapsSearch(String address) async {
    final uri = googleMapsSearchUri(address);
    if (!await canLaunchUrl(uri)) return false;
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  static String formatDateTime(DateTime dateTime) {
    final hour = dateTime.hour == 0
        ? 12
        : (dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour);
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final ampm = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '${dateTime.month}/${dateTime.day}/${dateTime.year} $hour:$minute $ampm';
  }

  static String formatDate(DateTime dateTime) {
    return DateFormat('MMM d, yyyy').format(dateTime);
  }

  static String formatTime(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime);
  }

  static String formatCurrency(double amount) =>
      '$_currencySymbol${amount.toStringAsFixed(2)}';

  static String formatDistance(double quantity) =>
      '${quantity.toStringAsFixed(1)} $_distanceUnit';

  static String formatDateTimeForInvoice(DateTime dateTime) {
    return DateFormat('MMMM d, yyyy  h:mm a').format(dateTime);
  }

  static String getRelativeDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final diff = date.difference(today).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    if (diff == -1) return 'Yesterday';
    if (diff > 0 && diff < 7) return 'In $diff days';
    if (diff < 0 && diff > -7) return '${-diff} days ago';
    return formatDate(dateTime);
  }

  /// Builds a Google Maps directions URL with multiple stops in order.
  static String multiStopRouteUrl(List<String> addresses) {
    final clean = addresses
        .where((a) => a.trim().isNotEmpty)
        .map((a) => Uri.encodeComponent(a.trim()))
        .toList();
    if (clean.isEmpty) return '';
    if (clean.length == 1) {
      return 'https://www.google.com/maps/dir/?api=1&destination=${clean.first}';
    }
    final destination = clean.last;
    final waypoints = clean.sublist(0, clean.length - 1).join('%7C');
    return 'https://www.google.com/maps/dir/?api=1'
        '&destination=$destination'
        '&waypoints=$waypoints'
        '&travelmode=driving';
  }

  /// Converts logical pixels to physical pixels for `cacheWidth`/`cacheHeight`,
  /// so `Image.file` downsamples while decoding instead of loading a
  /// full-resolution camera photo into memory.
  static int cachePixels(BuildContext context, double logicalPixels) =>
      (logicalPixels * MediaQuery.of(context).devicePixelRatio).round();

  static String getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty || name.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts.last[0]}'.toUpperCase();
  }
}
