import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  final int index;
  final Function(int) onTap;
  final String role;

  const Navbar({super.key, required this.index, required this.onTap, required this.role});

  @override
  Widget build(BuildContext context) {
    bool isStaff = role == 'admin' || role == 'employee';
    return BottomNavigationBar(
      currentIndex: index,
      onTap: onTap,
      selectedItemColor: Colors.brown[900],
      unselectedItemColor: Colors.brown[300],
      type: BottomNavigationBarType.fixed,
      items: [
        const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        const BottomNavigationBarItem(icon: Icon(Icons.book), label: "Books"),
        const BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: "My Borrow"),
        if (isStaff) const BottomNavigationBarItem(icon: Icon(Icons.add_box), label: "Add Book"),
        if (role == 'admin') const BottomNavigationBarItem(icon: Icon(Icons.person_add), label: "Add User"),
      ],
    );
  }
}
