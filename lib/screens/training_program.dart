import 'package:flutter/material.dart';
import 'package:fytness_system/models/session.dart';
import 'package:fytness_system/providers/user_provider.dart';
import 'package:fytness_system/services/session_service.dart';
import 'package:fytness_system/services/reservation_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SessionDetailPage extends StatefulWidget {
  final int sessionId;

  const SessionDetailPage({super.key, required this.sessionId});

  @override
  _SessionDetailPageState createState() => _SessionDetailPageState();
}

class _SessionDetailPageState extends State<SessionDetailPage> {
  late Future<Session> _session;
  final ReservationService _reservationService = ReservationService(baseUrl: 'https://10.0.2.2:7083/api');

  @override
  void initState() {
    super.initState();
    _session = SessionService(baseUrl: 'https://10.0.2.2:7083/api').fetchSessionById(widget.sessionId);
  }

  void _bookNow(Session session) async {
    final now = DateTime.now();
    final currentDate = DateTime(now.year, now.month, now.day);
    final currentTime = TimeOfDay.now();


    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final clientJMBG = userProvider.user?.jmbg ?? '';

    // Check if the reservation date is in the future
    if (session.date.isAfter(currentDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reservation date cannot be in the future!')),
      );
      return;
    }

    // Check if the reservation time is in the future or after session time
    final sessionTime = session.time;
    final reservationTime = DateTime(0, 0, 0, currentTime.hour, currentTime.minute);
    if (reservationTime.isAfter(DateTime(0, 0, 0, sessionTime.hour, sessionTime.minute))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reservation time cannot be after the session time!')),
      );
      return;
    }

    try {
      // Ensure that clientJMBG is not empty
      if (clientJMBG.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User JMBG is not available!')),
        );
        return;
      }

      await _reservationService.createReservation(
        clientJMBG: clientJMBG, // Use the JMBG from UserProvider
        sessionId: session.sessionId,
        date: currentDate, // Use the current date
        time: DateFormat('HH:mm:ss').format(reservationTime), // Use the current time
        status: "reserved",
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reservation successfully created!')),
      );
    } catch (e, stackTrace) {
      // Print or log the error and stack trace
      print('Failed to create reservation: $e');
      print('Stack trace: $stackTrace');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create reservation: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Session>(
        future: _session,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading session details'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Session not found'));
          } else {
            final session = snapshot.data!;
            String imageUrl = getProgramImage(session.trainingProgramName);
            Icon levelIcon = getLevelIcon(session.trainingProgramType);

            return Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 300,
                      child: Image.asset(
                        imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 30,
                      left: 16,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Color(0xFFE6FE58), size: 30),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                session.trainingProgramName,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFE6FE58),
                                ),
                              ),
                              Text(
                                DateFormat('d MMM yyyy').format(session.date),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              levelIcon,
                              const SizedBox(width: 8),
                              Text(
                                'Starts at: ${DateFormat('HH:mm').format(DateTime(0, 0, 0, session.time.hour, session.time.minute))}h',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Duration: ${session.duration} min',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Level: ${session.trainingProgramType}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            session.trainingProgramDescription,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 30),
                          const Text(
                            'Instructor',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 30,
                                backgroundImage: AssetImage('assets/hiit.jpg'),
                              ),
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${session.trainerName} ${session.trainerSurname}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Working: ${session.trainerSpecialty}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: Text(
                              'For more information, contact: ${session.trainerEmail}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  color: Colors.black,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: session.capacity > 0 ? () {
                        _bookNow(session);
                      } : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: session.capacity > 0 ? const Color(0xFFE6FE58) : Colors.grey,
                        foregroundColor: session.capacity > 0 ? Colors.black : Colors.white,
                        disabledBackgroundColor: Colors.grey.withOpacity(0.3),
                        disabledForegroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: Text(
                        session.capacity > 0 ? 'Book Now' : 'No more available spots',
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  String getProgramImage(String programName) {
    return {
      'HIIT': 'assets/hiit.jpg',
      'Yoga': 'assets/yoga.jpg',
      'Pilates': 'assets/pilates.jpg',
      'Crossfit': 'assets/crossfit.jpg',
      'Spinning': 'assets/spinning.jpg',
    }[programName] ?? 'assets/default.jpg';
  }

  Icon getLevelIcon(String level) {
    switch (level) {
      case 'beginner':
        return const Icon(Icons.directions_walk, color: Colors.green);
      case 'intermediate':
        return const Icon(Icons.directions_run, color: Colors.orange);
      case 'advanced':
        return const Icon(Icons.directions_bike, color: Colors.red);
      default:
        return const Icon(Icons.help, color: Colors.grey);
    }
  }
}
