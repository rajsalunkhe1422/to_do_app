// task_list_screen.dart

import 'package:flutter/material.dart';
import 'package:to_do_app/model/task_model.dart';
import 'package:to_do_app/screen/task_bloc.dart';
import 'package:to_do_app/screen/task_details_screen.dart';
import 'package:to_do_app/screen/add_task_screen.dart';

class TaskListScreen extends StatefulWidget {
  final TaskBloc bloc;

  TaskListScreen({required this.bloc});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
      ),
      body: StreamBuilder<List<Task>>(
        stream: widget.bloc.tasksStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildTaskList(snapshot.data!);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final DateTime? selectedDate = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskScreen(bloc: widget.bloc),
            ),
          );
          if (selectedDate != null) {
            setState(() {
              _selectedDate = selectedDate;
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskList(List<Task> tasks) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        Task task = tasks[index];
        return ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: task.imageUrl.isNotEmpty
                    ? NetworkImage(task.imageUrl) as ImageProvider<Object>
                    : AssetImage('assets/default_image.png')
                as ImageProvider<Object>,
              ),
            ),
          ),
          title: Text(task.title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.description),
              SizedBox(height: 5),
              Text(
                _selectedDate != null
                    ? 'Date: ${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}'
                    : 'No date',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
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
