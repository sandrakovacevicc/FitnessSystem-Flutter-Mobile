import 'dart:convert';
import 'dart:typed_data';
import 'package:fytness_system/models/dto/sessionAdd_dto.dart';
import 'package:fytness_system/models/session.dart';
import 'package:http/http.dart' as http;

class SessionService {
  final String baseUrl;

  SessionService({required this.baseUrl});

  Future<List<Session>> fetchSessions(String date) async {
    final String url = '$baseUrl/sessions?filterBy=Date&filterValue=$date&sortBy=Time&ascending=true&pageNumber=1&pageSize=10';

    final response = await http.get(Uri.parse(url));

    print('Request URL: $url');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => Session.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load sessions');
    }
  }

  Future<Session> fetchSessionById(int sessionId) async {
    final response = await http.get(Uri.parse('$baseUrl/sessions/$sessionId'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Session.fromJson(data);
    } else {
      throw Exception('Failed to load session');
    }
  }

  Future<List<Session>> fetchSessionsByTrainerJmbg(String trainerJMBG) async {
    final String url = '$baseUrl/trainers/$trainerJMBG';

    final response = await http.get(Uri.parse(url));

    print('Request URL: $url');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => Session.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load sessions for trainer');
    }
  }

  Future<Session> deleteSession(int sessionId) async {
    final response = await http.delete(Uri.parse('$baseUrl/sessions/$sessionId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Session.fromJson(data);
    } else {
      print('Error Response Body: ${response.statusCode}');

      if (response.statusCode == 500) {
        throw Exception('You cannot delete this session because there are reservations associated with it.');
      } else {
        throw Exception('Failed to delete session');
      }
    }
  }


  Future<SessionAddDto> createSession(SessionAddDto session) async {
    final String url = '$baseUrl/sessions';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(session.toJson()),
    );

    print('Request URL: $url');
    print('Request Body: ${jsonEncode(session.toJson())}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return session;
    } else if (response.statusCode == 409) {
      String errorMessage = 'The selected trainer is already booked for this time slot. Please choose a different time or trainer.';
      print(errorMessage);
      throw Exception(errorMessage);
    } else {
      print('Error Response Body: ${response.body}');
      throw Exception('Failed to create session');
    }
  }

  Future<Uint8List> generateQrCode(int sessionId) async {
    final response = await http.get(Uri.parse('$baseUrl/sessions/$sessionId/qrcode'));

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to generate QR code');
    }
  }

}
