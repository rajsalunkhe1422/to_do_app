import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_app/model/task_model.dart';

class TaskBloc {
  final _taskController = StreamController<List<Task>>.broadcast();
  Stream<List<Task>> get tasksStream => _taskController.stream;

  final CollectionReference _tasksCollection = FirebaseFirestore.instance.collection('tasks');

  TaskBloc() {
    _tasksCollection.snapshots().listen((snapshot) {
      List<Task> tasks = [];
      for (var doc in snapshot.docs) {
        DateTime date;
        var dateField = doc['date'];
        if (dateField is Timestamp) {
          date = dateField.toDate();
        } else if (dateField is int) {
          date = DateTime.fromMillisecondsSinceEpoch(dateField);
        } else {
          date = DateTime.now();
        }
        tasks.add(Task(
          id: doc.id,
          title: doc['title'],
          description: doc['description'],
          imageUrl: doc['imageUrl'],
          date: date,
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
