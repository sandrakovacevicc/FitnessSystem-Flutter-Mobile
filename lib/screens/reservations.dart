import 'package:flutter/material.dart';
import 'package:fytness_system/providers/user_provider.dart';
import 'package:fytness_system/services/reservation_service.dart';
import 'package:fytness_system/services/session_service.dart';
import 'package:fytness_system/models/reservation.dart';
import 'package:fytness_system/models/session.dart';
import 'package:fytness_system/widgets/global_menu.dart';
import 'package:fytness_system/widgets/global_navbar.dart';
import 'package:fytness_system/widgets/global_reservation_card.dart';
import 'package:fytness_system/widgets/global_trainer_session_card.dart';
import 'package:provider/provider.dart';


class Reservations extends StatefulWidget {
  const Reservations({super.key});

  @override
  State<Reservations> createState() => _ReservationsState();
}

class _ReservationsState extends State<Reservations> {
  late Future<List<dynamic>> _data;
  int selectedIndex = 2;
  final ReservationService _reservationService = ReservationService(baseUrl: 'https://10.0.2.2:7083/api');
  final SessionService _sessionService = SessionService(baseUrl: 'https://10.0.2.2:7083/api/sessions');

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user != null) {
      final userJMBG = user.jmbg;
      final userRole = user.role;

      if (userRole == 'Client') {
        _data = _reservationService.fetchReservationsByUserId(userJMBG);
      } else if (userRole == 'Trainer') {
        _data = _sessionService.fetchSessionsByTrainerJmbg(userJMBG);
      } else {
        _data = Future.value([]); // Empty list for roles without specific data
      }
    } else {
      _data = Future.value([]); // Empty list if no user is found
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
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
      body: FutureBuilder<List<dynamic>>(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data found.'));
          } else {
            final data = snapshot.data!;
            if (data.isEmpty) {
              return const Center(child: Text('No data available.'));
            }

            // Determine if the data is a list of reservations or sessions
            if (data.first is Reservation) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final reservation = data[index] as Reservation;
                    return ReservationCard(
                      trainingProgramName: reservation.trainingProgramName,
                      time: reservation.time,
                      status: reservation.status,
                      reservationDate: reservation.date,
                      trainingTime: reservation.trainingTime,
                      trainingDate: reservation.trainingDate,
                    );
                  },
                ),
              );
            } else if (data.first is Session) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final session = data[index] as Session;
                    return TrainerSessionCard(
                      trainingProgramName: session.trainingProgramName,
                      trainingTime: session.time,
                      trainerName: '${session.trainerName} ${session.trainerSurname}', trainingDate: session.date, capacity: session.capacity,
                      roomName: session.roomName,
                      // You can add other session details here
                    );
                  },
                ),
              );
            } else {
              return const Center(child: Text('Unexpected data type.'));
            }
          }
        },
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
