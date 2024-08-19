import 'dart:async';
import 'dart:convert';
import 'package:fytness_system/models/membership_package.dart';
import 'package:http/http.dart' as http;

class MembershipPackageService {
  //final String baseUrl = 'http://192.168.1.79:5084/api/membership-packages';
  final String baseUrl = 'http://10.0.2.2:5084/api/membership-packages';

  Future<List<MembershipPackage>> fetchMembershipPackages() async {
    try {
      print('Sending request to server...');
      final response = await http.get(Uri.parse(baseUrl));
      print('Received response with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        print('Successfully decoded JSON response');
        return jsonResponse.map((item) => MembershipPackage.fromJson(item)).toList();
      } else {
        print('Failed to load membership packages: ${response.statusCode}');
        throw Exception('Failed to load membership packages');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load membership packages');
    }
  }

  Future<MembershipPackage?> fetchMembershipPackageById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return MembershipPackage.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load membership package');
      }
    } catch (e) {
      throw Exception('Failed to load membership package');
    }
  }

  Future<void> updateMembershipPackage(MembershipPackage membershipPackage) async {
    try {
      final response = await http.put(
        //Uri.parse('https://192.168.1.79:7083/api/membership-packages/${membershipPackage.membershipPackageId}'),
        Uri.parse('https://10.0.2.2:7083/api/membership-packages/${membershipPackage.membershipPackageId}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(membershipPackage.toJson()),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update membership package');
      }
    } catch (e) {
      throw Exception('Failed to update membership package');
    }
  }
}
