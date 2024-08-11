import 'package:flutter/material.dart';
import '../models/membership_package.dart';

class GlobalCard extends StatelessWidget {
  final MembershipPackage membershipPackage;

  const GlobalCard({super.key, required this.membershipPackage});


  String getPackageImage(String packageName) {
    return {
      'student paket': 'assets/hiit.jpg',
      'regular paket': 'assets/package.jpg',
      'polugodisnji paket': 'assets/hiit.jpg',
      'godisnji paket': 'assets/hiit.jpg',
    }[packageName.toLowerCase()] ?? 'assets/default.jpg';
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl = getPackageImage(membershipPackage.name);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 6,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            child: Image.asset(
              imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.card_membership, color: Colors.black, size: 28),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        membershipPackage.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  membershipPackage.description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.payment, color: Colors.black, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              '${membershipPackage.price} RSD',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.access_time, color: Colors.black, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              '${membershipPackage.numberOfMonths} months',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6FE58),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: const Text(
                        'Book Now',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
