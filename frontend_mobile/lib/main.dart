import 'package:flutter/material.dart';
import 'pages/login.dart';
import 'pages/register.dart';
import 'pages/home.dart';
import 'models.dart';

void main() {
  runApp(const AzizLibraryApp());
}

class AzizLibraryApp extends StatelessWidget {
  const AzizLibraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aziz Library',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey.shade100,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
        ),
      ),
      // Initial route is Login
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
      },
      // Handle navigation to Home with User data
      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          final user = settings.arguments as UserModel;
          return MaterialPageRoute(
            builder: (context) => HomePage(user: user),
          );
        }
        return null;
      },
    );
  }
}
