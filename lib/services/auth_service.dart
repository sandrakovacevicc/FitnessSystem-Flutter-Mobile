import 'dart:convert';
import 'package:fytness_system/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../models/dto/login_request_dto.dart';
import '../models/dto/login_response_dto.dart';

class AuthService {
  Future<LoginResponseDto?> login(String email, String password) async {
    //final url = Uri.parse('https://192.168.1.79:7083/api/auth/login');
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
          name: '',
          surname: '',
          email: decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress'],
          jmbg: decodedToken['http://schemas.microsoft.com/ws/2008/06/identity/claims/userdata'],
          role: role,
          membershipPackageId: null,
          birthdate: null,
          mobileNumber: '',
          specialty: null,
        );
      } else if (role == 'Trainer') {
        user = User(
          name: '',
          surname: '',
          email: decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress'],
          jmbg: decodedToken['http://schemas.microsoft.com/ws/2008/06/identity/claims/userdata'],
          role: role,
          membershipPackageId: null,
          birthdate: null,
          mobileNumber: null,
          specialty: '',
        );
      } else {
        user = User(
          name: '',
          surname: '',
          email: decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress'],
          jmbg: decodedToken['http://schemas.microsoft.com/ws/2008/06/identity/claims/userdata'],
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
      //url = Uri.parse('https://192.168.1.79:7083/api/clients/$userId');
      url = Uri.parse('https://10.0.2.2:7083/api/clients/$userId');
    } else if (role == 'Trainer') {
      //url = Uri.parse('http://192.168.1.79:5084/api/trainers/$userId');
      url = Uri.parse('http://10.0.2.2:5084/api/trainers/$userId');
    } else {
      //url = Uri.parse('https://192.168.1.79:7083/api/users/$userId');
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

  Future<bool> signUp(User user) async {
    //final url = Uri.parse('https://192.168.1.79:7083/api/auth/register');
    final url = Uri.parse('https://10.0.2.2:7083/api/auth/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': user.email,
        'password': user.password,
        'name': user.name,
        'surname': user.surname,
        'mobileNumber': user.mobileNumber,
        'jmbg': user.jmbg,
        'birthdate': user.birthdate?.toIso8601String(),
        'membershipPackageId': user.membershipPackageId,
        'roles': [user.role.isNotEmpty ? user.role : 'Client'],
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Sign-up failed: ${response.body}');
      return false;
    }
  }

  Future<bool> getClientsById(String jmbg) async {
    //final url = Uri.parse('https://192.168.1.79:7083/api/clients/$jmbg');
    final url = Uri.parse('https://10.0.2.2:7083/api/clients/$jmbg');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return data.isNotEmpty;
    } else {
      print('Error checking client existence: ${response.body}');
      return false;
    }
  }

  Future<List<User>> fetchTrainers() async {
    //final url = Uri.parse('http://192.168.1.79:5084/api/trainers');
    final url = Uri.parse('http://10.0.2.2:5084/api/trainers');
    final response = await http.get(
      url,
    );

    if (response.statusCode == 200) {
      final List<dynamic> trainersJson = jsonDecode(response.body);
      return trainersJson.map((json) => User(
        name: json['name'],
        surname: json['surname'],
        email: json['email'],
        jmbg: json['jmbg'],
        role: 'Trainer',
        specialty: json['specialty'],
      )).toList();
    } else {
      print('Failed to fetch trainers: ${response.body}');
      return [];
    }
  }

  Future<List<User>> fetchClients() async {
    //final url = Uri.parse('https://192.168.1.79:7083/api/clients');
    final url = Uri.parse('https://10.0.2.2:7083/api/clients');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> clientsJson = jsonDecode(response.body);
      return clientsJson.map((json) => User(
        name: json['name'],
        surname: json['surname'],
        email: json['email'],
        jmbg: json['jmbg'],
        role: 'Clients',
        birthdate: json['birthdate'] != null ? DateTime.parse(json['birthdate']) : null,
        membershipPackageId: json['membershipPackageId'],
        mobileNumber: json['mobileNumber'],
      )).toList();
    } else {
      print('Failed to fetch clients: ${response.body}');
      return [];
    }
  }

  Future<List<User>> searchClients(String searchTerm) async {
    //final url = Uri.parse('https://192.168.1.79:7083/api/clients/search?searchTerm=$searchTerm');
    final url = Uri.parse('https://10.0.2.2:7083/api/clients/search?searchTerm=$searchTerm');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> clientsJson = jsonDecode(response.body);
      return clientsJson.map((json) => User(
        name: json['name'],
        surname: json['surname'],
        email: json['email'],
        jmbg: json['jmbg'],
        role: 'Clients',
        birthdate: DateTime.parse(json['birthdate']),
        membershipPackageId: json['membershipPackageId'],
        mobileNumber: json['mobileNumber'],
      )).toList();
    } else {
      print('Failed to fetch clients: ${response.body}');
      return [];
    }
  }

  Future<void> updateClient(User user) async {
    //final url = Uri.parse('https://192.168.1.79:7083/api/clients/${user.jmbg}');
    final url = Uri.parse('https://10.0.2.2:7083/api/clients/${user.jmbg}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': user.name,
        'surname': user.surname,
        'email': user.email,
        'birthdate': user.birthdate?.toIso8601String(),
        'mobileNumber': user.mobileNumber,
        'membershipPackageId': user.membershipPackageId,
      }),
    );

    if (response.statusCode == 200) {
      print('Client updated successfully');
    } else {
      print('Failed to update client: ${response.body}');
    }
  }

  Future<void> updateTrainer(User user) async {
    //final url = Uri.parse('https://192.168.1.79:7083/api/trainers/${user.jmbg}');
    final url = Uri.parse('https://10.0.2.2:7083/api/trainers/${user.jmbg}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': user.name,
        'surname': user.surname,
        'email': user.email,
        'specialty': user.specialty,

      }),
    );

    if (response.statusCode == 200) {
      print('Trainer updated successfully');
    } else {
      print('Failed to update trainer: ${response.body}');
    }
  }


}
