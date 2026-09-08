  import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendario extends StatefulWidget {
  const Calendario({super.key});

  @override
  State<Calendario> createState() => _CalendarioState();
}

class _CalendarioState extends State<Calendario> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();

  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),

        // BOTÕES MÊS / SEMANA
        SizedBox(
          height: 45,
          child: Row(
            children: [
              Expanded(
                child: _buildCalendarButton(
                  context: context,
                  text: 'Mês',
                  icon: Icons.calendar_month,
                  selected:
                      _calendarFormat == CalendarFormat.month,
                  onTap: () {
                    setState(() {
                      _calendarFormat = CalendarFormat.month;
                    });
                  },
                  left: true,
                ),
              ),

              Expanded(
                child: _buildCalendarButton(
                  context: context,
                  text: 'Semana',
                  icon: Icons.calendar_view_week,
                  selected:
                      _calendarFormat == CalendarFormat.week,
                  onTap: () {
                    setState(() {
                      _calendarFormat = CalendarFormat.week;
                    });
                  },
                  left: false,
                ),
              ),
            ],
          ),
        ),

        // CALENDÁRIO
        TableCalendar(
          locale: 'pt_BR',

          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),

          focusedDay: _focusedDate,

          selectedDayPredicate: (day) {
            return isSameDay(_selectedDate, day);
          },

          calendarFormat: _calendarFormat,

          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDate = selectedDay;
              _focusedDate = focusedDay;
            });
          },

          onPageChanged: (focusedDay) {
            _focusedDate = focusedDay;
          },

          startingDayOfWeek: StartingDayOfWeek.monday,

          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
          ),

          calendarStyle: const CalendarStyle(
            outsideDaysVisible: true,
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarButton({
    required BuildContext context,
    required String text,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
    required bool left,
  }) {
    final primary = Theme.of(context).colorScheme.primary;
    final surface = Theme.of(context).colorScheme.surface;

    return InkWell(
      onTap: onTap,

      child: Container(
        decoration: BoxDecoration(
          color: selected ? primary : surface,

          border: Border.all(
            color: primary,
            width: 1,
          ),

          borderRadius: BorderRadius.only(
            topLeft: left
                ? const Radius.circular(10)
                : Radius.zero,

            bottomLeft: left
                ? const Radius.circular(10)
                : Radius.zero,

            topRight: !left
                ? const Radius.circular(10)
                : Radius.zero,

            bottomRight: !left
                ? const Radius.circular(10)
                : Radius.zero,
          ),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(
              icon,
              size: 20,
              color: selected ? Colors.white : primary,
            ),

            const SizedBox(width: 8),

            Text(
              text,

              style: TextStyle(
                color: selected ? Colors.white : primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}