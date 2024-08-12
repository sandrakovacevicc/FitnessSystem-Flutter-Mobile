import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class BottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: widget.selectedIndex,
      height: 60.0,
      items: <Widget>[
        Icon(
          Icons.home,
          size: 30,
          color: widget.selectedIndex == 0 ? Colors.black : Colors.white,
        ),
        Icon(
          Icons.fitness_center,
          size: 30,
          color: widget.selectedIndex == 1 ? Colors.black : Colors.white,
        ),
        Icon(
          Icons.class_,
          size: 30,
          color: widget.selectedIndex == 2 ? Colors.black : Colors.white,
        ),
        Icon(
          Icons.person,
          size: 30,
          color: widget.selectedIndex == 3 ? Colors.black : Colors.white,
        ),
      ],
      color: Colors.black,
      buttonBackgroundColor: const Color(0xFFE6FE58),
      backgroundColor: Colors.transparent,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 600),
      onTap: (index) {
        widget.onItemTapped(index);
      },
    );
  }
}
