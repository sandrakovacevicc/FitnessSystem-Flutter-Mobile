import 'package:flutter/material.dart';
import 'package:fytness_system/widgets/global_navbar.dart';
class Clients extends StatefulWidget {
  const Clients({super.key});

  @override
  State<Clients> createState() => _ClientsState();
}

class _ClientsState extends State<Clients> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: NavBar(automaticallyImplyLeading: true,),
    );
  }
}
