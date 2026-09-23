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
    final secondary = Theme.of(context).colorScheme.secondary;
    final primary = Theme.of(context).colorScheme.primary;

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

          calendarStyle: CalendarStyle(
            outsideDaysVisible: true,

            // Dia de hoje (quando não é o selecionado) usa a secondary
            // com menos opacidade, pra não competir com o dia selecionado.
            todayDecoration: BoxDecoration(
              color: secondary.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            todayTextStyle: TextStyle(
              color: primary,
              fontWeight: FontWeight.bold,
            ),

            // Dia selecionado usa a cor secondary do tema.
            selectedDecoration: BoxDecoration(
              color: secondary,
              shape: BoxShape.circle,
            ),
            selectedTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
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
    final secondary = Theme.of(context).colorScheme.secondary;
    final surface = Theme.of(context).colorScheme.surface;

    return InkWell(
      onTap: onTap,

      child: Container(
        decoration: BoxDecoration(
          color: selected ? secondary : surface,

          border: Border.all(
            color: secondary,
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
              color: selected ? Colors.white : secondary,
            ),

            const SizedBox(width: 8),

            Text(
              text,

              style: TextStyle(
                color: selected ? Colors.white : secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}