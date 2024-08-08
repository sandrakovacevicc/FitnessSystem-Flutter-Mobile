class MembershipPackage {
  final int membershipPackageId;
  final String name;
  final String description;
  final double price;
  final int numberOfMonths;

  const MembershipPackage({
    required this.membershipPackageId,
    required this.name,
    required this.description,
    required this.price,
    required this.numberOfMonths,
  });

  factory MembershipPackage.fromJson(Map<String, dynamic> json) {
    return MembershipPackage(
      membershipPackageId: json['membershipPackageId'] ?? 0,

      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      numberOfMonths: json['numberOfMonths'],
    );
  }
}
