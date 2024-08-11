import 'package:flutter/material.dart';
import 'package:fytness_system/providers/user_provider.dart';
import 'package:fytness_system/services/reservation_service.dart';
import 'package:fytness_system/models/reservation.dart';
import 'package:fytness_system/widgets/global_menu.dart';
import 'package:fytness_system/widgets/global_navbar.dart';
import 'package:fytness_system/widgets/global_reservation_card.dart';
import 'package:provider/provider.dart';

class Reservations extends StatefulWidget {
  const Reservations({super.key});

  @override
  State<Reservations> createState() => _ReservationsState();
}

class _ReservationsState extends State<Reservations> {
  late Future<List<Reservation>> _reservations;
  int selectedIndex = 2;
  final ReservationService _reservationService = ReservationService(baseUrl: 'https://10.0.2.2:7083/api');

  @override
  void initState() {
    super.initState();
    final userJMBG = Provider.of<UserProvider>(context, listen: false).user?.jmbg;
    _reservations = _reservationService.fetchReservationsByUserId(userJMBG!);
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
      body: FutureBuilder<List<Reservation>>(
        future: _reservations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No reservations found.'));
          } else {
            final reservations = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: reservations.length,
                itemBuilder: (context, index) {
                  final reservation = reservations[index];
                  return ReservationCard(
                    trainingProgramName: reservation.trainingProgramName,
                    time: reservation.time,
                    status: reservation.status,
                    reservationDate: reservation.date,
                    trainingTime: reservation.trainingTime, trainingDate: reservation.trainingDate,
                  );
                },
              ),
            );
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
