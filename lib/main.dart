import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MedLink',
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF082849),
          primary: const Color(0xFF082849),
          secondary: const Color(0XFF0371CA),
          surface: const Color(0XFFF0F7FF),
          onSurface: const Color(0XFF082849),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // Geralmente, se diz as ações da página
    super.initState();
    // Aguardar 2 seg e depois redirecionar para a Home
    // Navigator.pushReplacement
    // trabalhar a pilha de navegação
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/images/logo.svg'),
            const SizedBox(height: 5),
            SvgPicture.asset('assets/images/medlink.svg'),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: SizedBox(
          height: 35,
          child: SvgPicture.asset(
            'assets/images/medlink.svg',
            fit: BoxFit.contain,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Meus agendamentos',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Próxima consulta:',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),

              LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;

                  final bool telaPequena = width < 380;
                  final bool telaMuitoPequena = width < 340;

                  return Container(
                    width: double.infinity,
                    height: telaMuitoPequena
                        ? 90
                        : telaPequena
                            ? 100
                            : 110,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        // FOTO
                        Padding(
                          padding: EdgeInsets.only(
                            left: telaMuitoPequena ? 8 : 16,
                          ),
                          child: CircleAvatar(
                            radius: telaMuitoPequena
                                ? 25
                                : telaPequena
                                    ? 29
                                    : 33,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person_outline,
                              size: telaMuitoPequena
                                  ? 34
                                  : telaPequena
                                      ? 39
                                      : 45,
                              color: Colors.grey,
                            ),
                          ),
                        ),

                        SizedBox(
                          width: telaMuitoPequena ? 5 : 10,
                        ),

                        // INFORMAÇÕES DO MÉDICO
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Dr. Tom Holland',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: telaMuitoPequena
                                      ? 13
                                      : telaPequena
                                          ? 15
                                          : 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 2),

                              Text(
                                'Oftalmologista',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: telaMuitoPequena ? 9 : 12,
                                ),
                              ),

                              const SizedBox(height: 2),

                              Text(
                                'Clínica Vista+',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: telaMuitoPequena ? 10 : 14,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // HORÁRIO
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: telaMuitoPequena ? 3 : 5,
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '14:00h',
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: telaMuitoPequena
                                    ? 17
                                    : telaPequena
                                        ? 20
                                        : 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        // DIVISOR
                        Container(
                          height: telaMuitoPequena ? 50 : 70,
                          width: 1.5,
                          margin: EdgeInsets.symmetric(
                            horizontal: telaMuitoPequena ? 4 : 8,
                          ),
                          color: Colors.white,
                        ),

                        // DATA
                        Padding(
                          padding: EdgeInsets.only(
                            right: telaMuitoPequena ? 7 : 16,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '24',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: telaMuitoPequena
                                      ? 25
                                      : telaPequena
                                          ? 30
                                          : 40,
                                  fontWeight: FontWeight.bold,
                                  height: 0.9,
                                ),
                              ),
                              Text(
                                'AGO',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: telaMuitoPequena
                                      ? 12
                                      : telaPequena
                                          ? 15
                                          : 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              Calendario(),
            ],
          ), 
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        color: Theme.of(context).colorScheme.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildNavBarItem(Icon(Icons.home, color: Colors.white,), 0),
            buildNavBarItem(Icon(Icons.history_outlined, color: Colors.white,), 1),
            SizedBox(width: 20,),
            buildNavBarItem(
              Text(
                'PXX',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white,
                  decorationThickness: 2.0,
                ),
              ),
              3,
            ),
            buildNavBarItem(
              Icon(Icons.account_circle_outlined, color: Colors.white), 4),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 58, // Um pouquinho maior que o botão para cobrir a borda perfeitamente
        height: 58,
        child: Stack(
          alignment: Alignment.center,
          children: [
            FloatingActionButton(
              // Desativa absolutamente todas as sombras de interação e toque
              elevation: 0,
              disabledElevation: 0,
              focusElevation: 0,
              hoverElevation: 0,
              highlightElevation: 0,
              backgroundColor: Theme.of(context).colorScheme.secondary, 
              onPressed: () {},
              shape: const CircleBorder(), // Círculo puro
              child: Icon(
                Icons.add,
                size: 24,
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
            IgnorePointer( // Impede que esse desenho bloqueie o clique no botão
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.surface, // Sua linha branca/surface
                    width: 4.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget buildNavBarItem(Widget icon, int index) {
    return Expanded(
      child: InkWell(
        onTap: () {
          // ação
        },
        child: Container(
          height: 60,
          width: 60,
          alignment: Alignment.center,
          child: SizedBox(
            width: 36,
            height: 36,
            child: FittedBox(
              child: icon,
            ),
          ),
        ),
      ),
    );
  }
}

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

        // MÊS / SEMANA
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