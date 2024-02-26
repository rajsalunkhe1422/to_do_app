import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final bool isCompleted;
  final DateTime? date;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.isCompleted = false,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'date':date,
    };
  }

  factory Task.fromMap(String id, Map<String, dynamic> map) {
    return Task(
      id: id,
      title: map['title'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      isCompleted: map['isCompleted'] ?? false,
      date: (map['date'] as Timestamp).toDate(),
    );
  }
}
