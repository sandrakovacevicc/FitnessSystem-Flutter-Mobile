import 'package:flutter/material.dart';

class NavBar extends StatefulWidget implements PreferredSizeWidget {
  final bool automaticallyImplyLeading;

  const NavBar({super.key, this.automaticallyImplyLeading = true});

  @override
  State<NavBar> createState() => _NavBarState();

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      centerTitle: true,
      automaticallyImplyLeading: widget.automaticallyImplyLeading,
      title: Image.asset(
        'assets/logo1.png',
        height: 45,
      ),
    );
  }
}
