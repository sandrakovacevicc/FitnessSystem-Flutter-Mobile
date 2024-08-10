import 'package:flutter/material.dart';
import 'package:fytness_system/models/user.dart';
import 'package:fytness_system/widgets/global_menu.dart';
import 'package:fytness_system/widgets/global_navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fytness_system/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:fytness_system/providers/user_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  String? jwtToken;
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadJwtToken();
  }

  Future<void> _loadJwtToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      jwtToken = prefs.getString('jwtToken');
    });

    if (jwtToken != null) {
      print('Loaded JWT token: $jwtToken');
      final user = await authService.getUserFromJwt(jwtToken!);
      if (user != null) {
        final userData = await authService.getUserData(user.jmbg, jwtToken!, user.role);
        if (userData != null) {
          User updatedUser;
          if (user.role == 'Client') {
            updatedUser = user.copyWith(
              name: userData['name'] ?? '',
              surname: userData['surname'] ?? '',
              email: userData['email'] ?? '',
              jmbg: userData['jmbg'] ?? '',
              membershipPackageId: userData['membershipPackageId'],
              birthdate: userData['birthdate'] != null ? DateTime.parse(userData['birthdate']) : null,
              mobileNumber: userData['mobileNumber'] ?? '',
            );
          } else if (user.role == 'Trainer') {
            updatedUser = user.copyWith(
              name: userData['name'] ?? '',
              surname: userData['surname'] ?? '',
              email: userData['email'] ?? '',
              jmbg: userData['jmbg'] ?? '',
              specialty: userData['specialty'] ?? '',
            );
          } else {
            updatedUser = user.copyWith(
              name: userData['name'] ?? '',
              surname: userData['surname'] ?? '',
              email: userData['email'] ?? '',
              jmbg: userData['jmbg'] ?? '',
            );
          }
          Provider.of<UserProvider>(context, listen: false).setUser(updatedUser);
        } else {
          print('Failed to load user data');
        }
      } else {
        print('Invalid JWT token data');
      }
    } else {
      print('No JWT token found');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: const NavBar(automaticallyImplyLeading: false),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: user != null
                  ? Text('Welcome, ${user.name} ${user.surname}', style: const TextStyle(fontSize: 20))
                  : const Text('Welcome', style: TextStyle(fontSize: 24)),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
