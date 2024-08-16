import 'package:flutter/material.dart';
import 'package:fytness_system/providers/user_provider.dart';
import 'package:fytness_system/services/reservation_service.dart';
import 'package:fytness_system/services/session_service.dart';
import 'package:fytness_system/models/reservation.dart';
import 'package:fytness_system/models/session.dart';
import 'package:fytness_system/widgets/global_admin_card.dart';
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
  int selectedIndex = 2;
  final ReservationService _reservationService =
  ReservationService(baseUrl: 'https://10.0.2.2:7083/api');
  final SessionService _sessionService =
  SessionService(baseUrl: 'https://10.0.2.2:7083/api/sessions');

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user != null) {
      final userRole = user.role;

      if (userRole == 'Client') {
      } else if (userRole == 'Trainer') {
      } else {
      }
    } else {
    }
  }

  void _deleteReservation(int reservationId) async {
    try {
      await _reservationService.deleteReservation(reservationId);

      setState(() {
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reservation successfully deleted'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete reservation: $e')),
      );
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
      backgroundColor: Colors.grey[900],
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final userRole = userProvider.user?.role;

          if (userRole == 'Client') {
            return FutureBuilder<List<dynamic>>(
              future: _reservationService.fetchReservationsByUserId(userProvider.user?.jmbg ?? ''),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("You don't have any reservations", style: TextStyle(color: Color(0xFFE6FE58), fontWeight: FontWeight.bold, fontSize: 24 ),));
                } else {
                  final data = snapshot.data!;
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
                          reservationId: reservation.reservationId,
                          onDelete: () => _deleteReservation(reservation.reservationId),
                        );
                      },
                    ),
                  );
                }
              },
            );
          } else if (userRole == 'Trainer') {
            return FutureBuilder<List<dynamic>>(
              future: _sessionService.fetchSessionsByTrainerJmbg(userProvider.user?.jmbg ?? ''),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("You don't have any sessions", style: TextStyle(color: Color(0xFFE6FE58), fontWeight: FontWeight.bold, fontSize: 20),));
                } else {
                  final data = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final session = data[index] as Session;
                        return TrainerSessionCard(
                          trainingProgramName: session.trainingProgramName,
                          trainingTime: session.time,
                          trainerName: '${session.trainerName} ${session.trainerSurname}',
                          trainingDate: session.date,
                          capacity: session.capacity,
                          roomName: session.roomName,
                        );
                      },
                    ),
                  );
                }
              },
            );
          } else if (userRole == 'Admin') {
            final List<String> titles = [
              'Clients',
              'Trainers',
              'Training Programs',
              'Membership Packages',
              'Sessions',
              'Rooms',
            ];

            final List<String> imagePaths = [
              'assets/clients.jpg',
              'assets/trainers.jpg',
              'assets/training_programs.jpg',
              'assets/membership_packages.jpg',
              'assets/sessions.jpg',
              'assets/rooms.jpg',
            ];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: SizedBox(
                  width: 400,
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 22.0,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: titles.length,
                    itemBuilder: (context, index) {
                      return GlobalGridItem(
                        title: titles[index],
                        imagePath: imagePaths[index],
                        onTap: () {
                          print('Tapped on index $index: ${titles[index]}');
                          switch (index) {
                            case 0:
                              Navigator.pushNamed(context, 'clients/');
                              break;
                            case 1:
                              Navigator.pushNamed(context, 'trainers/');
                              break;
                            case 2:
                              Navigator.pushNamed(context, 'training_programs/');
                              break;
                            case 3:
                              Navigator.pushNamed(context, 'membership_packages/');
                              break;
                            case 4:
                              Navigator.pushNamed(context, 'sessions/');
                              break;
                            case 5:
                              Navigator.pushNamed(context, 'rooms/');
                              break;
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            );
          } else {
            return const Center(child: Text('Unexpected data type.'));
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
