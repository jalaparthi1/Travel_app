import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/plan.dart';

class CalendarScreen extends StatefulWidget {
  final List<Plan> plans;

  CalendarScreen(this.plans);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDay = DateTime.now();

  void _assignPlanToDate(Plan plan) {
    setState(() {
      plan.date = _selectedDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Plan Calendar")),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            focusedDay: _selectedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) =>
                setState(() => _selectedDay = selectedDay),
          ),
          Expanded(
            child: DragTarget<Plan>(
              onAccept: (plan) => _assignPlanToDate(plan),
              builder: (context, candidateData, rejectedData) => Column(
                children: [
                  Text("Drop plans here to assign to $_selectedDay",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: ListView(
                      children: widget.plans
                          .where((plan) => isSameDay(plan.date, _selectedDay))
                          .map((plan) => ListTile(
                                title: Text(plan.name),
                                subtitle: Text(plan.priority),
                                tileColor: plan.isCompleted
                                    ? Colors.green[300]
                                    : Colors.amber[300],
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
