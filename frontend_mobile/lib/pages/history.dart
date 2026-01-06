import 'package:flutter/material.dart';
import '../api_service.dart';

class HistoryPage extends StatelessWidget {
  final String userId;
  const HistoryPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Reading History")),
      body: FutureBuilder<List<dynamic>>(
        future: ApiService.getBorrowHistory(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No history found. Start reading!"),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, i) {
              final item = snapshot.data![i];
              // Safe date parsing
              String dateDisplay = "N/A";
              if (item['returnDate'] != null) {
                dateDisplay = item['returnDate'].toString().split('T')[0];
              }

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: ListTile(
                  leading: const Icon(Icons.history_edu, color: Colors.brown),
                  title: Text(
                    item['title'] ?? "Unknown Title",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Status: Returned on $dateDisplay"),
                  trailing: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 20,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
