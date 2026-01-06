import 'package:flutter/material.dart';
import '../models.dart';
import '../api_service.dart';
import 'book.dart';
import 'my_borrow_book.dart';
import 'add_book.dart';
import 'add_user.dart';
import 'edit_profile.dart';
import '../widgets/navbar.dart';
import 'history.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  final UserModel user;
  const HomePage({super.key, required this.user});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late UserModel currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = widget.user;
  }

  Future<void> refreshUser() async {
    final updated = await ApiService.getUserData(currentUser.id);
    if (updated != null) {
      setState(() => currentUser = updated);
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text(
          "Are you sure you want to log out of your account?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCEL"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            child: const Text("LOGOUT", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      RefreshIndicator(
        onRefresh: refreshUser,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildHeader(),
              _buildStats(),
              const Padding(
                padding: EdgeInsets.all(40),
                child: Opacity(
                  opacity: 0.5,
                  child: Column(
                    children: [
                      Icon(Icons.auto_awesome, size: 50, color: Colors.brown),
                      SizedBox(height: 10),
                      Text(
                        "Welcome to Aziz Library",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Manage your books in the 'My Borrow' tab",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      BookPage(
        userRole: currentUser.role,
        userId: currentUser.id,
        onUpdate: refreshUser,
      ),
      MyBorrowBookPage(userId: currentUser.id, onUpdate: refreshUser),
      const AddBookPage(),
      const AddUserPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        elevation: 0,
        title: const Text(
          "Library Dashboard",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: refreshUser,
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _showLogoutDialog,
          ),
        ],
      ),
      body: SafeArea(child: pages[_currentIndex]),
      bottomNavigationBar: Navbar(
        index: _currentIndex,
        role: currentUser.role,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: Colors.brown,
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(50)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white24,
            child: Text(
              currentUser.fullname.isNotEmpty ? currentUser.fullname[0] : "?",
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Hello,", style: TextStyle(color: Colors.white70)),
                Text(
                  currentUser.fullname,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (c) => EditProfilePage(user: currentUser),
              ),
            ).then((_) => refreshUser()),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: _statCard(
              "Borrowed",
              currentUser.borrowedCount.toString(),
              Icons.book,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => HistoryPage(userId: currentUser.id),
                ),
              ),
              child: _statCard("History", "View All", Icons.history),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Icon(icon, color: Colors.brown),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
