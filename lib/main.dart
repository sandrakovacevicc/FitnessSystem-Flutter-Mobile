import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fytness_system/screens/LogIn.dart';
import 'package:fytness_system/screens/home.dart';
import 'package:fytness_system/screens/main_screen.dart';
import 'package:fytness_system/screens/membership_packages.dart';
import 'package:fytness_system/screens/profile.dart';
import 'package:fytness_system/screens/sign_in.dart';
import 'package:fytness_system/screens/trainings.dart';
import 'package:provider/provider.dart';
import 'package:fytness_system/providers/user_provider.dart';

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
        routes: {
          'home/' : (context) => const Home(),
          'login/' : (context) => const Login(),
          'signIn/' : (context) => const SignIn(),
          'membershipPackages/' : (context) => const MembershipPackages(),
          'mainScreen/': (context) => const MainScreen(),
          'profile/' : (context) => const Profile(),
          'trainings/' : (context) => const Trainings(),
        },
      ),
    ),
  );
}
