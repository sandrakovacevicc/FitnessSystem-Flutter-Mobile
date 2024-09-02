import 'package:flutter/material.dart';
import 'package:fytness_system/widgets/global_menu.dart';
import 'package:fytness_system/widgets/global_session_card.dart';
import 'package:intl/intl.dart';
import 'package:fytness_system/widgets/global_navbar.dart';
import 'package:fytness_system/models/session.dart';
import 'package:fytness_system/services/session_service.dart';

class Trainings extends StatefulWidget {
  const Trainings({super.key});

  @override
  State<Trainings> createState() => _TrainingsState();
}

class _TrainingsState extends State<Trainings> {
  int _selectedIndex = 1;
  final TextEditingController searchController = TextEditingController();
  int selectedIndex = 0;
  List<String> dates = [];
  final ScrollController _scrollController = ScrollController();
  late Future<List<Session>> _sessions;

  @override
  void initState() {
    super.initState();
    _generateDates();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setInitialDate();
    });
    _fetchSessions();
  }

  void _generateDates() {
    DateTime now = DateTime.now();
    DateTime firstDay = DateTime(now.year, 8, 1);
    DateTime lastDay = DateTime(now.year, 12, 31);

    for (DateTime date = firstDay; date.isBefore(lastDay) || date.isAtSameMomentAs(lastDay); date = date.add(const Duration(days: 1))) {
      dates.add(DateFormat('d MMM').format(date));
    }
  }

  void _setInitialDate() {
    DateTime now = DateTime.now();
    String today = DateFormat('d MMM').format(now);
    selectedIndex = dates.indexOf(today);

    if (selectedIndex == -1) {
      selectedIndex = 0;
    }

    setState(() {
      selectedIndex = selectedIndex;
    });

    double totalWidth = MediaQuery.of(context).size.width;
    double itemWidth = 60.0;
    double initialOffset = (selectedIndex * itemWidth) - (totalWidth / 2) + (itemWidth / 2);

    _scrollController.animateTo(
      initialOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    _fetchSessions();
  }

  void _previousDate() {
    setState(() {
      if (selectedIndex > 0) {
        selectedIndex--;
        _scrollController.animateTo(selectedIndex * 60.0,
            duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
        _fetchSessions();
      }
    });
  }

  void _nextDate() {
    setState(() {
      if (selectedIndex < dates.length - 1) {
        selectedIndex++;
        _scrollController.animateTo(selectedIndex * 60.0,
            duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
        _fetchSessions();
      }
    });
  }

  void _fetchSessions() {
    DateTime parsedDate = DateFormat('d MMM').parse(dates[selectedIndex]);
    String selectedDate = DateFormat('2024-MM-dd').format(parsedDate);

    setState(() {
      _sessions = SessionService(baseUrl: 'https://172.20.10.2:7083/api')
          .fetchSessions(selectedDate);
      //_sessions = SessionService(baseUrl: 'https://10.0.2.2:7083/api')
        //  .fetchSessions(selectedDate);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, 'mainScreen/');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, 'trainings/');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, 'reservations/');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, 'profile/');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavBar(automaticallyImplyLeading: false),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(7.0),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.86),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_left),
                              onPressed: _previousDate,
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 70,
                                child: ListView.builder(
                                  controller: _scrollController,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: dates.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedIndex = index;
                                          });
                                          _fetchSessions();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: index == selectedIndex
                                                ? const Color(0xFFE6FE58)
                                                : const Color(0xFF050505).withOpacity(0.5),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          padding: const EdgeInsets.all(10),
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  dates[index].split(' ')[0],
                                                  style: TextStyle(
                                                    color: index == selectedIndex
                                                        ? Colors.black
                                                        : Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  dates[index].split(' ')[1],
                                                  style: TextStyle(
                                                    color: index == selectedIndex
                                                        ? Colors.black
                                                        : Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.arrow_right),
                              onPressed: _nextDate,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: FutureBuilder<List<Session>>(
                            future: _sessions,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return const Center(child: Text('Error loading sessions'));
                              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return const Center(child: Text('No sessions available', style: TextStyle(color: Color(0xFFE6FE58), fontWeight: FontWeight.bold, fontSize: 20 ),));
                              } else {
                                return ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                      child: SessionCard(session: snapshot.data![index]),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
