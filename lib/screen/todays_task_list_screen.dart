import 'dart:io';
import 'package:flutter/material.dart';
import 'package:to_do_app/model/task_model.dart';
import 'package:to_do_app/screen/task_bloc.dart';
import 'package:to_do_app/screen/task_details_screen.dart';

class TodaysTaskListScreen extends StatefulWidget {
  final TaskBloc bloc;

  // Add the Key? parameter and pass it to the super constructor
  TodaysTaskListScreen({required this.bloc, Key? key}) : super(key: key);

  @override
  _TodaysTaskListScreenState createState() => _TodaysTaskListScreenState();
}

class _TodaysTaskListScreenState extends State<TodaysTaskListScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: StreamBuilder<List<Task>>(
        stream: widget.bloc.tasksStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildTodaysTaskList(snapshot.data!);
          } else {
            return const Center(child: Text('Empty List'));
          }
        },
      ),
    );
  }

  Widget _buildTodaysTaskList(List<Task> tasks) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    List<Task> tasksForToday = tasks.where((task) {
      return task.date!.year == today.year &&
          task.date!.month == today.month &&
          task.date!.day == today.day;
    }).toList();
    return ListView.builder(
      itemCount: tasksForToday.length,
      itemBuilder: (context, index) {
        Task task = tasksForToday[index];
        return ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: task.imageUrl.isNotEmpty && task.imageUrl.startsWith('http')
                  ? DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(task.imageUrl),
              )
                  : task.imageUrl.isNotEmpty && File(task.imageUrl).existsSync()
                  ? DecorationImage(
                fit: BoxFit.cover,
                image: FileImage(File(task.imageUrl)),
              )
                  : null,
            ),
          ),
          title: Text(task.title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.description),
              const SizedBox(height: 5),
              Text(task.date.toString()),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    TaskDetailsScreen(task: task, bloc: widget.bloc),
              ),
            );
          },
        );
      },
    );
  }
}
