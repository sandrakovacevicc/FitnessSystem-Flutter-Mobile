import 'dart:convert';
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
}
