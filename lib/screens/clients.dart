import 'package:flutter/material.dart';
import 'package:fytness_system/screens/client_edit.dart';
import 'package:fytness_system/services/auth_service.dart';
import 'package:fytness_system/widgets/global_client_card.dart';
import 'package:fytness_system/widgets/global_navbar.dart';
import 'package:fytness_system/models/user.dart';

class Clients extends StatefulWidget {
  const Clients({super.key});

  @override
  State<Clients> createState() => _ClientsState();
}

class _ClientsState extends State<Clients> {
  final TextEditingController searchController = TextEditingController();
  final AuthService authService = AuthService();
  late Future<List<User>> _clientsFuture;

  @override
  void initState() {
    super.initState();
    _loadClients();

    searchController.addListener(() {
      _loadClients();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _loadClients() {
    setState(() {
      final searchTerm = searchController.text.trim();
      if (searchTerm.isEmpty) {
        _clientsFuture = authService.fetchClients();
      } else {
        _clientsFuture = authService.searchClients(searchTerm);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavBar(automaticallyImplyLeading: true),
      backgroundColor: Colors.grey[900],
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(7.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SizedBox(
                        height: 48,
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            hintStyle: const TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Colors.black,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(13),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: FutureBuilder<List<User>>(
                  future: _clientsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No clients found.'));
                    } else {
                      final clients = snapshot.data!;
                      return ListView.builder(
                        itemCount: clients.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () async {
                              final result = await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EditClientScreen(user: clients[index]),
                                ),
                              );
                              if (result != null) {
                                _loadClients();
                              }
                            },
                            child: GlobalClientCard(user: clients[index]),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
