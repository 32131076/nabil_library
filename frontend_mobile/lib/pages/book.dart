import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models.dart';
import 'edit_book.dart';
import 'book_detail.dart';

class BookPage extends StatefulWidget {
  final String userRole;
  final String userId;
  final VoidCallback onUpdate;

  const BookPage({
    super.key,
    required this.userRole,
    required this.userId,
    required this.onUpdate,
  });

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  String _search = "";

  @override
  Widget build(BuildContext context) {
    bool isStaff = widget.userRole == 'admin' || widget.userRole == 'employee';

    return Column(
      children: [
        // --- SEARCH SECTION ---
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            onChanged: (v) => setState(() => _search = v.toLowerCase()),
            decoration: InputDecoration(
              hintText: "Search by title or author...",
              prefixIcon: const Icon(Icons.search, color: Colors.brown),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
        ),

        // --- BOOKS LIST ---
        Expanded(
          child: FutureBuilder<List<BookModel>>(
            future: ApiService.getBooks(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No books available in the library."));
              }

              final filtered = snapshot.data!
                  .where((b) =>
                      b.title.toLowerCase().contains(_search) ||
                      b.author.toLowerCase().contains(_search))
                  .toList();

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: filtered.length,
                itemBuilder: (context, i) {
                  final b = filtered[i];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      // TAP TO SEE DETAILS
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookDetailPage(
                              book: b,
                              userId: widget.userId,
                              onUpdate: () {
                                widget.onUpdate(); // Update Home Stats
                                setState(() {});    // Refresh this list
                              },
                            ),
                          ),
                        );
                      },
                      leading: CircleAvatar(
                        backgroundColor: b.isAvailable ? Colors.green.shade50 : Colors.red.shade50,
                        child: Icon(
                          Icons.menu_book,
                          color: b.isAvailable ? Colors.green : Colors.red,
                        ),
                      ),
                      title: Text(
                        b.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${b.author} • ${b.category}"),
                          const SizedBox(height: 4),
                          Text(
                            b.isAvailable ? "Available" : "Checked Out",
                            style: TextStyle(
                              color: b.isAvailable ? Colors.green : Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // STAFF CONTROLS (Edit/Delete)
                          if (isStaff) ...[
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => EditBookPage(book: b)),
                              ).then((_) => setState(() {})),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                              onPressed: () => _showDeleteDialog(b.id),
                            ),
                          ],
                          
                          // BORROW BUTTON (For Users/Staff)
                          if (b.isAvailable)
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.brown,
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () async {
                                await ApiService.borrowBook(b.id, widget.userId);
                                widget.onUpdate();
                                setState(() {});
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Borrowed ${b.title}")),
                                );
                              },
                              child: const Text("Borrow", style: TextStyle(color: Colors.white, fontSize: 12)),
                            ),
                        ],
                      ),
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

  // --- DELETE LOGIC ---
  void _showDeleteDialog(String bookId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Book"),
        content: const Text("This action cannot be undone. Do you want to continue?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await ApiService.deleteBook(bookId);
              if (!context.mounted) return;
              Navigator.pop(context);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Book deleted successfully")),
              );
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}