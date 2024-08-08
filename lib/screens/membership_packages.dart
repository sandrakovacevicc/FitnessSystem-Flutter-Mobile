import 'package:flutter/material.dart';
import 'package:fytness_system/models/membership_package.dart';
import 'package:fytness_system/services/membership_package_service.dart';
import 'package:fytness_system/utils/global_colors.dart';
import 'package:fytness_system/widgets/global_button.dart';
import 'package:fytness_system/widgets/global_card.dart';

class MembershipPackages extends StatefulWidget {
  const MembershipPackages({super.key});

  @override
  State<MembershipPackages> createState() => _MembershipPackagesState();
}

class _MembershipPackagesState extends State<MembershipPackages> {
  late Future<List<MembershipPackage>> futureMembershipPackages;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    futureMembershipPackages = fetchMembershipPackages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.darkGrey,
      appBar: AppBar(
        backgroundColor: GlobalColors.darkGrey,
        iconTheme: const IconThemeData(
          color: Color(0xFFE6FE58),
        ),
      ),
      body: Center(
        child: FutureBuilder<List<MembershipPackage>>(
          future: futureMembershipPackages,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No membership packages found');
            } else {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: selectedIndex == index
                                      ? const Color(0xFFE6FE58)
                                      : Colors.transparent,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              child: GlobalCard(membershipPackage: snapshot.data![index]),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GlobalButton(
                      text: 'Create Account',
                      onPressed: () {
                        Navigator.pushNamed(context, 'mainScreen/');
                      },
                      width: double.infinity,
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
