import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models.dart';

class MyBorrowBookPage extends StatefulWidget {
  final String userId;
  final bool isReadOnly;
  final VoidCallback? onUpdate;

  const MyBorrowBookPage({
    super.key,
    required this.userId,
    this.isReadOnly = false,
    this.onUpdate,
  });

  @override
  State<MyBorrowBookPage> createState() => _MyBorrowBookPageState();
}

class _MyBorrowBookPageState extends State<MyBorrowBookPage> {
  late Future<List<BookModel>> _borrowedBooksFuture;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  void _loadBooks() {
    setState(() {
      _borrowedBooksFuture = ApiService.getMyBorrowedBooks(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BookModel>>(
      future: _borrowedBooksFuture,
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(30.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!snap.hasData || snap.data!.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: Text(
                "You have no active borrowed books.",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        final books = snap.data!;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: books.length,
          itemBuilder: (context, i) {
            final b = books[i];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.auto_stories, color: Colors.brown),
                title: Text(
                  b.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("By ${b.author}"),
                trailing: widget.isReadOnly
                    ? null
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Processing return..."),
                              duration: Duration(seconds: 1),
                            ),
                          );

                          await ApiService.returnBook(b.id, widget.userId);

                          if (!mounted) return;

                          if (widget.onUpdate != null) widget.onUpdate!();

                          _loadBooks();

                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Book returned successfully!"),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        child: const Text("Return"),
                      ),
              ),
            );
          },
        );
      },
    );
  }
}
