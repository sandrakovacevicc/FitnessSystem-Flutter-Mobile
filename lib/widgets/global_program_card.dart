import 'package:flutter/material.dart';
import 'package:fytness_system/models/training_program.dart';
import 'package:fytness_system/services/training_program_service.dart';

class GlobalProgramCard extends StatefulWidget {
  final TrainingProgram trainingProgram;
  final int id;

  const GlobalProgramCard({
    super.key,
    required this.trainingProgram,
    required this.id,
  });

  @override
  State<GlobalProgramCard> createState() => _GlobalProgramCardState();
}

class _GlobalProgramCardState extends State<GlobalProgramCard> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _trainingDurationInMinutesController;
  late TextEditingController _trainingTypeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.trainingProgram.name ?? '');
    _descriptionController = TextEditingController(text: widget.trainingProgram.description ?? '');
    _trainingDurationInMinutesController = TextEditingController(text: widget.trainingProgram.trainingDurationInMinutes?.toString() ?? '0');
    _trainingTypeController = TextEditingController(text: widget.trainingProgram.trainingType ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _trainingDurationInMinutesController.dispose();
    _trainingTypeController.dispose();
    super.dispose();
  }

  String getProgramImage(String programName) {
    return {
      'hiit': 'assets/hiit.jpg',
      'yoga': 'assets/yoga.jpg',
      'pilates': 'assets/pilates.jpg',
      'crossfit': 'assets/crossfit.jpg',
      'spinning': 'assets/spinning.jpg',
    }[programName.toLowerCase()] ?? 'assets/default.jpg';
  }

  Future<void> _onEditButtonPressed() async {
    final updatedProgram = TrainingProgram(
      trainingProgramId: widget.id,
      name: _nameController.text,
      description: _descriptionController.text,
      trainingDurationInMinutes: int.tryParse(_trainingDurationInMinutesController.text) ?? 0,
      trainingType: _trainingTypeController.text,
    );

    try {
      print('Updating program with data: ${updatedProgram.toJson()}');
      await TrainingProgramService().updateTrainingProgram(updatedProgram);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Training program updated successfully!')),
      );
    } catch (e) {
      print('Failed to update training program: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update training program: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl = getProgramImage(widget.trainingProgram.name ?? '');

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
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.card_membership, color: Colors.black, size: 28),
                    const SizedBox(width: 8),
                    Flexible(
                      child: TextField(
                        controller: _nameController,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter description',
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.access_time, color: Colors.black, size: 18),
                            const SizedBox(width: 6),
                            SizedBox(
                              width: 55,
                              child: TextField(
                                controller: _trainingDurationInMinutesController,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  suffixText: 'min',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.category, color: Colors.black, size: 18),
                            const SizedBox(width: 6),
                            SizedBox(
                              width: 80,
                              child: TextField(
                                controller: _trainingTypeController,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter training type',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
