import 'package:flutter/material.dart';
import 'package:to_do_app/model/task_model.dart';
import 'package:to_do_app/screen/edit_task_screen.dart';
import 'package:to_do_app/screen/task_bloc.dart';

class TaskDetailsScreen extends StatefulWidget {
  final Task task;
  final TaskBloc bloc;

  TaskDetailsScreen({required this.task, required this.bloc});

  @override
  _TaskDetailsScreenState createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  Task? _updatedTask;

  @override
  Widget build(BuildContext context) {
    // Use _updatedTask if it's not null, otherwise use widget.task
    final displayedTask = _updatedTask ?? widget.task;

    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              displayedTask.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              displayedTask.description,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final updatedTask = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditTaskScreen(task: widget.task, bloc: widget.bloc),
                      ),
                    );
                    if (updatedTask != null) {
                      setState(() {
                        _updatedTask = updatedTask;
                      });
                    }
                  },
                  child: Text('Edit'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    widget.bloc.deleteTask(displayedTask.id);
                    Navigator.pop(context);
                  },
                  child: Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


// class TaskDetailsScreen extends StatelessWidget {
//   final Task task;
//   final TaskBloc bloc;
//
//   TaskDetailsScreen({required this.task, required this.bloc});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Task Details'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               task.title,
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 10),
//             Text(
//               task.description,
//               style: TextStyle(fontSize: 18),
//             ),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // ElevatedButton(
//                 //   onPressed: () {
//                 //     // EditTaskScreen(task: task, bloc: bloc);
//                 //     Navigator.push(
//                 //       context,
//                 //       MaterialPageRoute(
//                 //         builder: (context) => EditTaskScreen(task: task, bloc: bloc),
//                 //       ),
//                 //     );
//                 //   },
//                 //   child: Text('Edit'),
//                 // ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     final updatedTask = await Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => EditTaskScreen(task: task, bloc: bloc),
//                       ),
//                     );
//                     if (updatedTask != null) {
//                       // Update task details screen with the updated task
//                       setState(() {
//                         task = updatedTask;
//                       });
//                     }
//                   },
//                   child: Text('Edit'),
//                 ),
//
//                 SizedBox(width: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     bloc.deleteTask(task.id);
//                     Navigator.pop(context);
//                   },
//                   child: Text('Delete'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
