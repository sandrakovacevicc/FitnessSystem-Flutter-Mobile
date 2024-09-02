import 'dart:convert';
import 'package:fytness_system/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:fytness_system/models/reservation.dart';
import 'package:intl/intl.dart';

class ReservationService {
  final String baseUrl;

  ReservationService({required this.baseUrl});

  Future<void> createReservation({
    required String clientJMBG,
    required int sessionId,
    required DateTime date,
    required String time,
    required String status,
  }) async {
    final url = Uri.parse('$baseUrl/reservations');

    final body = {
      'clientJMBG': clientJMBG,
      'sessionId': sessionId,
      'date': DateFormat('yyyy-MM-dd').format(date),
      'time': time,
      'status': status,
    };


    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('Reservation created successfully');
      } else {
        print('Failed to create reservation: ${response.statusCode} ${response.body}');
        throw Exception('Failed to create reservation');
      }
    } catch (e) {
      print('Exception caught: $e');
      throw Exception('Failed to create reservation');
    }
  }

  Future<List<Reservation>> fetchReservationsByUserId(String jmbg) async {
    try {
      final url = Uri.parse('$baseUrl/reservations/clients/$jmbg');
      print('Fetching reservations from: $url');

      final response = await http.get(url);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Reservation.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load reservations: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception caught: $e');
      throw Exception('Failed to load reservations');
    }
  }

  Future<void> deleteReservation(int reservationId) async {
    final url = Uri.parse('$baseUrl/reservations/$reservationId');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        print('Reservation deleted successfully');
      } else {
        print('Failed to delete reservation: ${response.statusCode} ${response.body}');
        throw Exception('Failed to delete reservation');
      }
    } catch (e) {
      print('Exception caught: $e');
      throw Exception('Failed to delete reservation');
    }
  }

  Future<void> confirmReservation(int sessionId, String clientJMBG) async {
    final url = Uri.parse('$baseUrl/reservations/confirm?sessionId=$sessionId&clientJmbg=$clientJMBG');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 404) {
      if (response.body.isNotEmpty) {
        final errorResponse = json.decode(response.body);
        throw Exception('Reservation not found: ${errorResponse['message']}');
      } else {
        throw Exception('Reservation not found: No error message provided');
      }
    } else {
      if (response.body.isNotEmpty) {
        final errorResponse = json.decode(response.body);
        throw Exception('Error confirming reservation: ${errorResponse['message']}');
      } else {
        throw Exception('Error confirming reservation: No error message provided');
      }
    }
  }
  Future<List<User>> fetchConfirmedClientsBySessionId(int sessionId) async {
    final url = Uri.parse('$baseUrl/reservations/sessions/$sessionId/confirmed-clients');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse.isEmpty) {
          print('Nema potvrđenih klijenata za session $sessionId.');
          return [];
        }

        return jsonResponse.map((data) => User.fromJson(data)).toList();
      } else if (response.statusCode == 404) {
        print('Nema potvrđenih klijenata za session $sessionId.');
        return [];
      } else {
        print('Greška: ${response.statusCode} - ${response.body}');
        throw Exception('Neuspelo preuzimanje potvrđenih klijenata: ${response.statusCode}');
      }
    } catch (e) {
      print('Uhvaćena greška: $e');
      throw Exception('Greška pri preuzimanju potvrđenih klijenata: $e');
    }
  }

}
