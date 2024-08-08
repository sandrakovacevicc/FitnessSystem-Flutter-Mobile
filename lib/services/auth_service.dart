import 'dart:convert';
import 'package:fytness_system/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../models/dto/login_request_dto.dart';
import '../models/dto/login_response_dto.dart';

class AuthService {
  Future<LoginResponseDto?> login(String email, String password) async {
    final url = Uri.parse('https://10.0.2.2:7083/api/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(LoginRequestDto(email: email, password: password).toJson()),
    );

    print('Request URL: $url');
    print('Request Body: ${jsonEncode(LoginRequestDto(email: email, password: password).toJson())}');
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return LoginResponseDto.fromJson(jsonDecode(response.body));
    } else {
      print('Login failed: ${response.body}');
      return null;
    }
  }

  Future<void> saveUserRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userRole', role);
  }

  String getUserRole(String jwtToken) {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(jwtToken);
    String? role = decodedToken['http://schemas.microsoft.com/ws/2008/06/identity/claims/role'];
    if (role == null) {
      throw Exception('Role not found in JWT token');
    }
    return role;
  }

  Future<User?> getUserFromJwt(String jwtToken) async {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(jwtToken);
    print('Decoded JWT token: $decodedToken');

    if (decodedToken.containsKey('http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress') &&
        decodedToken.containsKey('http://schemas.microsoft.com/ws/2008/06/identity/claims/role') &&
        decodedToken.containsKey('http://schemas.microsoft.com/ws/2008/06/identity/claims/userdata')) {

      String role = decodedToken['http://schemas.microsoft.com/ws/2008/06/identity/claims/role'];
      User user;

      if (role == 'Client') {
        user = User(
          id: decodedToken['http://schemas.microsoft.com/ws/2008/06/identity/claims/userdata'],
          name: '',
          surname: '',
          email: decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress'],
          jmbg: '',
          role: role,
          membershipPackageId: null,
          birthdate: null,
          mobileNumber: '',
          specialty: null,
        );
      } else if (role == 'Trainer') {
        user = User(
          id: decodedToken['http://schemas.microsoft.com/ws/2008/06/identity/claims/userdata'],
          name: '',
          surname: '',
          email: decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress'],
          jmbg: '',
          role: role,
          membershipPackageId: null,
          birthdate: null,
          mobileNumber: null,
          specialty: '',
        );
      } else {
        user = User(
          id: decodedToken['http://schemas.microsoft.com/ws/2008/06/identity/claims/userdata'],
          name: '',
          surname: '',
          email: decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress'],
          jmbg: '',
          role: role,
          membershipPackageId: null,
          birthdate: null,
          mobileNumber: null,
          specialty: null,
        );
      }

      return user;
    } else {
      return null;
    }
  }


  Future<Map<String, dynamic>?> getUserData(String userId, String jwtToken, String role) async {
    Uri url;

    if (role == 'Client') {
      url = Uri.parse('https://10.0.2.2:7083/api/clients/$userId');
    } else if (role == 'Trainer') {
      url = Uri.parse('http://10.0.2.2:5084/api/trainers/$userId');
    } else {
      url = Uri.parse('https://10.0.2.2:7083/api/users/$userId');
    }

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('User data: $data');
      return data;
    } else {
      print('Failed to load user data: ${response.body}');
      return null;
    }
  }

}

