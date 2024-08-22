import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReservationCard extends StatelessWidget {
  final String trainingProgramName;
  final DateTime trainingDate;
  final String trainingTime;
  final DateTime reservationDate;
  final String time;
  final String status;
  final int reservationId;
  final VoidCallback onDelete;
  final VoidCallback onCamera;

  const ReservationCard({
    super.key,
    required this.trainingProgramName,
    required this.trainingDate,
    required this.trainingTime,
    required this.reservationDate,
    required this.time,
    required this.status,
    required this.reservationId,
    required this.onDelete,
    required this.onCamera,
  });

  @override
  Widget build(BuildContext context) {
    final trainingTimeFormatted = _formatTime(trainingTime);
    final reservationTimeFormatted = _formatTime(time);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.black.withOpacity(0.9),
      child: Stack(
        children: [
          Container(
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
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${DateFormat('d MMM yyyy').format(trainingDate)} - $trainingTimeFormatted',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6FE58),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              color: Colors.black,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Reservation Details',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          icon: Icons.calendar_today,
                          label: 'Reservation Date:',
                          value: DateFormat('d MMM yyyy').format(reservationDate),
                        ),
                        _buildInfoRow(
                          icon: Icons.access_time,
                          label: 'Reservation Time:',
                          value: reservationTimeFormatted,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Status: $status',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: status == 'reserved'
                                ? Colors.green[900]
                                : Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 48,
            child: IconButton(
              icon: const Icon(Icons.camera_alt, color: Colors.white),
              onPressed: onCamera,
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(String time) {
    if (time.length == 8) {
      return DateFormat.Hm().format(DateFormat("HH:mm:ss").parse(time));
    } else {
      return time;
    }
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.black54,
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
