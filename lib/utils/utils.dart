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

  static String getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty || name.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts.last[0]}'.toUpperCase();
  }
}
