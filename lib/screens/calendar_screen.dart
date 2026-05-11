import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/models.dart';
import '../services/database_service.dart';
import '../utils/utils.dart';
import 'screens.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Visit>> _visitsByDay = {};
  List<Visit> _selectedVisits = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _loadVisits();
  }

  Future<void> _loadVisits() async {
    final visits = await DatabaseService.getVisits();
    final map = <DateTime, List<Visit>>{};

    for (final visit in visits) {
      final day = DateTime(
        visit.dateTime.year,
        visit.dateTime.month,
        visit.dateTime.day,
      );
      map.putIfAbsent(day, () => []).add(visit);
    }

    if (mounted) {
      setState(() {
        _visitsByDay = map;
        _selectedVisits = _getVisitsForDay(_selectedDay!);
        _loading = false;
      });
    }
  }

  List<Visit> _getVisitsForDay(DateTime day) {
    final normalized = DateTime(day.year, day.month, day.day);
    return _visitsByDay[normalized] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _selectedVisits = _getVisitsForDay(selectedDay);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Calendar')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: Column(
        children: [
          TableCalendar<Visit>(
            firstDay: DateTime(2020),
            lastDay: DateTime(2035),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: _onDaySelected,
            onPageChanged: (focusedDay) => _focusedDay = focusedDay,
            eventLoader: (day) => _getVisitsForDay(day),
            calendarStyle: CalendarStyle(
              markerDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _selectedVisits.isEmpty
                ? Center(
                    child: Text(
                      'No visits on ${AppUtils.formatDate(_selectedDay!)}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  )
                : ListView.builder(
                    itemCount: _selectedVisits.length,
                    itemBuilder: (_, i) {
                      final visit = _selectedVisits[i];
                      return VisitListTile(
                        visit: visit,
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VisitDetailScreen(visit: visit),
                            ),
                          );
                          _loadVisits();
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
