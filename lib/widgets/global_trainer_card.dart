import 'package:flutter/material.dart';
import 'package:fytness_system/models/user.dart';
import 'package:fytness_system/services/auth_service.dart';

class GlobalTrainerCard extends StatefulWidget {
  final User user;
  final String jmbg;

  const GlobalTrainerCard({
    super.key,
    required this.user,
    required this.jmbg,
  });

  @override
  State<GlobalTrainerCard> createState() => _GlobalTrainerCardState();
}

class _GlobalTrainerCardState extends State<GlobalTrainerCard> {
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _jmbgController;
  late TextEditingController _emailController;
  late TextEditingController _specialityController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _surnameController = TextEditingController(text: widget.user.surname);
    _jmbgController = TextEditingController(text: widget.user.jmbg);
    _emailController = TextEditingController(text: widget.user.email);
    _specialityController = TextEditingController(text: widget.user.specialty);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _jmbgController.dispose();
    _emailController.dispose();
    _specialityController.dispose();
    super.dispose();
  }

  String getTrainerImage(String trainerName) {
    return {
      'Sandra': 'assets/sandra.jpg',
      'Nikola': 'assets/nikola.jpg',
      'Milica': 'assets/milica.jpg',
      'Zika': 'assets/zika.jpg',
      'Marko': 'assets/marko.jpg',
    }[trainerName] ?? 'assets/default_trainer.jpg';
  }

  Future<void> _onEditButtonPressed() async {
    if (_formKey.currentState!.validate()) {
      final updatedTrainer = User(
        jmbg: widget.user.jmbg,
        name: widget.user.name,
        surname: widget.user.surname,
        email: _emailController.text,
        specialty: _specialityController.text,
        role: 'Trainer',
      );

      try {
        await AuthService().updateTrainer(updatedTrainer);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Trainer updated successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update trainer: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl = getTrainerImage(widget.user.name);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 6,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            child: Image.asset(
              imageUrl,
              height: 200, // Increased image height
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          controller: _nameController,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            border: InputBorder.none,
                          ),
                          readOnly: true,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Flexible(
                        child: TextFormField(
                          controller: _surnameController,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Surname',
                            border: InputBorder.none,
                          ),
                          readOnly: true,
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: _jmbgController,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Jmbg',
                      border: InputBorder.none,
                    ),

                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _specialityController,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Specialty (years)',
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the number of years';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _onEditButtonPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE6FE58), // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    child: const Text(
                      'Edit',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
