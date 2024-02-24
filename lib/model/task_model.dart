class Task {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final bool isCompleted;
  final DateTime? date; // Add date property

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.isCompleted = false,
    this.date, // Initialize date property
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'date': date?.millisecondsSinceEpoch, // Convert date to milliseconds
    };
  }

  factory Task.fromMap(String id, Map<String, dynamic> map) {
    return Task(
      id: id,
      title: map['title'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      isCompleted: map['isCompleted'] ?? false,
      date: map['date'] != null ? DateTime.fromMillisecondsSinceEpoch(map['date']) : null, // Parse date from milliseconds
    );
  }
}
