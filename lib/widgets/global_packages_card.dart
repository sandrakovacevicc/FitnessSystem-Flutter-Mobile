import 'package:flutter/material.dart';
import '../models/membership_package.dart';
import '../services/membership_package_service.dart';

class GlobalPackagesCard extends StatefulWidget {
  final MembershipPackage membershipPackage;
  final int id;

  const GlobalPackagesCard({
    super.key,
    required this.membershipPackage,
    required this.id,
  });

  @override
  State<GlobalPackagesCard> createState() => _GlobalPackagesCardState();
}

class _GlobalPackagesCardState extends State<GlobalPackagesCard> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _monthsController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.membershipPackage.name);
    _priceController = TextEditingController(text: widget.membershipPackage.price.toString());
    _monthsController = TextEditingController(text: widget.membershipPackage.numberOfMonths.toString());
    _descriptionController = TextEditingController(text: widget.membershipPackage.description);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _monthsController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String getPackageImage(String packageName) {
    return {
      'student paket': 'assets/student.jpg',
      'regular paket': 'assets/package.jpg',
      'polugodisnji paket': 'assets/polugodisnji.jpg',
      'godisnji paket': 'assets/godisnji.jpg',
    }[packageName.toLowerCase()] ?? 'assets/default.jpg';
  }

  Future<void> _onEditButtonPressed() async {
    final updatedPackage = MembershipPackage(
      membershipPackageId: widget.id,
      name: widget.membershipPackage.name,
      description: _descriptionController.text,
      price: double.tryParse(_priceController.text) ?? 0.0,
      numberOfMonths: int.tryParse(_monthsController.text) ?? 0,
    );

    try {
      await MembershipPackageService().updateMembershipPackage(updatedPackage);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Package updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update package: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl = getPackageImage(widget.membershipPackage.name);

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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.card_membership, color: Colors.black, size: 28),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        _nameController.text,
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
                TextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter description',
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.payment, color: Colors.black, size: 18),
                            const SizedBox(width: 6),
                            SizedBox(
                              width: 90,
                              child: TextField(
                                controller: _priceController,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  suffixText: 'RSD',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.access_time, color: Colors.black, size: 18),
                            const SizedBox(width: 2),
                            SizedBox(
                              width: 70,
                              child: TextField(
                                controller: _monthsController,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  suffixText: 'months',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: _onEditButtonPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE6FE58),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: const Text(
                        'Edit',
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
