import 'package:flutter/material.dart';
import 'package:to_do_app/model/task_model.dart';
import 'package:to_do_app/screen/task_bloc.dart';
class EditTaskScreen extends StatefulWidget {
  final Task task;
  final TaskBloc bloc;

  EditTaskScreen({required this.task, required this.bloc});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Task updatedTask = Task(
                  id: widget.task.id,
                  title: _titleController.text,
                  description: _descriptionController.text,
                  imageUrl: widget.task.imageUrl,
                );
                widget.bloc.updateTask(updatedTask);
                Navigator.pop(context, updatedTask); // Return updated task
              },
              child: Text('Save Changes'),
            ),

          ],
        ),
      ),
    );
  }
}

//
// class EditTaskScreen extends StatefulWidget {
//   final Task task;
//   final TaskBloc bloc;
//
//   EditTaskScreen({required this.task, required this.bloc});
//
//   @override
//   _EditTaskScreenState createState() => _EditTaskScreenState();
// }
//
// class _EditTaskScreenState extends State<EditTaskScreen> {
//   late TextEditingController _titleController;
//   late TextEditingController _descriptionController;
//
//   @override
//   void initState() {
//     super.initState();
//     _titleController = TextEditingController(text: widget.task.title);
//     _descriptionController = TextEditingController(text: widget.task.description);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Task'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               controller: _titleController,
//               decoration: InputDecoration(labelText: 'Title'),
//             ),
//             TextField(
//               controller: _descriptionController,
//               decoration: InputDecoration(labelText: 'Description'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Task updatedTask = Task(
//                   id: widget.task.id,
//                   title: _titleController.text,
//                   description: _descriptionController.text,
//                   imageUrl: widget.task.imageUrl,
//                 );
//                 widget.bloc.updateTask(updatedTask);
//                 Navigator.pop(context);
//               },
//               child: Text('Save Changes'),
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
// }
