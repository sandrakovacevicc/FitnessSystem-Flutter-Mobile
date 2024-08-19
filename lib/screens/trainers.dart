import 'package:flutter/material.dart';
import 'package:fytness_system/models/user.dart';
import 'package:fytness_system/services/auth_service.dart';
import 'package:fytness_system/widgets/global_trainer_card.dart';
import '../widgets/global_navbar.dart';

class Trainers extends StatefulWidget {
  const Trainers({super.key});

  @override
  State<Trainers> createState() => _TrainersState();
}

class _TrainersState extends State<Trainers> {
  late Future<List<User>> futureTrainers;

  @override
  void initState() {
    super.initState();
    futureTrainers = AuthService().fetchTrainers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavBar(automaticallyImplyLeading: true),
      backgroundColor: Colors.grey[900],
      body: FutureBuilder<List<User>>(
        future: futureTrainers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No trainers available.'));
          } else {
            final packages = snapshot.data;

            final nonNullPackages = packages!.toList();

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: nonNullPackages.length,
              itemBuilder: (context, index) {
                final trainer = nonNullPackages[index];
                return GlobalTrainerCard(
                  user: trainer,
                );
              },
            );
          }
        },
      ),
    );
  }
}
