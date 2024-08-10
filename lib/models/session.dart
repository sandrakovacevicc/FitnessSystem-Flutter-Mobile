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
    required this.trainerEmail, // Added email
    required this.trainerSpecialty, // Added specialty
    required this.roomName,
    required this.trainingProgramName,
    required this.trainingProgramDescription, // Added description
    required this.trainingProgramType, // Added type
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      sessionId: json['sessionId'],
      date: DateTime.parse(json['date']),
      time: TimeOfDay(
        hour: int.parse(json['time'].split(':')[0]),
        minute: int.parse(json['time'].split(':')[1]),
      ),
      duration: json['duration'],
      capacity: json['capacity'],
      trainerJMBG: json['trainer']['jmbg'],
      trainerName: json['trainer']['name'],
      trainerSurname: json['trainer']['surname'],
      trainerEmail: json['trainer']['email'], // Added email
      trainerSpecialty: json['trainer']['specialty'], // Added specialty
      roomName: json['room']['roomName'],
      trainingProgramName: json['trainingProgram']['name'],
      trainingProgramDescription: json['trainingProgram']['description'], // Added description
      trainingProgramType: json['trainingProgram']['trainingType'], // Added type
    );
  }
}
