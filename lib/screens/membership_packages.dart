import 'package:flutter/material.dart';
import 'package:fytness_system/models/membership_package.dart';
import 'package:fytness_system/services/auth_service.dart';
import 'package:fytness_system/services/membership_package_service.dart';
import 'package:fytness_system/utils/global_colors.dart';
import 'package:fytness_system/widgets/global_button.dart';
import 'package:fytness_system/widgets/global_membership_package_card.dart';
import 'package:fytness_system/models/user.dart';

class MembershipPackages extends StatefulWidget {
  final User user;

  const MembershipPackages({super.key, required this.user});

  @override
  State<MembershipPackages> createState() => _MembershipPackagesState();
}

class _MembershipPackagesState extends State<MembershipPackages> {
  late Future<List<MembershipPackage>> futureMembershipPackages;
  int? selectedIndex;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    futureMembershipPackages = MembershipPackageService().fetchMembershipPackages();
  }



  Future<void> _createAccount() async {
    if (selectedIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a membership package.')),
      );
      return;
    }

    final selectedPackageId = (await futureMembershipPackages)[selectedIndex!].membershipPackageId;
    User updatedUser = widget.user.copyWith(membershipPackageId: selectedPackageId);

    final clientExists = await _authService.getClientsById(updatedUser.jmbg);
    if (clientExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A client with this JMBG already exists.')),
      );
      return;
    }

    final signUpResponse = await _authService.signUp(updatedUser);
    if (signUpResponse) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully created account!')),
      );
      Navigator.pushNamed(context, 'login/');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create an account.')),
      );
    }
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
                              child: GlobalCard(
                                membershipPackage: snapshot.data![index],
                              ),
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
                      onPressed: _createAccount,
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