import 'package:flutter/material.dart';
import '../models.dart';
import '../api_service.dart';

class EditBookPage extends StatefulWidget {
  final BookModel book;
  const EditBookPage({super.key, required this.book});

  @override
  State<EditBookPage> createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {
  late TextEditingController t, a, d;
  late String selectedCat;
  bool _loading = false;

  final List<String> categories = ["General", "Fiction", "Science", "History", "Biography", "Tech"];

  @override
  void initState() {
    super.initState();
    t = TextEditingController(text: widget.book.title);
    a = TextEditingController(text: widget.book.author);
    d = TextEditingController(text: widget.book.description);
    // Ensure the current category exists in the list, otherwise default to General
    selectedCat = categories.contains(widget.book.category) ? widget.book.category : "General";
  }

  void _updateBook() async {
    setState(() => _loading = true);

    // Call the static update method from ApiService
    await ApiService.updateBook(widget.book.id, {
      "title": t.text.trim(),
      "author": a.text.trim(),
      "description": d.text.trim(),
      "category": selectedCat,
    });

    if (!mounted) return;
    setState(() => _loading = false);
    
    // Return to the previous screen (BookPage)
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Book updated successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Book")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: t, decoration: const InputDecoration(labelText: "Title", border: OutlineInputBorder())),
            const SizedBox(height: 15),
            TextField(controller: a, decoration: const InputDecoration(labelText: "Author", border: OutlineInputBorder())),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              initialValue: selectedCat,
              decoration: const InputDecoration(labelText: "Category", border: OutlineInputBorder()),
              items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => selectedCat = v!),
            ),
            const SizedBox(height: 15),
            TextField(controller: d, maxLines: 3, decoration: const InputDecoration(labelText: "Description", border: OutlineInputBorder())),
            const SizedBox(height: 25),
            _loading 
              ? const CircularProgressIndicator() 
              : SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _updateBook,
                    child: const Text("UPDATE BOOK"),
                  ),
                )
          ],
        ),
      ),
    );
  }
}