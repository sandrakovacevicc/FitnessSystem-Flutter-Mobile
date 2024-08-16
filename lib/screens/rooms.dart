import 'package:flutter/material.dart';
import 'package:fytness_system/models/room.dart';
import 'package:fytness_system/services/room_service.dart';
import 'package:fytness_system/widgets/global_navbar.dart';
import 'package:fytness_system/widgets/global_room_card.dart';

class Rooms extends StatefulWidget {
  const Rooms({super.key});

  @override
  State<Rooms> createState() => _RoomsState();
}

class _RoomsState extends State<Rooms> {
  late Future<List<Room>> _roomsFuture;
  final RoomService _roomService =
  RoomService(baseUrl: 'https://10.0.2.2:7083/api');

  @override
  void initState() {
    super.initState();
    _roomsFuture = _roomService.fetchRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavBar(automaticallyImplyLeading: true),
      backgroundColor: Colors.grey[900],
      body: FutureBuilder<List<Room>>(
        future: _roomsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No rooms available.'));
          } else {
            final rooms = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                return GlobalRoomCard(room: rooms[index]);
              },
            );
          }
        },
      ),
    );
  }
}
