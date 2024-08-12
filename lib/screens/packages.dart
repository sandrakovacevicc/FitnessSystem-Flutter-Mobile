import 'package:flutter/material.dart';
import 'package:fytness_system/widgets/global_navbar.dart';
class Packages extends StatefulWidget {
  const Packages({super.key});

  @override
  State<Packages> createState() => _PackagesState();
}

class _PackagesState extends State<Packages> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: NavBar(automaticallyImplyLeading: true,),
    );
  }
}
