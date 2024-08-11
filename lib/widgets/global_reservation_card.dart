import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReservationCard extends StatelessWidget {
  final String trainingProgramName;
  final DateTime trainingDate;
  final String trainingTime;
  final DateTime reservationDate;
  final String time;
  final String status;

  const ReservationCard({
    super.key,
    required this.trainingProgramName,
    required this.trainingDate,
    required this.trainingTime,
    required this.reservationDate,
    required this.time,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8), // Reduced margins
      elevation: 6, // Reduced elevation
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Reduced border radius
      ),
      color: Colors.black.withOpacity(0.8), // Slightly reduced opacity
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3), // Adjusted shadow opacity
              spreadRadius: 1, // Reduced spread radius
              blurRadius: 4, // Reduced blur radius
              offset: const Offset(0, 2), // Adjusted shadow offset
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12), // Reduced padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Training Program Name
              Text(
                trainingProgramName,
                style: const TextStyle(
                  fontSize: 18, // Reduced font size
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE6FE58),
                ),
              ),
              const SizedBox(height: 8), // Reduced spacing

              // Training Date and Time
              Text(
                '${DateFormat('d MMM yyyy').format(trainingDate)} - $trainingTime',
                style: const TextStyle(
                  fontSize: 14, // Reduced font size
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8), // Reduced spacing

              // Reservation Details
              Container(
                padding: const EdgeInsets.all(8), // Reduced padding
                decoration: BoxDecoration(
                  color: const Color(0xFFE6FE58),
                  borderRadius: BorderRadius.circular(8), // Reduced border radius
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Reservation Details',
                      style: TextStyle(
                        fontSize: 16, // Reduced font size
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 6), // Reduced spacing
                    _buildInfoRow(
                      label: 'Reservation Date:',
                      value: DateFormat('d MMM yyyy').format(reservationDate),
                    ),
                    _buildInfoRow(
                      label: 'Reservation Time:',
                      value: time,
                    ),
                    const SizedBox(height: 6), // Reduced spacing
                    Text(
                      'Status: $status',
                      style: TextStyle(
                        fontSize: 14, // Reduced font size
                        fontWeight: FontWeight.bold,
                        color: status == 'reserved' ? Colors.green : Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({required String label, required String value}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14, // Reduced font size
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
              fontSize: 14, // Reduced font size
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
