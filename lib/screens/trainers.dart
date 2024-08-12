import 'package:flutter/material.dart';
import 'package:fytness_system/widgets/global_navbar.dart';
class Trainers extends StatefulWidget {
  const Trainers({super.key});

  @override
  State<Trainers> createState() => _TrainersState();
}

class _TrainersState extends State<Trainers> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: NavBar(automaticallyImplyLeading: true,),
    );
  }
}
