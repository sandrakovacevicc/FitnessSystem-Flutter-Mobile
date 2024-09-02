import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fytness_system/models/session.dart';
import 'package:fytness_system/screens/training_program.dart';
import 'package:fytness_system/providers/user_provider.dart';

class SessionCard extends StatelessWidget {
  final Session session;

  const SessionCard({super.key, required this.session});

  String getProgramImage(String programName) {
    const programImages = {
      'HIIT': 'assets/hiit.jpg',
      'Yoga': 'assets/yoga.jpg',
      'Pilates': 'assets/pilates.jpg',
      'Crossfit': 'assets/crossfit.jpg',
      'Spinning': 'assets/spinning.jpg',
    };

    return programImages[programName] ?? 'assets/default.jpg';
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl = getProgramImage(session.trainingProgramName);

    final userRole = Provider.of<UserProvider>(context).user?.role ?? '';

    return Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Image Section
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset(
                imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            // Text Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.trainingProgramName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Trainer: ${session.trainerName}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.white70, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '${session.time.format(context)} - ${session.duration} mins',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Actions Section
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SessionDetailPage(sessionId: session.sessionId),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE6FE58),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    textStyle: const TextStyle(
                      fontSize: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Text(
                    userRole == 'Admin' || userRole == 'Trainer' ? 'Details' : 'Book',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${session.capacity} Spaces left',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
