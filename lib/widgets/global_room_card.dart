import 'package:flutter/material.dart';
import 'package:fytness_system/models/room.dart';


class GlobalRoomCard extends StatelessWidget {
  final Room room;

  const GlobalRoomCard({super.key, required this.room});


  String getRoomImage(String roomName) {
    return {
      'cardio zone': 'assets/cardioZone.jpg',
      'bicycle room': 'assets/bicycleRoom.jpg',
      'training hall': 'assets/trainingHall.jpg',
      'meditation room': 'assets/meditationRoom.jpg',
    }[roomName.toLowerCase()] ?? 'assets/default.jpg';
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl = getRoomImage(room.RoomName);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 6,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            child: Image.asset(
              imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.black, size: 28),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        room.RoomName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
