import 'dart:convert';
import 'package:fytness_system/models/room.dart';
import 'package:http/http.dart' as http;


class RoomService {
  final String baseUrl;

  RoomService({required this.baseUrl});

  Future<List<Room>> fetchRooms() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        print('Successfully decoded JSON response');
        return jsonResponse.map((item) => Room.fromJson(item)).toList();
      } else {
        print('Failed to load membership packages: ${response.statusCode}');
        throw Exception('Failed to load membership packages');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load membership packages');
    }
  }
}