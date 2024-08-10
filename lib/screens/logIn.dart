import 'package:flutter/material.dart';
import 'package:fytness_system/models/user.dart';
import 'package:fytness_system/services/auth_service.dart';
import 'package:fytness_system/utils/global_colors.dart';
import 'package:fytness_system/widgets/global_button.dart';
import 'package:fytness_system/widgets/global_text_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();

  void _login() async {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty && password.isEmpty) {
      _showErrorDialog('Email and password cannot be empty.');
      return;
    } else if (email.isEmpty) {
      _showErrorDialog('Email cannot be empty.');
      return;
    } else if (password.isEmpty) {
      _showErrorDialog('Password cannot be empty.');
      return;
    }

    try {
      final response = await authService.login(email, password);
      if (response != null) {
        print('Login successful: ${response.jwtToken}');
        String role = authService.getUserRole(response.jwtToken);
        print('User role: $role');
        await authService.saveUserRole(role);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwtToken', response.jwtToken);

        final user = await authService.getUserFromJwt(response.jwtToken);
        if (user != null) {
          final userData = await authService.getUserData(user.jmbg, response.jwtToken, role);
          if (userData != null) {
            User updatedUser;
            if (role == 'Client') {
              updatedUser = user.copyWith(
                jmbg: userData['jmbg'] ?? '',
                name: userData['name'] ?? '',
                surname: userData['surname'] ?? '',
                email: userData['email'] ?? '',
                membershipPackageId: userData['membershipPackageId'],
                birthdate: userData['birthdate'] != null ? DateTime.parse(userData['birthdate']) : null,
                mobileNumber: userData['mobileNumber'] ?? '',
              );
            } else if (role == 'Trainer') {
              updatedUser = user.copyWith(
                jmbg: userData['jmbg'] ?? '',
                name: userData['name'] ?? '',
                surname: userData['surname'] ?? '',
                email: userData['email'] ?? '',
                specialty: userData['specialty'] ?? '',
              );
            } else {
              updatedUser = user.copyWith(
                jmbg: userData['jmbg'] ?? '',
                name: userData['name'] ?? '',
                surname: userData['surname'] ?? '',
                email: userData['email'] ?? '',
              );
            }
            _showSuccessDialog('Login successful!', () {
              Navigator.pushNamed(context, 'mainScreen/', arguments: updatedUser);
            });
          } else {
            _showErrorDialog('Failed to load user data.');
          }
        } else {
          _showErrorDialog('Invalid JWT token data.');
        }
      } else {
        _showErrorDialog('Login failed. Please check your email and password.');
      }
    } catch (e) {
      _showErrorDialog('An error occurred: $e');
    }
  }



  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFE6FE58),
        title: const Text(
          'Error',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        content: Text(
          message,
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message, VoidCallback onOkPressed) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFE6FE58),
        title: const Text(
          'Success',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        content: Text(
          message,
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onOkPressed();
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.darkGrey,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Let's log you in",
                  style: TextStyle(
                    color: Color(0xFFE6FE58),
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Welcome Back, You have been missed",
                  style: TextStyle(
                    color: Color(0xFFFEF9F1),
                    fontSize: 32,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 40),
                GlobalTextForm(controller: emailController, obscure: false, text: 'Email', textInputType: TextInputType.emailAddress),
                const SizedBox(height: 20),
                GlobalTextForm(controller: passwordController, obscure: true, text: 'Password', textInputType: TextInputType.text),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Forgot Password ?',
                    style: TextStyle(color: Color(0xFFFEF9F1)),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: GlobalButton(
                    text: 'Log In',
                    onPressed: _login,
                    backgroundColor: const Color(0xFFE6FE58),
                    textColor: const Color(0xFF050505),
                    width: double.infinity,
                  ),
                ),
                const SizedBox(height: 40),
                const Row(
                  children: [
                    Expanded(
                      child: Divider(color: Colors.white),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'or',
                        style: TextStyle(
                          color: Color(0xFFFEF9F1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                       alignment: Alignment.center,
                       child: Image.asset('assets/google.png'),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Image.asset('assets/facebook.png'),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Image.asset('assets/apple.png'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                       const Text(
                        "Don't have an account ?",
                        style: TextStyle(
                          color: Color(0xFFFEF9F1),
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, 'signIn/');
                      },
                      child: const Text(
                        " Register now!",
                        style: TextStyle(
                          color: Color(0xFFE6FE58),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),

        ),
      ),
    );
  }
}
