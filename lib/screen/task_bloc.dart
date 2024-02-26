import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_app/model/task_model.dart';
import 'dart:async';

class TaskBloc {
  final _taskController = StreamController<List<Task>>();
  Stream<List<Task>> get tasksStream => _taskController.stream;

  final CollectionReference _tasksCollection = FirebaseFirestore.instance.collection('tasks');

  TaskBloc() {
    _tasksCollection.snapshots().listen((snapshot) {
      List<Task> tasks = [];
      for (var doc in snapshot.docs) {
        // Check the type of 'date' and convert accordingly
        DateTime date;
        var dateField = doc['date'];
        if (dateField is Timestamp) {
          // If 'date' is a Timestamp, convert to DateTime
          date = dateField.toDate();
        } else if (dateField is int) {
          // If 'date' is an integer (milliseconds since epoch), convert to DateTime
          date = DateTime.fromMillisecondsSinceEpoch(dateField);
        } else {
          // Default or error handling case, set a default date or handle as needed
          date = DateTime.now(); // Or throw an error, depending on your requirements
        }
        tasks.add(Task(
          id: doc.id,
          title: doc['title'],
          description: doc['description'],
          imageUrl: doc['imageUrl'],
          date: date, // Allow null dates
        ));
      }
      _taskController.add(tasks);
    });
  }

  void addTask(Task task) {
    _tasksCollection.add(task.toMap());
  }

  void updateTask(Task task) {
    _tasksCollection.doc(task.id).update(task.toMap());
  }

  void deleteTask(String taskId) {
    _tasksCollection.doc(taskId).delete();
  }

  void dispose() {
    _taskController.close();
  }
}
