import 'package:flutter/material.dart';
import '../models.dart';
import '../api_service.dart';

class BookDetailPage extends StatefulWidget {
  final BookModel book;
  final String userId;
  final VoidCallback onUpdate;

  const BookDetailPage({
    super.key,
    required this.book,
    required this.userId,
    required this.onUpdate,
  });

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  bool _loading = false;

  void _handleBorrow() async {
    setState(() => _loading = true);
    
    // Attempt to borrow through API
    bool success = await ApiService.borrowBook(widget.book.id, widget.userId);
    
    setState(() => _loading = false);

    if (success) {
      widget.onUpdate(); // Trigger refresh for Home/Stats
      if (!mounted) return;
      Navigator.pop(context); // Return to the list
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Successfully borrowed '${widget.book.title}'")),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed: Borrow limit reached (Max 5) or book unavailable")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.book.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.book.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text("by ${widget.book.author}", style: const TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 20),
            Chip(label: Text(widget.book.category), backgroundColor: Colors.brown.shade50),
            const Divider(height: 40),
            const Text("Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(widget.book.description.isEmpty ? "No description provided." : widget.book.description),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: _loading
            ? const Center(heightFactor: 1, child: CircularProgressIndicator())
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.book.isAvailable ? Colors.brown : Colors.grey,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: widget.book.isAvailable ? _handleBorrow : null,
                child: Text(widget.book.isAvailable ? "BORROW BOOK" : "NOT AVAILABLE", 
                      style: const TextStyle(color: Colors.white)),
              ),
      ),
    );
  }
}