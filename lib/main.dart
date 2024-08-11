import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fytness_system/screens/LogIn.dart';
import 'package:fytness_system/screens/home.dart';
import 'package:fytness_system/screens/main_screen.dart';
import 'package:fytness_system/screens/membership_packages.dart';
import 'package:fytness_system/screens/profile.dart';
import 'package:fytness_system/screens/reservations.dart';
import 'package:fytness_system/screens/sign_in.dart';
import 'package:fytness_system/screens/trainings.dart';
import 'package:provider/provider.dart';
import 'package:fytness_system/providers/user_provider.dart';
import 'package:fytness_system/models/user.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: 'home/',
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case 'membershipPackages/':
                final args = settings.arguments as User;
                return MaterialPageRoute(
                  builder: (context) => MembershipPackages(user: args),
                );
              default:
                return MaterialPageRoute(
                  builder: (context) {
                    switch (settings.name) {
                      case 'home/':
                        return const Home();
                      case 'login/':
                        return const Login();
                      case 'signIn/':
                        return const SignIn();
                      case 'mainScreen/':
                        return const MainScreen();
                      case 'profile/':
                        return const Profile();
                      case 'trainings/':
                        return const Trainings();
                      case 'reservations/':
                        return const Reservations();
                      default:
                        return const Home(); // Default route
                    }
                  },
                );
            }
          }
      ),
    ),
  );
}
