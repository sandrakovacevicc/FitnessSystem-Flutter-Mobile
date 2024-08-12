import 'package:flutter/material.dart';
import 'package:fytness_system/widgets/global_navbar.dart';
class Sessions extends StatefulWidget {
  const Sessions({super.key});

  @override
  State<Sessions> createState() => _SessionsState();
}

class _SessionsState extends State<Sessions> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: NavBar(automaticallyImplyLeading: true,),
    );
  }
}
