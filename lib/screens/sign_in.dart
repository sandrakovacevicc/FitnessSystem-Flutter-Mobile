import 'package:flutter/material.dart';
import 'package:fytness_system/utils/global_colors.dart';
import 'package:fytness_system/widgets/global_button.dart';
import 'package:fytness_system/widgets/global_text_form.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController jmbgController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final userData = {
        'name': nameController.text,
        'surname': surnameController.text,
        'jmbg': jmbgController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'birthday': birthdayController.text,
        'password': passwordController.text,
      };

      Navigator.pushNamed(context, 'membershipPackages/', arguments: userData);
    }
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  String? validateSurname(String? value) {
    if (value == null || value.isEmpty) {
      return 'Surname is required';
    }
    return null;
  }

  String? validateJmbg(String? value) {
    if (value == null || value.isEmpty) {
      return 'JMBG is required';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.darkGrey,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 25, 20, 20),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Let's Register",
                    style: TextStyle(
                      color: Color(0xFFE6FE58),
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Account",
                    style: TextStyle(
                      color: Color(0xFFE6FE58),
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Hello user, you will have a greatful journey",
                    style: TextStyle(
                      color: Color(0xFFFEF9F1),
                      fontSize: 22,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GlobalTextForm(
                    controller: nameController,
                    obscure: false,
                    text: 'Name',
                    textInputType: TextInputType.text,
                    validator: validateName,
                  ),
                  const SizedBox(height: 20),
                  GlobalTextForm(
                    controller: surnameController,
                    obscure: false,
                    text: 'Surname',
                    textInputType: TextInputType.text,
                    validator: validateSurname,
                  ),
                  const SizedBox(height: 20),
                  GlobalTextForm(
                    controller: jmbgController,
                    obscure: false,
                    text: 'Jmbg',
                    textInputType: TextInputType.text,
                    validator: validateJmbg,
                  ),
                  const SizedBox(height: 20),
                  GlobalTextForm(
                    controller: emailController,
                    obscure: false,
                    text: 'Email address',
                    textInputType: TextInputType.emailAddress,
                    validator: validateEmail,
                  ),
                  const SizedBox(height: 20),
                  GlobalTextForm(
                    controller: phoneController,
                    obscure: false,
                    text: 'Phone number',
                    textInputType: TextInputType.phone,
                    validator: validatePhone,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9).withOpacity(0.07),
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(color: const Color(0xFFFEF9F1)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.03),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: birthdayController,
                      decoration: const InputDecoration(
                        hintText: 'Birthday',
                        hintStyle: TextStyle(
                          color: Color(0xFFFEF9F1),
                        ),
                        suffixIcon: Icon(Icons.calendar_today, color: Color(0xFFFEF9F1)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      style: const TextStyle(
                        color: Color(0xFFFEF9F1),
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          birthdayController.text = "${pickedDate.toLocal()}".split(' ')[0];
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  GlobalTextForm(
                    controller: passwordController,
                    obscure: true,
                    text: 'Password',
                    textInputType: TextInputType.text,
                    validator: validatePassword,
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: GlobalButton(
                      text: 'Choose your membership package',
                      onPressed: () {
                        _submit();
                      },
                      backgroundColor: const Color(0xFFE6FE58),
                      textColor: const Color(0xFF050505),
                      width: double.infinity,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account ?",
                        style: TextStyle(
                          color: Color(0xFFFEF9F1),
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, 'login/');
                        },
                        child: const Text(
                          " Log In!",
                          style: TextStyle(
                            color: Color(0xFFE6FE58),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
