import 'package:flutter/material.dart';
import 'package:fytness_system/models/membership_package.dart';
import 'package:fytness_system/screens/clients.dart';
import 'package:fytness_system/services/auth_service.dart';
import 'package:fytness_system/services/membership_package_service.dart';
import 'package:fytness_system/models/user.dart';
import 'package:fytness_system/widgets/global_navbar.dart';

class EditClientScreen extends StatefulWidget {
  final User user;

  const EditClientScreen({super.key, required this.user});

  @override
  _EditClientScreenState createState() => _EditClientScreenState();
}

class _EditClientScreenState extends State<EditClientScreen> {
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _emailController;
  late TextEditingController _jmbgController;
  late TextEditingController _birthdateController;
  late TextEditingController _mobileNumberController;
  late Future<List<MembershipPackage>> futureMembershipPackages;
  MembershipPackage? selectedPackage;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _surnameController = TextEditingController(text: widget.user.surname);
    _emailController = TextEditingController(text: widget.user.email);
    _jmbgController = TextEditingController(text: widget.user.jmbg);
    _birthdateController = TextEditingController(text: widget.user.birthdate?.toLocal().toString().split(' ')[0]);
    _mobileNumberController = TextEditingController(text: widget.user.mobileNumber);

    futureMembershipPackages = MembershipPackageService().fetchMembershipPackages();
    _loadSelectedPackage();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Preload the background image
    precacheImage(const AssetImage('assets/pro.png'), context);
  }

  Future<void> _loadSelectedPackage() async {
    if (widget.user.membershipPackageId != null) {
      final package = await MembershipPackageService().fetchMembershipPackageById(widget.user.membershipPackageId!);
      setState(() {
        selectedPackage = package;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _jmbgController.dispose();
    _birthdateController.dispose();
    _mobileNumberController.dispose();
    super.dispose();
  }

  void _saveClient() async {
    if (_formKey.currentState!.validate()) {
      User updatedUser = User(
        name: _nameController.text,
        surname: _surnameController.text,
        email: _emailController.text,
        jmbg: _jmbgController.text,
        birthdate: DateTime.parse(_birthdateController.text),
        mobileNumber: _mobileNumberController.text,
        membershipPackageId: selectedPackage?.membershipPackageId,
        role: 'Client',
      );

      try {
        await AuthService().updateClient(updatedUser);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User successfully updated')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Clients()),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating user: $error')),
        );
      }
    }
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
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  color: Colors.black,
                ),
                Image.asset(
                  'assets/pro.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.black,
                    );
                  },
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.all(18.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          _buildReadOnlyTextFormField(_nameController, 'Name', Icons.person),
                          const SizedBox(height: 13),
                          _buildReadOnlyTextFormField(_surnameController, 'Surname', Icons.person_outline),
                          const SizedBox(height: 13),
                          _buildReadOnlyTextFormField(_jmbgController, 'JMBG', Icons.contact_mail),
                          const SizedBox(height: 13),
                          _buildReadOnlyTextFormField(_birthdateController, 'Birthdate', Icons.calendar_today),
                          const SizedBox(height: 13),
                          _buildTextFormField(_emailController, 'Email', Icons.email, validateEmail: true),
                          const SizedBox(height: 13),
                          _buildTextFormField(_mobileNumberController, 'Mobile Number', Icons.phone),
                          const SizedBox(height: 13),
                          FutureBuilder<List<MembershipPackage>>(
                            future: futureMembershipPackages,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return const Center(child: Text('No packages available.'));
                              } else {
                                final packages = snapshot.data!;
                                return DropdownButtonFormField<MembershipPackage>(
                                  value: selectedPackage,
                                  onChanged: (MembershipPackage? newValue) {
                                    setState(() {
                                      selectedPackage = newValue;
                                    });
                                  },
                                  items: packages.map<DropdownMenuItem<MembershipPackage>>((MembershipPackage package) {
                                    return DropdownMenuItem<MembershipPackage>(
                                      value: package,
                                      child: Text(package.name, style: const TextStyle(color: Color(0xFFE6FE58))),
                                    );
                                  }).toList(),
                                  decoration: InputDecoration(
                                    labelText: 'Membership Package',
                                    labelStyle: const TextStyle(color: Colors.white),
                                    filled: true,
                                    fillColor: Colors.grey[900],
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  ),
                                  dropdownColor: Colors.grey[900],
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              onPressed: _saveClient,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: const Color(0xFFE6FE58),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                textStyle: const TextStyle(fontSize: 16),
                              ),
                              child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildReadOnlyTextFormField(TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFFE6FE58)),
        filled: true,
        labelStyle: const TextStyle(color: Colors.white),
        fillColor: Colors.grey[900],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildTextFormField(
      TextEditingController controller,
      String label,
      IconData icon, {
        bool validateEmail = false,
      }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFFE6FE58)),
        filled: true,
        labelStyle: const TextStyle(color: Colors.white),
        fillColor: Colors.grey[900],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        if (validateEmail) {
          final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
          if (!emailRegex.hasMatch(value)) {
            return 'Please enter a valid email address';
          }
        }
        return null;
      },
    );
  }
}
