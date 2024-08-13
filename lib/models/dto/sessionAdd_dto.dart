

class SessionAddDto {
  final DateTime date;
  final String time;
  final int duration;
  final int capacity;
  final String trainerJMBG;
  final int roomId;
  final int trainingProgramId;

  SessionAddDto({
    required this.date,
    required this.time,
    required this.duration,
    required this.capacity,
    required this.trainerJMBG,
    required this.roomId,
    required this.trainingProgramId,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'time': time,
      'duration': duration,
      'capacity': capacity,
      'trainerJMBG': trainerJMBG,
      'roomId': roomId,
      'trainingProgramId': trainingProgramId,
    };
  }
}
