import 'package:flutter/material.dart';
import 'package:fytness_system/models/training_program.dart';
import 'package:fytness_system/services/training_program_service.dart';
import 'package:fytness_system/widgets/global_program_card.dart';
import '../widgets/global_navbar.dart';

class TrainingPrograms extends StatefulWidget {
  const TrainingPrograms({super.key});

  @override
  State<TrainingPrograms> createState() => _TrainingProgramsState();
}

class _TrainingProgramsState extends State<TrainingPrograms> {
  late Future<List<TrainingProgram>> futureTrainingPrograms;

  @override
  void initState() {
    super.initState();
    futureTrainingPrograms = TrainingProgramService().fetchTrainingPrograms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavBar(automaticallyImplyLeading: true),
      backgroundColor: Colors.grey[900],
      body: FutureBuilder<List<TrainingProgram>>(
        future: futureTrainingPrograms,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No training programs available.'));
          } else {
            final program = snapshot.data;

            final nonNullPrograms = program!.toList();
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: nonNullPrograms.length,
              itemBuilder: (context, index) {
                final program = nonNullPrograms[index];
                return GlobalProgramCard(
                  trainingProgram: program,
                  id: program.trainingProgramId,
                );
              },
            );
          }
        },
      ),
    );
  }
}
