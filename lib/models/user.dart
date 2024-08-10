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

  User copyWith({
    String? id,
    String? name,
    String? surname,
    String? email,
    String? jmbg,
    String? role,
    int? membershipPackageId,
    DateTime? birthdate,
    String? mobileNumber,
    String? specialty,
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
    );
  }
}
