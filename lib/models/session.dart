import 'package:flutter/material.dart';

class Session {
  final int sessionId;
  final DateTime date;
  final TimeOfDay time;
  final int duration;
  final int capacity;
  final String trainerJMBG;
  final String trainerName;
  final String trainerSurname;
  final String trainerEmail;
  final String trainerSpecialty;
  final String roomName;
  final String trainingProgramName;
  final String trainingProgramDescription;
  final String trainingProgramType;

  Session({
    required this.sessionId,
    required this.date,
    required this.time,
    required this.duration,
    required this.capacity,
    required this.trainerJMBG,
    required this.trainerName,
    required this.trainerSurname,
    required this.trainerEmail,
    required this.trainerSpecialty,
    required this.roomName,
    required this.trainingProgramName,
    required this.trainingProgramDescription,
    required this.trainingProgramType,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      sessionId: json['sessionId'] ?? 0,
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      time: TimeOfDay(
        hour: int.tryParse(json['time']?.split(':')[0] ?? '0') ?? 0,
        minute: int.tryParse(json['time']?.split(':')[1] ?? '0') ?? 0,
      ),
      duration: json['duration'] ?? 0,
      capacity: json['capacity'] ?? 0,
      trainerJMBG: json['trainer']?['jmbg'] ?? '',
      trainerName: json['trainer']?['name'] ?? '',
      trainerSurname: json['trainer']?['surname'] ?? '',
      trainerEmail: json['trainer']?['email'] ?? '',
      trainerSpecialty: json['trainer']?['specialty'] ?? '',
      roomName: json['room']?['roomName'] ?? '',
      trainingProgramName: json['trainingProgram']?['name'] ?? '',
      trainingProgramDescription: json['trainingProgram']?['description'] ?? '',
      trainingProgramType: json['trainingProgram']?['trainingType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'date': date.toIso8601String(),
      'time': '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}', // TimeOfDay formatted as HH:mm
      'duration': duration,
      'capacity': capacity,
      'trainer': {
        'jmbg': trainerJMBG,
        'name': trainerName,
        'surname': trainerSurname,
        'email': trainerEmail,
        'specialty': trainerSpecialty,
      },
      'room': {
        'roomName': roomName,
      },
      'trainingProgram': {
        'name': trainingProgramName,
        'description': trainingProgramDescription,
        'trainingType': trainingProgramType,
      },
    };
  }
}
