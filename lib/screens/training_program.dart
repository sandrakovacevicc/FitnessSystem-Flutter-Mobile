import 'package:flutter/material.dart';
import 'package:fytness_system/models/session.dart';
import 'package:fytness_system/models/user.dart';
import 'package:fytness_system/providers/user_provider.dart';
import 'package:fytness_system/services/session_service.dart';
import 'package:fytness_system/services/reservation_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SessionDetailPage extends StatefulWidget {
  final int sessionId;

  const SessionDetailPage({super.key, required this.sessionId});

  @override
  _SessionDetailPageState createState() {
    return _SessionDetailPageState();
  }
}

class _SessionDetailPageState extends State<SessionDetailPage> {
  late Future<Session> _session;
  final SessionService _sessionService = SessionService(baseUrl: 'https://172.20.10.2:7083/api');
  final ReservationService _reservationService = ReservationService(baseUrl: 'https://172.20.10.2:7083/api');
  //final SessionService _sessionService = SessionService(baseUrl: 'https://10.0.2.2:7083/api');
  //final ReservationService _reservationService = ReservationService(baseUrl: 'https://10.0.2.2:7083/api');

  @override
  void initState() {
    super.initState();
    _session = _sessionService.fetchSessionById(widget.sessionId);
  }

  Future<void> showDetailsPopup(int sessionId) async {
    final futureClients = _reservationService.fetchConfirmedClientsBySessionId(sessionId);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFE6FE58),
          title: const Text('Checked-in Clients', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          content: FutureBuilder<List<User>>(
            future: futureClients,
            builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No clients have checked in :(', style: TextStyle(color: Colors.black));
              } else {
                final clients = snapshot.data!;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: clients.map((client) => Text('${client.name} ${client.surname}')).toList(),
                );
              }
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  bool isSessionPast(DateTime sessionDate, TimeOfDay sessionTime) {
    final now = DateTime.now();
    final currentDate = DateTime(now.year, now.month, now.day);
    final currentTimeInMinutes = now.hour * 60 + now.minute;

    final sessionDateTime = DateTime(sessionDate.year, sessionDate.month, sessionDate.day);
    final sessionTimeInMinutes = sessionTime.hour * 60 + sessionTime.minute;

    if (currentDate.isAfter(sessionDateTime)) {
      return true;
    }

    if (currentDate.isAtSameMomentAs(sessionDateTime) && currentTimeInMinutes >= sessionTimeInMinutes) {
      return true;
    }

    return false;
  }


  void _generateQRCode(Session session) async {
    try {
      final qrCodeData = await _sessionService.generateQrCode(session.sessionId);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor:const Color(0xFFE6FE58),
            title: const Text('QR Code', style: TextStyle(color: Colors.black),),
            content: Image.memory(qrCodeData),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate QR code: $e')),
      );
    }
  }

  _deleteSession(int sessionId) async {
    try {
      await _sessionService.deleteSession(sessionId);

      setState(() {});
      Navigator.pushReplacementNamed(context, 'trainings/');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Session successfully deleted'),
        ),
      );
    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().contains('reservations associated')
                ? 'You cannot delete this session because there are reservations associated with it.'
                : 'Failed to delete session: $e',
          ),
        ),
      );
    }
  }


  void _bookNow(Session session) async {
    final now = DateTime.now();
    final currentDate = DateTime(now.year, now.month, now.day);
    final currentTimeInMinutes = now.hour * 60 + now.minute;

    final sessionDateTime = DateTime(
      session.date.year,
      session.date.month,
      session.date.day,
    );

    final sessionTimeInMinutes = session.time.hour * 60 + session.time.minute;


    if (currentDate.isAfter(sessionDateTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reservation date and time cannot be in the past!')),
      );
      return;
    }

    if (currentDate.isAtSameMomentAs(sessionDateTime) &&
        currentTimeInMinutes >= sessionTimeInMinutes) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reservation time cannot be after the session time!')),
      );
      return;
    }


    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final clientJMBG = userProvider.user?.jmbg ?? '';

    if (clientJMBG.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User JMBG is not available!')),
      );
      return;
    }

    try {
      final reservations = await _reservationService.fetchReservationsByUserId(clientJMBG);

      final hasReserved = reservations.any((reservation) =>
      reservation.sessionId == session.sessionId);

      if (hasReserved) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You have already reserved this session!')),
        );
        return;
      }

      await _reservationService.createReservation(
        clientJMBG: clientJMBG,
        sessionId: session.sessionId,
        date: currentDate,
        time: DateFormat('HH:mm:ss').format(DateTime(0, 0, 0, now.hour, now.minute)),
        status: "reserved",
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reservation successfully created!')),
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        'trainings/',
            (Route<dynamic> route) => false,
      );
    } catch (e, stackTrace) {
      print('Failed to create reservation: $e');
      print('Stack trace: $stackTrace');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create reservation: $e')),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    final userRole = Provider.of<UserProvider>(context).user?.role ?? '';

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
            String programImageUrl = getProgramImage(session.trainingProgramName);
            String trainerImageUrl = getTrainerImage(session.trainerName);
            Icon levelIcon = getLevelIcon(session.trainingProgramType);

            return Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 300,
                      child: Image.asset(
                        programImageUrl,
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
                  child: SingleChildScrollView(
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
                            const SizedBox(height: 8),
                            Text(
                              'Room: ${session.roomName}',
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
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: AssetImage(trainerImageUrl),
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
                ),
                if (isSessionPast(session.date, session.time) && (userRole == 'Trainer' || userRole == 'Admin'))
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    color: Colors.black,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () => showDetailsPopup(widget.sessionId),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE6FE58),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text('Details'),
                      ),
                    ),
                  ),
                if (!isSessionPast(session.date, session.time) && userRole == 'Trainer')
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    color: Colors.black,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () => _generateQRCode(session),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE6FE58),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text('Generate QR Code'),
                      ),
                    ),
                  ),
                if (!isSessionPast(session.date, session.time) && userRole == 'Admin')
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    color: Colors.black,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () => _deleteSession(session.sessionId),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE6FE58),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text('Delete'),
                      ),
                    ),
                  ),
                if (userRole == 'Client' && session.capacity > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    color: Colors.black,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () => _bookNow(session),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE6FE58),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text('Book Now'),
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
      'HIIT': 'assets/hiit_1.png',
      'Yoga': 'assets/yoga_1.png',
      'Pilates': 'assets/pilates_1.png',
      'Crossfit': 'assets/crossfit_1.png',
      'Spinning': 'assets/spinning_1.png',
    }[programName] ?? 'assets/default_program.jpg';
  }

  String getTrainerImage(String trainerName) {
    return {
      'Sandra': 'assets/sandra.jpg',
      'Nikola': 'assets/nikola.jpg',
      'Milica': 'assets/milica.jpg',
      'Zika': 'assets/zika.jpg',
    }[trainerName] ?? 'assets/default_trainer.jpg';
  }

  Icon getLevelIcon(String trainingProgramType) {
    return {
      'beginner': const Icon(Icons.emoji_people, color: Colors.green),
      'intermediate': const Icon(Icons.directions_run, color: Colors.orange),
      'advanced': const Icon(Icons.sports_gymnastics, color: Colors.red),
    }[trainingProgramType] ?? const Icon(Icons.help, color: Colors.grey);
  }

}