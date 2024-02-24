import 'package:flutter/material.dart';
import 'package:to_do_app/model/task_model.dart';
import 'package:to_do_app/screen/task_bloc.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddTaskScreen extends StatefulWidget {
  final TaskBloc bloc;

  AddTaskScreen({required this.bloc});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  File? _image;
  DateTime? _selectedDate; // Add this line

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2025),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => _getImage(ImageSource.gallery),
                  child: Text('Choose from Gallery'),
                ),
                ElevatedButton(
                  onPressed: () => _getImage(ImageSource.camera),
                  child: Text('Take a Picture'),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectDate(context), // Call _selectDate function
              child: Text('Select Date'),
            ),
            _selectedDate != null
                ? Text(
              'Selected Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
              style: TextStyle(fontSize: 16),
            )
                : SizedBox.shrink(),
            SizedBox(height: 20),
            _image != null
                ? Image.file(
              _image!,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            )
                : SizedBox.shrink(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Task newTask = Task(
                  id: '', // Assign a unique ID
                  title: _titleController.text,
                  description: _descriptionController.text,
                  imageUrl: _image != null ? _image!.path : '', // Add image path
                  date: _selectedDate, // Add selected date
                );
                widget.bloc.addTask(newTask);
                Navigator.pop(context, _selectedDate); // Pass selected date
              },

              child: Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
