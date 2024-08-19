import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TrainerSessionCard extends StatelessWidget {
  final String trainingProgramName;
  final DateTime trainingDate;
  final TimeOfDay trainingTime;
  final String trainerName;
  final int capacity;
  final String status;
  final String roomName;

  const TrainerSessionCard({
    super.key,
    required this.trainingProgramName,
    required this.trainingDate,
    required this.trainingTime,
    required this.trainerName,
    required this.capacity,
    this.status = '',
    required this.roomName,
  });


  String _formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final time = DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    return DateFormat('HH:mm').format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.black.withOpacity(0.9),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Training Program Name with Icon
              Row(
                children: [
                  const Icon(
                    Icons.fitness_center,
                    color: Color(0xFFE6FE58),
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      trainingProgramName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE6FE58),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Text(
                '${DateFormat('d MMM yyyy').format(trainingDate)} - ${_formatTimeOfDay(trainingTime)}h',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),


              Row(
                children: [
                  const Icon(
                    Icons.person,
                    color: Colors.white70,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Trainer: $trainerName',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),


              Row(
                children: [
                  const Icon(
                    Icons.room,
                    color: Colors.white70,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Room: $roomName',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),


              Text(
                'Spaces Left: $capacity',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),


              if (status.isNotEmpty)
                Text(
                  'Status: $status',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: status == 'Available' ? Colors.green : Colors.redAccent,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
