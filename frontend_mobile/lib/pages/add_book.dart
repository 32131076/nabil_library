import 'package:flutter/material.dart';
import '../api_service.dart';

class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});
  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final t = TextEditingController(),
      a = TextEditingController(),
      d = TextEditingController();
  String selectedCat = "General";
  bool loading = false;

  void _submitBook() async {
    if (t.text.isEmpty || a.text.isEmpty) return;
    setState(() => loading = true);
    await ApiService.addBook({
      "title": t.text.trim(),
      "author": a.text.trim(),
      "description": d.text.trim(),
      "category": selectedCat,
      "isAvailable": true,
      "borrowerId": null,
    });
    setState(() => loading = false);
    t.clear();
    a.clear();
    d.clear();
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Book Added to Inventory!")));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            "Register New Book",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: t,
            decoration: const InputDecoration(
              labelText: "Title",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: a,
            decoration: const InputDecoration(
              labelText: "Author",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),
          DropdownButtonFormField<String>(
            initialValue: selectedCat,
            decoration: const InputDecoration(
              labelText: "Category",
              border: OutlineInputBorder(),
            ),
            items: [
              "General",
              "Fiction",
              "Science",
              "History",
              "Biography",
              "Tech",
            ].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (v) => setState(() => selectedCat = v!),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: d,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: "Description",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 25),
          loading
              ? const CircularProgressIndicator()
              : SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _submitBook,
                    child: const Text("SAVE BOOK"),
                  ),
                ),
        ],
      ),
    );
  }
}
