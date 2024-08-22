import 'package:intl/intl.dart';

class Reservation {
  final int reservationId;
  final DateTime date;
  final String time;
  final String clientJMBG;
  final int sessionId;
  final String status;
  final String trainingProgramName;
  final DateTime trainingDate;
  final String trainingTime;

  Reservation({
    required this.reservationId,
    required this.date,
    required this.time,
    required this.clientJMBG,
    required this.sessionId,
    required this.status,
    required this.trainingProgramName,
    required this.trainingDate,
    required this.trainingTime,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    final session = json['session'] ?? {};
    final trainingProgram = session['trainingProgram'] ?? {};

    final parsedTime = DateFormat.Hm().parse(json['time'] ?? '00:00');
    final formattedTime = DateFormat('HH:mm').format(parsedTime);

    return Reservation(
      reservationId: json['reservationId'] ?? 0,
      date: DateTime.parse(json['date']),
      time: formattedTime,
      clientJMBG: json['client']['jmbg'] ?? '',
      sessionId: session['sessionId'] ?? 0,
      status: json['status'] ?? '',
      trainingProgramName: trainingProgram['name'] ?? '',
      trainingDate: DateTime.parse(session['date'] ?? DateTime.now().toIso8601String()),
      trainingTime: session['time'] ?? '',
    );
  }
}
