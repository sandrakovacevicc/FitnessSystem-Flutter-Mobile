import 'package:flutter/material.dart';
import 'package:fytness_system/screens/LogIn.dart';
import 'package:fytness_system/screens/sign_in.dart';
import 'package:fytness_system/widgets/global_button.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/home_page.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(35.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start, // Aligns children at the bottom
            children: [
              const Text(
                "NO MORE EXCUSES |",
                style: TextStyle(
                  color: Color(0xFFFEF9F1),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE6FE58), // Background color
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                padding: const EdgeInsets.all(5.0),
                child: const Text(
                  "DO IT NOW",
                  style: TextStyle(
                    color: Color(0xFF050505),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20), // Space below the text
              const Text(
                "Achieve your fitness goals with our expert trainers! Join us for personalized workouts that get results!",
                style: TextStyle(
                  color: Color(0xFFFEF9F1),
                  fontSize: 16,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9).withOpacity(0.10), // Background color
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Center the buttons
                  children: [
                    GlobalButton(
                      text: 'Log In',
                      onPressed: () {
                        Navigator.pushNamed(context, 'login/');
                      },
                      backgroundColor: const Color(0xFFD9D9D9).withOpacity(0.15),
                      textColor: const Color(0xFFFEF9F1),
                      width: 130,
                    ),
                    const SizedBox(width: 5),
                    GlobalButton(
                      text: 'Sign Up',
                      onPressed: () {
                        Navigator.pushNamed(context, 'signIn/');
                      },
                      backgroundColor: const Color(0xFFE6FE58),
                      textColor: const Color(0xFF050505),
                      width: 130,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
