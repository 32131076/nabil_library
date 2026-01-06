import 'package:flutter/material.dart';
import '../api_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final u = TextEditingController(),
      p = TextEditingController(),
      f = TextEditingController();
  final e = TextEditingController(),
      phone = TextEditingController(),
      addr = TextEditingController();
  String selectedGender = "Male";
  bool _loading = false;

  void _register() async {
    setState(() => _loading = true);
    bool ok = await ApiService.register({
      "username": u.text.trim(),
      "password": p.text,
      "fullname": f.text.trim(),
      "email": e.text.trim(),
      "phoneNumber": phone.text.trim(),
      "address": addr.text.trim(),
      "gender": selectedGender,
      "role": "user",
      "borrowedCount": 0,
    });
    setState(() => _loading = false);

    if (ok) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Registration Successful!")));
      Navigator.pop(context);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Registration Failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Account")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: f,
              decoration: const InputDecoration(labelText: "Full Name"),
            ),
            TextField(
              controller: e,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: phone,
              decoration: const InputDecoration(labelText: "Phone Number"),
            ),
            TextField(
              controller: addr,
              decoration: const InputDecoration(labelText: "Address"),
            ),
            DropdownButtonFormField<String>(
              initialValue: selectedGender,
              decoration: const InputDecoration(labelText: "Gender"),
              items: [
                "Male",
                "Female",
                "Other",
              ].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
              onChanged: (v) => setState(() => selectedGender = v!),
            ),
            TextField(
              controller: u,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: p,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 30),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _register,
                    child: const Text("REGISTER"),
                  ),
          ],
        ),
      ),
    );
  }
}
