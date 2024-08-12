import 'package:flutter/material.dart';
import 'package:fytness_system/widgets/global_navbar.dart';
class TrainingPrograms extends StatefulWidget {
  const TrainingPrograms({super.key});

  @override
  State<TrainingPrograms> createState() => _TrainingProgramsState();
}

class _TrainingProgramsState extends State<TrainingPrograms> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: NavBar(automaticallyImplyLeading: true,),
    );
  }
}
