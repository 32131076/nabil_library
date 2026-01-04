class UserModel {
  final String id;
  final String username;
  final String fullname;
  final String email; // NEW
  final String phoneNumber; // NEW
  final String address; // NEW
  final String gender; // NEW
  final String role;
  final int borrowedCount;

  UserModel({
    required this.id,
    required this.username,
    required this.fullname,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.gender,
    required this.role,
    required this.borrowedCount,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
      fullname: json['fullname'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      address: json['address'] ?? '',
      gender: json['gender'] ?? '',
      role: json['role'] ?? 'user',
      borrowedCount: json['borrowedCount'] ?? 0,
    );
  }
}

class BookModel {
  final String id;
  final String title;
  final String author;
  final String description;
  final String category;
  final bool isAvailable;
  final String? borrowerId;

  BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.category,
    required this.isAvailable,
    this.borrowerId,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? 'General',
      isAvailable: json['isAvailable'] ?? true,
      borrowerId: json['borrowerId'],
    );
  }
}
