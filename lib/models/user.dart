class User {
  final String name;
  final String surname;
  final String email;
  final String jmbg;
  final String role;
  final int? membershipPackageId;
  final DateTime? birthdate;
  final String? mobileNumber;
  final String? specialty;
  final String? password;

  User({
    required this.name,
    required this.surname,
    required this.email,
    required this.jmbg,
    required this.role,
    this.membershipPackageId,
    this.birthdate,
    this.mobileNumber,
    this.specialty,
    this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? '',
      surname: json['surname'] ?? '',
      email: json['email'] ?? '',
      jmbg: json['jmbg'] ?? '',
      role: json['role'] ?? '',
      membershipPackageId: json['membershipPackageId'] != null ? int.tryParse(json['membershipPackageId'].toString()) : null,
      birthdate: json['birthdate'] != null ? DateTime.tryParse(json['birthdate']) : null,
      mobileNumber: json['mobileNumber'] != null ? json['mobileNumber'].toString() : null,
      specialty: json['specialty'] ?? '',
      password: json['password'] ?? '',
    );
  }

  User copyWith({
    String? name,
    String? surname,
    String? email,
    String? jmbg,
    String? role,
    int? membershipPackageId,
    DateTime? birthdate,
    String? mobileNumber,
    String? specialty,
    String? password,
  }) {
    return User(
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      jmbg: jmbg ?? this.jmbg,
      role: role ?? this.role,
      membershipPackageId: membershipPackageId ?? this.membershipPackageId,
      birthdate: birthdate ?? this.birthdate,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      specialty: specialty ?? this.specialty,
      password: password ?? this.password,
    );
  }
}
