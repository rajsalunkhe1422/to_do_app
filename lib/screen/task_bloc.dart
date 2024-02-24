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
        tasks.add(Task(
          id: doc.id,
          title: doc['title'],
          description: doc['description'],
          imageUrl: doc['imageUrl'],
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
