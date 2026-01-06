import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final u = TextEditingController();
  final p = TextEditingController();
  final f = TextEditingController();
  final e = TextEditingController();
  final phone = TextEditingController();
  final addr = TextEditingController();

  String _query = "";
  String selectedRole = "employee";
  String selectedGender = "Male";
  bool _loading = false;

  void _createUser() async {
    if (u.text.isEmpty || p.text.isEmpty || f.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in required fields (User, Pass, Name)"),
        ),
      );
      return;
    }

    setState(() => _loading = true);

    bool ok = await ApiService.register({
      "username": u.text.trim(),
      "password": p.text,
      "fullname": f.text.trim(),
      "email": e.text.trim(),
      "phoneNumber": phone.text.trim(),
      "address": addr.text.trim(),
      "gender": selectedGender,
      "role": selectedRole,
      "borrowedCount": 0,
    });

    setState(() {
      _loading = false;
      if (ok) {
        u.clear();
        p.clear();
        f.clear();
        e.clear();
        phone.clear();
        addr.clear();
      }
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok ? "Account created successfully!" : "Error creating account",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpansionTile(
          leading: const Icon(Icons.person_add, color: Colors.brown),
          title: const Text(
            "Register New Account",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  TextField(
                    controller: u,
                    decoration: const InputDecoration(labelText: "Username"),
                  ),
                  TextField(
                    controller: p,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: "Password"),
                  ),
                  TextField(
                    controller: f,
                    decoration: const InputDecoration(labelText: "Full Name"),
                  ),
                  const SizedBox(height: 10),
                  DropdownButton<String>(
                    value: selectedRole,
                    isExpanded: true,
                    items: ["employee", "user"]
                        .map(
                          (role) => DropdownMenuItem(
                            value: role,
                            child: Text(role.toUpperCase()),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => selectedRole = v!),
                  ),
                  const SizedBox(height: 20),
                  _loading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _createUser,
                            child: const Text("CREATE ACCOUNT"),
                          ),
                        ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),

        const Divider(thickness: 2),

        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            onChanged: (v) {
              setState(() {
                _query = v.toLowerCase();
              });
            },
            decoration: InputDecoration(
              hintText: "Search name, email, or phone...",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),

        Expanded(
          child: FutureBuilder<List<UserModel>>(
            future: ApiService.getAllUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No users found."));
              }

              final filtered = snapshot.data!.where((user) {
                return user.fullname.toLowerCase().contains(_query) ||
                    user.email.toLowerCase().contains(_query) ||
                    user.phoneNumber.contains(_query);
              }).toList();

              return ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, i) {
                  final user = filtered[i];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.brown.shade100,
                        child: Text(
                          user.fullname.isNotEmpty ? user.fullname[0] : "?",
                        ),
                      ),
                      title: Text(user.fullname),
                      subtitle: Text(
                        "${user.role.toUpperCase()} • ${user.email}",
                      ),
                      trailing: user.role == 'admin'
                          ? const Icon(Icons.verified_user, color: Colors.blue)
                          : const Icon(Icons.person, color: Colors.grey),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
