import 'package:flutter/material.dart';
import '../models.dart';
import '../api_service.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController f, e, p, a;
  late String g;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    f = TextEditingController(text: widget.user.fullname);
    e = TextEditingController(text: widget.user.email);
    p = TextEditingController(text: widget.user.phoneNumber);
    a = TextEditingController(text: widget.user.address);
    g = widget.user.gender.isEmpty ? "Male" : widget.user.gender;
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _loading = true);

      await ApiService.updateUser(widget.user.id, {
        "fullname": f.text.trim(),
        "email": e.text.trim(),
        "phoneNumber": p.text.trim(),
        "address": a.text.trim(),
        "gender": g,
      });

      setState(() => _loading = false);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: f,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Enter your full name" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: e,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v!.isEmpty) return "Enter your email";
                  if (!v.contains("@") || !v.contains("."))
                    return "Enter a valid email address";
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: p,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v!.length < 10 ? "Enter a valid phone number" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: a,
                decoration: const InputDecoration(
                  labelText: "Address",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Address cannot be empty" : null,
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                initialValue: g,
                decoration: const InputDecoration(
                  labelText: "Gender",
                  border: OutlineInputBorder(),
                ),
                items: ["Male", "Female", "Other"]
                    .map(
                      (val) => DropdownMenuItem(value: val, child: Text(val)),
                    )
                    .toList(),
                onChanged: (v) => setState(() => g = v!),
              ),
              const SizedBox(height: 30),
              _loading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _saveProfile,
                        child: const Text("SAVE CHANGES"),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
