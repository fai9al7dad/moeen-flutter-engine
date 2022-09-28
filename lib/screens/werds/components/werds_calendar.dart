import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moeen/helpers/models/werds_model.dart';
import 'package:intl/intl.dart';
import 'package:moeen/providers/auth/auth_provider.dart';
import 'package:moeen/screens/werds/components/werd_card.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:table_calendar/table_calendar.dart';

class WerdsCalendar extends StatefulWidget {
  final List<WerdsModel>? werds;
  final String username;
  const WerdsCalendar({
    Key? key,
    required this.werds,
    required this.username,
  }) : super(key: key);

  @override
  State<WerdsCalendar> createState() => _WerdsCalendarState();
}

class _WerdsCalendarState extends State<WerdsCalendar> {
  Map<DateTime, List<WerdsModel>>? _werdsEvenets;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initWerdsEvents();
  }

  void _initWerdsEvents() {
    // loop through widget werds and assign to werdsevents map with date as key
    _werdsEvenets = {};
    for (var werd in widget.werds!) {
      final date = DateTime.parse(werd.createdAt!);
      // add date and time as zero
      final dateOnly = DateTime(date.year, date.month, date.day);
      if (_werdsEvenets![dateOnly] == null) _werdsEvenets![dateOnly] = [];
      _werdsEvenets![dateOnly]!.add(werd);
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      DateTime formatSelected =
          DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
      setState(() {
        _selectedDay = formatSelected;
        _focusedDay = focusedDay;
      });

      // _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  List<WerdsModel> _getEventsForDay(DateTime day) {
    return _werdsEvenets?[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    if (widget.werds == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TableCalendar(
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                firstDay: widget.werds?.last.createdAt != null
                    ? DateTime.parse(widget.werds!.last.createdAt!)
                    : DateTime.now(),
                lastDay: DateTime.now(),
                locale: "ar",
                // firstDay:
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) => Container(
                    margin: const EdgeInsets.all(4),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      day.day.toString(),
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  todayBuilder: (context, day, focusedDay) => Container(
                    margin: const EdgeInsets.all(4),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      border: Border.all(
                          color: Theme.of(context).colorScheme.primary),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      day.day.toString(),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                  selectedBuilder: (context, day, focusedDay) => Container(
                    margin: const EdgeInsets.all(4),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      day.day.toString(),
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  markerBuilder:
                      ((context, DateTime day, List<WerdsModel> events) {
                    if (events.isEmpty) {
                      return const SizedBox();
                    }
                    // loop through events and if there isAccepted event return a container
                    bool hasUnAccepted = false;
                    for (WerdsModel event in events) {
                      if (event.isAccepted != true &&
                          event.reciterID ==
                              Provider.of<AuthProvider>(context).authUser!.id) {
                        hasUnAccepted = true;
                      }
                    }

                    return Stack(children: [
                      if (hasUnAccepted)
                        const Positioned(
                          left: 1,
                          top: 1,
                          child: Text("❕"),
                        ),
                      const Positioned(
                        right: 1,
                        bottom: 1,
                        child: Text("👍"),
                      ),
                    ]);
                  }),
                ),
                calendarStyle: const CalendarStyle(
                  outsideDaysVisible: true,
                ),
                headerStyle: const HeaderStyle(
                    formatButtonVisible: false, titleCentered: true),
                //     Da,
                // lastDay: DateTime.now(),

                onDaySelected: _onDaySelected,
                eventLoader: (day) => _getEventsForDay(day),
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                focusedDay: _focusedDay,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: _getEventsForDay(_selectedDay).map((werd) {
                  String type;
                  if (Provider.of<AuthProvider>(context, listen: false)
                          .authUser
                          ?.id ==
                      werd.reciterID) {
                    type = "asReciter";
                  } else {
                    type = "asCorrector";
                  }
                  return WerdCard(
                    werd: werd,
                    duoName: widget.username,
                    index: 0,
                    type: type,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
