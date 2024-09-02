import 'dart:async';
import 'dart:convert';
import 'package:fytness_system/models/training_program.dart';
import 'package:http/http.dart' as http;

class TrainingProgramService {
  final String baseUrl = 'https://172.20.10.2:7083/api/training-programs';
  //final String baseUrl = 'https://10.0.2.2:7083/api/training-programs';


  Future<List<TrainingProgram>> fetchTrainingPrograms() async {
    try {
      print('Sending request to server...');
      final response = await http.get(Uri.parse(baseUrl));
      print('Received response with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        print('Successfully decoded JSON response');
        return jsonResponse.map((item) => TrainingProgram.fromJson(item)).toList();
      } else {
        print('Failed to load training programs: ${response.statusCode}');
        throw Exception('Failed to load training programs');
      }
    } catch (e) {
      print('Exception occurred while fetching training programs: $e');
      throw Exception('Failed to load training programs');
    }
  }

  Future<void> updateTrainingProgram(TrainingProgram program) async {
    final url = '$baseUrl/${program.trainingProgramId}';
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(program.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update training program');
      }
    } catch (e) {
      print('Exception occurred while updating training program: $e');
      throw Exception('Failed to update training program');
    }
  }
}
