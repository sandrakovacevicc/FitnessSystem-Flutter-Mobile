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
                  ? Text('Welcome, ${user.name} ${user.surname}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
                  : const Text('Welcome', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 20.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8.0,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About our Fitness Hub!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            'At Fitness Hub, we are dedicated to helping you achieve your fitness goals. Whether you are looking to build muscle, lose weight, or improve your overall health, our state-of-the-art facilities and expert trainers are here to support you every step of the way.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 20.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6FE58),
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8.0,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Meet Our Trainers',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            'Our team of professional trainers is here to help you reach your fitness potential. With years of experience and a passion for fitness, they offer personalized training programs tailored to your needs. Get to know them and find the perfect trainer for you!',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Text(
                          'Our Trainers',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        height: 150,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _trainerAvatar('https://nationalpti.org/wp-content/uploads/2014/02/Personal-Trainer.jpg', 'Zika Zikic'),
                            _trainerAvatar('https://media.istockphoto.com/id/675179390/photo/muscular-trainer-writing-on-clipboard.jpg?s=612x612&w=0&k=20&c=9NKx1AwVMpPY0YBlk5H-hxx2vJSCu1Wc78BKRM9wFq0=', 'Pera Peric'),
                            _trainerAvatar('https://www.shutterstock.com/image-photo/portrait-female-personal-trainer-holding-260nw-2249557387.jpg', 'Sandra Kovacevic'),
                            _trainerAvatar('https://www.shutterstock.com/image-photo/portrait-female-personal-trainer-holding-260nw-2249557387.jpg', 'Sandra Kovacevic'),
                          ],
                        ),
                      ),
                    ),
                  ],
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

  Widget _trainerAvatar(String imageUrl, String name) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(imageUrl),
          ),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
