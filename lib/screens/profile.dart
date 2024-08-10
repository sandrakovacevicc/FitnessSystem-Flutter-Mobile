import 'package:flutter/material.dart';
import 'package:fytness_system/services/membership_package_service.dart';
import 'package:fytness_system/widgets/global_navbar.dart';
import 'package:fytness_system/widgets/global_menu.dart';
import 'package:provider/provider.dart';
import 'package:fytness_system/providers/user_provider.dart';
import 'package:intl/intl.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int _selectedIndex = 3;
  bool _showMembership = false;
  final MembershipPackageService membershipPackageService = MembershipPackageService();

  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _jmbgController;
  late TextEditingController _birthdateController;
  late TextEditingController _specialityController;

  late TextEditingController _membershipNameController;
  late TextEditingController _membershipDescriptionController;
  late TextEditingController _membershipPriceController;
  late TextEditingController _membershipNumberOfMonthsController;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).user;

    _nameController = TextEditingController(text: user?.name ?? '');
    _surnameController = TextEditingController(text: user?.surname ?? '');
    _phoneController = TextEditingController(text: user?.mobileNumber ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _jmbgController = TextEditingController(text: user?.jmbg ?? '');
    _birthdateController = TextEditingController(
      text: user?.birthdate != null ? DateFormat('yyyy-MM-dd').format(user!.birthdate!) : '',
    );
    _specialityController = TextEditingController(text: user?.specialty ?? '');

    _membershipNameController = TextEditingController();
    _membershipDescriptionController = TextEditingController();
    _membershipPriceController = TextEditingController();
    _membershipNumberOfMonthsController = TextEditingController();

    if (user?.role == 'Client' && user?.membershipPackageId != null) {
      membershipPackageService.fetchMembershipPackageById(user!.membershipPackageId!).then((membershipPackage) {
        if (membershipPackage != null) {
          setState(() {
            _membershipNameController.text = membershipPackage.name ?? '';
            _membershipDescriptionController.text = membershipPackage.description ?? '';
            _membershipPriceController.text = membershipPackage.price.toString() ?? '';
            _membershipNumberOfMonthsController.text = membershipPackage.numberOfMonths.toString() ?? '';
          });
        }
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, 'mainScreen/');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, 'trainings/');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, 'reservations/');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, 'profile/');
        break;
    }
  }

  void _toggleMembershipView() {
    setState(() {
      _showMembership = !_showMembership;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: const NavBar(automaticallyImplyLeading: true),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/prof.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  final user = userProvider.user;
                  final membershipPackage = userProvider.membershipPackage;
                  if (user == null) {
                    return const CircularProgressIndicator();
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Stack(
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: Color(0xFFE6FE58),
                          ),
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.transparent,
                            child: Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (user.role == 'Client') ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildIconContainer(
                              icon: Icons.badge,
                              onPressed: () {
                                setState(() {
                                  _showMembership = false;
                                });
                              },
                            ),
                            const SizedBox(width: 10),
                            _buildIconContainer(
                              icon: Icons.card_membership,
                              onPressed: _toggleMembershipView,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        width: 350,
                        child: Column(
                          children: [
                            if (user.role == 'Client' && !_showMembership) ...[
                              _buildProfileField(
                                icon: Icons.person,
                                label: 'Name',
                                controller: _nameController,
                              ),
                              _buildProfileField(
                                icon: Icons.person_outline,
                                label: 'Surname',
                                controller: _surnameController,
                              ),
                              _buildProfileField(
                                icon: Icons.email,
                                label: 'Email',
                                controller: _emailController,
                              ),
                              _buildProfileField(
                                icon: Icons.contact_mail,
                                label: 'JMBG',
                                controller: _jmbgController,
                              ),
                              _buildProfileField(
                                icon: Icons.phone,
                                label: 'Phone',
                                controller: _phoneController,
                              ),
                              _buildProfileField(
                                icon: Icons.cake,
                                label: 'Birthdate',
                                controller: _birthdateController,
                              ),
                            ] else if (user.role == 'Client' && _showMembership) ...[
                              _buildProfileField(
                                icon: Icons.card_membership,
                                label: 'Membership Name',
                                controller: _membershipNameController,
                              ),
                              _buildProfileField(
                                icon: Icons.description,
                                label: 'Membership Description',
                                controller: _membershipDescriptionController,
                              ),
                              _buildProfileField(
                                icon: Icons.payments,
                                label: 'Membership Price',
                                controller: _membershipPriceController,
                              ),
                              _buildProfileField(
                                icon: Icons.hourglass_top,
                                label: 'Membership Number of Months',
                                controller: _membershipNumberOfMonthsController,
                              ),
                            ] else if (user.role == 'Trainer') ...[
                              _buildProfileField(
                                icon: Icons.person,
                                label: 'Name',
                                controller: _nameController,
                              ),
                              _buildProfileField(
                                icon: Icons.person_outline,
                                label: 'Surname',
                                controller: _surnameController,
                              ),
                              _buildProfileField(
                                icon: Icons.email,
                                label: 'Email',
                                controller: _emailController,
                              ),
                              _buildProfileField(
                                icon: Icons.contact_mail,
                                label: 'JMBG',
                                controller: _jmbgController,
                              ),
                              _buildProfileField(
                                icon: Icons.star,
                                label: 'Speciality',
                                controller: _specialityController,
                              ),
                            ] else if (user.role == 'Admin') ...[
                              _buildProfileField(
                                icon: Icons.person,
                                label: 'Name',
                                controller: _nameController,
                              ),
                              _buildProfileField(
                                icon: Icons.person_outline,
                                label: 'Surname',
                                controller: _surnameController,
                              ),
                              _buildProfileField(
                                icon: Icons.email,
                                label: 'Email',
                                controller: _emailController,
                              ),
                              _buildProfileField(
                                icon: Icons.contact_mail,
                                label: 'JMBG',
                                controller: _jmbgController,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildProfileField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        readOnly: true,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white),
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFFE6FE58)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE6FE58)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE6FE58)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE6FE58)),
          ),
          filled: true,
          fillColor: Colors.black.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget _buildIconContainer({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}
