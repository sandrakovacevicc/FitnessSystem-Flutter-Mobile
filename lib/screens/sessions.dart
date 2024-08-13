import 'package:flutter/material.dart';
import 'package:fytness_system/models/dto/sessionAdd_dto.dart';
import 'package:fytness_system/models/user.dart';
import 'package:fytness_system/services/auth_service.dart';
import 'package:fytness_system/widgets/global_navbar.dart';
import 'package:fytness_system/services/room_service.dart';
import 'package:fytness_system/services/training_program_service.dart';
import 'package:fytness_system/models/room.dart';
import 'package:fytness_system/models/training_program.dart';
import 'package:fytness_system/services/session_service.dart';
import 'package:intl/intl.dart';

class Sessions extends StatefulWidget {
  const Sessions({super.key});

  @override
  State<Sessions> createState() => _SessionsState();
}

class _SessionsState extends State<Sessions> {
  final String baseUrl = 'https://10.0.2.2:7083/api';
  late Future<List<Room>> _rooms;
  late Future<List<User>> _trainers;
  late Future<List<TrainingProgram>> _programs;

  String _selectedTrainerJMBG = '';
  int? _selectedRoomId;
  int? _selectedTrainingProgramId;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final TextEditingController _durationController = TextEditingController(text: '60');
  final TextEditingController _capacityController = TextEditingController(text: '20');

  @override
  void initState() {
    super.initState();
    _rooms = RoomService(baseUrl: 'https://10.0.2.2:7083/api/rooms').fetchRooms();
    _trainers = AuthService().fetchTrainers();
    _programs = TrainingProgramService().fetchTrainingPrograms();
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavBar(
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Add Session', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextButton(
              onPressed: _selectDate,
              child: Text(
                _selectedDate == null
                    ? 'Select Date'
                    : 'Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}',
              ),
            ),
            TextButton(
              onPressed: _selectTime,
              child: Text(
                _selectedTime == null
                    ? 'Select Time'
                    : 'Time: ${_selectedTime!.format(context)}',
              ),
            ),
            const SizedBox(height: 20),
            FutureBuilder<List<User>>(
              future: _trainers,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No trainers available');
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Select Trainer'),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: snapshot.data!.map((trainer) {
                            final isSelected = _selectedTrainerJMBG == trainer.jmbg;
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedTrainerJMBG = trainer.jmbg;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 16), // Razmak između trenera
                                decoration: BoxDecoration(
                                  border: isSelected
                                      ? Border.all(color: Colors.blue, width: 2)
                                      : null,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: AssetImage(getTrainerImage(trainer.name)),
                                      radius: 30,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      trainer.name,
                                      style: TextStyle(
                                        color: isSelected ? Colors.blue : Colors.black,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),

            const SizedBox(height: 20),
            FutureBuilder<List<Room>>(
              future: _rooms,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No rooms available');
                } else {
                  return DropdownButtonFormField<int>(
                    decoration: const InputDecoration(labelText: 'Select Room'),
                    items: snapshot.data!.map<DropdownMenuItem<int>>((room) {
                      return DropdownMenuItem<int>(
                        value: room.RoomId,
                        child: Text(room.RoomName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedRoomId = value;
                      });
                    },
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            FutureBuilder<List<TrainingProgram>>(
              future: _programs,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No programs available');
                } else {
                  return DropdownButtonFormField<int>(
                    decoration: const InputDecoration(labelText: 'Select Training Program'),
                    items: snapshot.data!.map<DropdownMenuItem<int>>((program) {
                      return DropdownMenuItem<int>(
                        value: program.trainingProgramId,
                        child: Row(
                          children: [
                            Image.asset(getProgramImage(program.name!), width: 40, height: 40),
                            const SizedBox(width: 10),
                            Text(program.name!),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedTrainingProgramId = value;
                      });
                    },
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _durationController,
              decoration: const InputDecoration(labelText: 'Duration (minutes)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _capacityController,
              decoration: const InputDecoration(labelText: 'Capacity'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createSession,
              child: const Text('Create Session'),
            ),
          ],
        ),
      ),
    );
  }

  void _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate!,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }


  void _createSession() {
    if (_selectedTrainerJMBG.isEmpty || _selectedRoomId == null || _selectedTrainingProgramId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final String timeFormatted = _selectedTime == null
        ? '' // Default value if time is not selected
        : '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}:00';

    final sessionDto = SessionAddDto(
      date: _selectedDate!,
      time: timeFormatted,
      duration: int.tryParse(_durationController.text) ?? 0,
      capacity: int.tryParse(_capacityController.text) ?? 0,
      trainerJMBG: _selectedTrainerJMBG,
      roomId: _selectedRoomId!,
      trainingProgramId: _selectedTrainingProgramId!,
    );

    print('Request Body: ${sessionDto.toJson()}');

    SessionService(baseUrl: baseUrl).createSession(sessionDto).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Session created successfully')),
      );
      Navigator.pop(context);
    }).catchError((error) {
      print('Error creating session: $error'); // Log error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    });
  }





  String getProgramImage(String programName) {
    return {
      'HIIT': 'assets/hiit.jpg',
      'Yoga': 'assets/yoga.jpg',
      'Pilates': 'assets/pilates.jpg',
      'Crossfit': 'assets/crossfit.jpg',
      'Spinning': 'assets/spinning.jpg',
    }[programName] ?? 'assets/default_program.jpg';
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
}
