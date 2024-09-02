import 'package:flutter/material.dart';
import 'package:fytness_system/models/dto/sessionAdd_dto.dart';
import 'package:fytness_system/models/user.dart';
import 'package:fytness_system/services/auth_service.dart';
import 'package:fytness_system/widgets/global_button.dart';
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
  final String baseUrl = 'https://172.20.10.2:7083/api';
  //final String baseUrl = 'https://10.0.2.2:7083/api';
  late Future<List<Room>> _rooms;
  late Future<List<User>> _trainers;
  late Future<List<TrainingProgram>> _programs;

  String _selectedTrainerJMBG = '';
  int? _selectedRoomId;
  int? _selectedTrainingProgramId;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final TextEditingController _durationController = TextEditingController(text: '60');
  final TextEditingController _capacityController = TextEditingController(text: '10');

  @override
  void initState() {
    super.initState();
    _rooms = RoomService(baseUrl: baseUrl).fetchRooms();
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
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create new session',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              _buildDatePicker(),
              _buildTimePicker(),
              const SizedBox(height: 20),
              _buildTrainerSelection(),
              const SizedBox(height: 20),
              _buildRoomDropdown(),
              const SizedBox(height: 20),
              _buildTrainingProgramDropdown(),
              const SizedBox(height: 20),
              _buildDurationField(),
              const SizedBox(height: 20),
              _buildCapacityField(),
              const SizedBox(height: 20),
              _buildCreateSessionButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Card(
      elevation: 4,
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.calendar_today, color: Color(0xFFE6FE58),),
        title: Text(
          _selectedDate == null
              ? 'Select Date'
              : 'Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}',
          style: const TextStyle(color: Color(0xFFE6FE58)),),
        onTap: _selectDate,
      ),
    );
  }

  Widget _buildTimePicker() {
    return Card(
      elevation: 4,
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.access_time, color: Color(0xFFE6FE58),),
        title: Text(
          _selectedTime == null
              ? 'Select Time'
              : 'Time: ${_selectedTime!.format(context)}',
          style: const TextStyle(color: Color(0xFFE6FE58)),),
        onTap: _selectTime,
      ),
    );
  }

  Widget _buildTrainerSelection() {
    return FutureBuilder<List<User>>(
      future: _trainers,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No trainers available');
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Trainer',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Row(
                    children: snapshot.data!.map((trainer) {
                      final isSelected = _selectedTrainerJMBG == trainer.jmbg;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTrainerJMBG = trainer.jmbg;
                          });
                        },
                        child: Card(
                          color: Colors.black,
                          margin: const EdgeInsets.only(right: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: isSelected ? 4 : 2,
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
                                  color: isSelected ? const Color(0xFFE6FE58) : Colors.white,
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
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildRoomDropdown() {
    return FutureBuilder<List<Room>>(
      future: _rooms,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No rooms available');
        } else {
          return Card(
            elevation: 4,
            color: Colors.grey[900],
            child: DropdownButtonFormField<int>(
              dropdownColor: Colors.black,
              decoration: const InputDecoration(
                labelText: 'Select Room',
                labelStyle: TextStyle(color: Color(0xFFE6FE58)),
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
              items: snapshot.data!.map<DropdownMenuItem<int>>((room) {
                return DropdownMenuItem<int>(
                  value: room.RoomId,
                  child: Row(
                    children: [
                      Image.asset(getRoomImage(room.RoomName), width: 40, height: 40),
                      const SizedBox(width: 10),
                      Text(
                        room.RoomName,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRoomId = value;
                });
              },
            ),
          );
        }
      },
    );
  }

  Widget _buildTrainingProgramDropdown() {
    return FutureBuilder<List<TrainingProgram>>(
      future: _programs,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No programs available');
        } else {
          return Card(
            color: Colors.grey[900],
            elevation: 4,
            child: DropdownButtonFormField<int>(
              dropdownColor: Colors.black,
              decoration: const InputDecoration(
                labelText: 'Select Training Program',
                labelStyle: TextStyle(color: Color(0xFFE6FE58)),
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
              items: snapshot.data!.map<DropdownMenuItem<int>>((program) {
                return DropdownMenuItem<int>(
                  value: program.trainingProgramId,
                  child: Row(
                    children: [
                      Image.asset(getProgramImage(program.name!), width: 40, height: 40),
                      const SizedBox(width: 10),
                      Text(
                        program.name!,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTrainingProgramId = value;
                });
              },
            ),
          );
        }
      },
    );
  }

  Widget _buildDurationField() {
    return Card(
      elevation: 4,
      color: Colors.grey[900],
      child: TextFormField(
        controller: _durationController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: 'Duration (in minutes)',
          labelStyle: TextStyle(color: Color(0xFFE6FE58)),
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildCapacityField() {
    return Card(
      elevation: 4,
      color: Colors.grey[900],
      child: TextFormField(
        controller: _capacityController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: 'Capacity',
          labelStyle: TextStyle(color: Color(0xFFE6FE58)),
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildCreateSessionButton() {
    return Center(
      child: GlobalButton(
        onPressed: _createSession,
        text:'Create Session',
        width: 180,
      ),
    );
  }

  Future<void> _selectDate() async {
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

  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime!,
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _createSession() async {
    if (_selectedTrainerJMBG.isEmpty || _selectedRoomId == null || _selectedTrainingProgramId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    DateTime now = DateTime.now();
    DateTime selectedDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    if (selectedDateTime.isBefore(now)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You cannot schedule a session in the past')),
      );
      return;
    }

    try {
      final String formattedHour = _selectedTime!.hour.toString().padLeft(2, '0');
      final String formattedMinute = _selectedTime!.minute.toString().padLeft(2, '0');
      final String timeFormatted = '$formattedHour:$formattedMinute:00';

      final SessionAddDto sessionDto = SessionAddDto(
        trainerJMBG: _selectedTrainerJMBG,
        roomId: _selectedRoomId!,
        trainingProgramId: _selectedTrainingProgramId!,
        date: _selectedDate!,
        time: timeFormatted,
        duration: int.parse(_durationController.text),
        capacity: int.parse(_capacityController.text),
      );

      await SessionService(baseUrl: baseUrl).createSession(sessionDto);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Session created successfully')),
      );
    } catch (e) {
      String errorMessage = 'Failed to create session. Please try again later.';
      if (e.toString().contains('The selected trainer is already booked for this time slot')) {
        errorMessage = 'The selected trainer is already booked for this time slot. Please choose a different time or trainer.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }




  String getRoomImage(String roomName) {
    return {
      'cardio zone': 'assets/cardioZone.jpg',
      'bicycle room': 'assets/bicycleRoom.jpg',
      'training hall': 'assets/trainingHall.jpg',
      'meditation room': 'assets/meditationRoom.jpg',
    }[roomName.toLowerCase()] ?? 'assets/default.jpg';
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
