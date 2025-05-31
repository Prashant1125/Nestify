import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final database = FirebaseDatabase.instance.ref("userInfo");
  Map<String, dynamic> users = {};

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final snapshot = await database.get();
    if (snapshot.exists && snapshot.value is Map) {
      setState(() {
        users = Map<String, dynamic>.from(snapshot.value as Map);
      });
    }
  }

  Future<void> makeAdmin(String uid) async {
    await database.child(uid).update({'isAdmin': true});
    Get.snackbar(
      "Success",
      "User promoted to admin.",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    fetchUsers(); // refresh UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Panel")),
      body: users.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final uid = users.keys.elementAt(index);
                final user = Map<String, dynamic>.from(users[uid]);
                final isAdmin = user['isAdmin'] == true;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user['photoURL'] ?? ''),
                    child: user['photoURL'] == null
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  title: Text(user['name'] ?? 'No Name'),
                  subtitle: Text(user['email'] ?? 'No Email'),
                  trailing: isAdmin
                      ? const Text("Admin",
                          style: TextStyle(color: Colors.green))
                      : ElevatedButton(
                          onPressed: () => makeAdmin(uid),
                          child: const Text("Make Admin"),
                        ),
                );
              },
            ),
    );
  }
}
