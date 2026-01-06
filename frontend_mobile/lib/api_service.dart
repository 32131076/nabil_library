import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'models.dart';

class ApiService {
  static String get baseUrl {
    final String origin = html.window.location.origin;
    if (origin.contains('localhost')) {
      return "http://localhost:5000/api";
    }
    return "$origin/api";
  }

  static Future<Map<String, dynamic>?> login(String u, String p) async {
    final r = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"username": u, "password": p}),
    );
    return r.statusCode == 200 ? jsonDecode(r.body) : null;
  }

  static Future<bool> register(Map<String, dynamic> data) async {
    final r = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return r.statusCode == 201 || r.statusCode == 200;
  }

  static Future<UserModel?> getUserData(String id) async {
    final r = await http.get(Uri.parse('$baseUrl/users/$id'));
    return r.statusCode == 200 ? UserModel.fromJson(jsonDecode(r.body)) : null;
  }

  static Future<List<BookModel>> getBooks() async {
    final r = await http.get(Uri.parse('$baseUrl/books'));
    List d = jsonDecode(r.body);
    return d.map((j) => BookModel.fromJson(j)).toList();
  }

  static Future<void> addBook(Map<String, dynamic> data) async =>
      await http.post(
        Uri.parse('$baseUrl/books'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

  static Future<void> updateBook(String id, Map<String, dynamic> data) async =>
      await http.put(
        Uri.parse('$baseUrl/books/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

  static Future<void> deleteBook(String id) async =>
      await http.delete(Uri.parse('$baseUrl/books/$id'));

  static Future<bool> borrowBook(String bId, String uId) async {
    final r = await http.post(
      Uri.parse('$baseUrl/borrow'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"bookId": bId, "userId": uId}),
    );
    return r.statusCode == 200;
  }

  static Future<void> returnBook(String bId, String uId) async =>
      await http.post(
        Uri.parse('$baseUrl/return'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"bookId": bId, "userId": uId}),
      );

  static Future<List<BookModel>> getMyBorrowedBooks(String uId) async {
    final r = await http.get(Uri.parse('$baseUrl/my-books/$uId'));
    List d = jsonDecode(r.body);
    return d.map((j) => BookModel.fromJson(j)).toList();
  }

  static Future<List<dynamic>> getBorrowHistory(String uId) async {
    final r = await http.get(Uri.parse('$baseUrl/history/$uId'));
    return jsonDecode(r.body);
  }

  static Future<void> updateUser(String id, Map<String, dynamic> data) async {
    await http.put(
      Uri.parse('$baseUrl/users/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  static Future<List<UserModel>> getAllUsers() async {
    final r = await http.get(Uri.parse('$baseUrl/users'));
    List d = jsonDecode(r.body);
    return d.map((j) => UserModel.fromJson(j)).toList();
  }
}
