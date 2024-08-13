import 'package:flutter/material.dart';
import 'package:fytness_system/widgets/global_packages_card.dart';
import '../models/membership_package.dart';
import '../services/membership_package_service.dart';
import '../widgets/global_navbar.dart';

class Packages extends StatefulWidget {
  const Packages({super.key});

  @override
  State<Packages> createState() => _PackagesState();
}

class _PackagesState extends State<Packages> {
  late Future<List<MembershipPackage>> futureMembershipPackages;

  @override
  void initState() {
    super.initState();
    futureMembershipPackages = MembershipPackageService().fetchMembershipPackages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavBar(automaticallyImplyLeading: true),
      backgroundColor: Colors.grey[900],
      body: FutureBuilder<List<MembershipPackage>>(
        future: futureMembershipPackages,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No packages available.'));
          } else {
            final packages = snapshot.data;

            final nonNullPackages = packages!.toList();

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: nonNullPackages.length,
              itemBuilder: (context, index) {
                final package = nonNullPackages[index];
                return GlobalPackagesCard(
                  membershipPackage: package,
                  id: package.membershipPackageId,
                );
              },
            );
          }
        },
      ),
    );
  }
}
