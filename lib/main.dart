import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:to_do_app/adapter/task_adapter.dart';
import 'package:to_do_app/firebase_options.dart';
import 'package:to_do_app/local/hive_storage_repo.dart';
import 'package:to_do_app/model/task_model.dart';
import 'package:to_do_app/screen/add_task_screen.dart';
import 'package:to_do_app/screen/task_bloc.dart';
import 'package:to_do_app/screen/task_details_screen.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Register the adapter
  Hive.registerAdapter(TaskAdapter());

  // Initialize Hive and open the box
  await Hive.initFlutter();
  await Hive.openBox<Task>('taskBox');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(bloc: TaskBloc()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final TaskBloc bloc;

  MyHomePage({required this.bloc});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedSegment = 0;
  late List<Task> _tasks = [];
  late Box _todoBox;

  void _onSegmentSelected(int index) {
    setState(() {
      _selectedSegment = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _openBox();
    _loadTasksFromHive();
  }

  Future<void> _openBox() async {
    try {
      await Hive.initFlutter();
      _todoBox = await Hive.openBox(HiveStorageRepo.taskListKey);
    } catch (e) {
      print('Error opening box: $e');
    }
  }

  Future<void> _loadTasksFromHive() async {
    List<dynamic> taskJsonList = _todoBox.values.toList();
    List<Task> tasks = taskJsonList.map((json) => Task.fromMap("",json)).toList();
    setState(() {
      _tasks = tasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          CupertinoSegmentedControl<int>(
            children: const {
              0: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Text('Today'),
              ),
              1: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Text('Tomorrow'),
              ),
              2: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Text('Upcoming'),
              ),
            },
            onValueChanged: _onSegmentSelected,
            groupValue: _selectedSegment,
          ),
          Expanded(
            child: StreamBuilder<List<Task>>(
              stream: widget.bloc.tasksStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: Text('Empty List'));

                // Get tasks based on the selected segment
                List<Task> filteredTasks =
                    _filterTasks(snapshot.data!, _selectedSegment);

                return ListView.builder(
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    Task task = filteredTasks[index];

                    return ListTile(
                      contentPadding: const EdgeInsets.all(8),
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: _buildImageDecoration(task.imageUrl),
                        ),
                      ),
                      title: Text(
                        task.title ?? '', // Handle nullable title
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            task.description ?? '',
                            // Handle nullable description
                            style: TextStyle(
                                color: Colors.grey[700], fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            task.date != null
                                ? DateFormat('dd-MM-yyyy').format(task.date!)
                                : '', // Handle nullable date
                            style: TextStyle(
                                color: Colors.grey[700], fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          const Divider(color: Colors.grey,thickness: 1.0,),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskDetailsScreen(
                                task: task, bloc: widget.bloc),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddTaskScreen(bloc: widget.bloc)),
          );
          _loadTasksFromHive();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  List<Task> _filterTasks(List<Task> tasks, int selectedIndex) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime tomorrow =
        DateTime(now.year, now.month, now.day).add(const Duration(days: 1));

    switch (selectedIndex) {
      case 0: // Today
        return tasks.where((task) {
          return task.date!.year == today.year &&
              task.date!.month == today.month &&
              task.date!.day == today.day;
        }).toList();
      case 1: // Tomorrow
        return tasks.where((task) {
          return task.date!.year == tomorrow.year &&
              task.date!.month == tomorrow.month &&
              task.date!.day == tomorrow.day;
        }).toList();
      case 2: // Upcoming
        return tasks.where((task) {
          return task.date!.isAfter(tomorrow);
        }).toList();
      default:
        return [];
    }
  }
}

DecorationImage? _buildImageDecoration(String imageUrl) {
  if (imageUrl.isNotEmpty) {
    if (imageUrl.startsWith('http')) {
      return DecorationImage(
        fit: BoxFit.cover,
        image: NetworkImage(imageUrl),
      );
    } else if (File(imageUrl).existsSync()) {
      return DecorationImage(
        fit: BoxFit.cover,
        image: FileImage(File(imageUrl)),
      );
    }
  }
  return null;
}
