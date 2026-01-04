import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final u = TextEditingController(), p = TextEditingController();
  bool _loading = false;

  void _handleLogin() async {
    setState(() => _loading = true);
    final userData = await ApiService.login(u.text.trim(), p.text);
    setState(() => _loading = false);

    if (userData != null) {
      final user = UserModel.fromJson(userData);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (c) => HomePage(user: user)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid Credentials")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.library_books, size: 80, color: Colors.brown),
            const SizedBox(height: 20),
            const Text("Aziz Library", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            TextField(controller: u, decoration: const InputDecoration(labelText: "Username", border: OutlineInputBorder())),
            const SizedBox(height: 15),
            TextField(controller: p, obscureText: true, decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder())),
            const SizedBox(height: 20),
            _loading 
              ? const CircularProgressIndicator() 
              : SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(onPressed: _handleLogin, child: const Text("LOGIN")),
                ),
            TextButton(onPressed: () => Navigator.pushNamed(context, '/register'), child: const Text("Create a new account"))
          ],
        ),
      ),
    );
  }
}