import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:to_do_app/local/hive_storage_repo.dart';
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
  DateTime? _selectedDate;
  late Box _todoBox;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _openBox();
  }

  Future<void> _openBox() async {
    try {
      await Hive.initFlutter();
      _todoBox = await Hive.openBox(HiveStorageRepo.taskListKey);
    } catch (e) {
      print('Error opening box: $e');
    }
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
        title: const Padding(
          padding: EdgeInsets.only(left: 70),
          child: Text(
            'Add Task',
            style: TextStyle(fontSize: Checkbox.width),
          ),
        ),
      ),
      backgroundColor: Colors.blueGrey[50], // Background color added here
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _getImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo),
                  label: const Text('Gallery'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 24),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _getImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 24),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: const Center(child: Text('Select Date')),
            ),
            const SizedBox(height: 10),
            _selectedDate != null
                ? Text(
                    'Selected Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                    style: const TextStyle(fontSize: 16),
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 20),
            _image != null
                ? Image.file(
                    _image!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(bottom: 100, left: 110),
              child: ElevatedButton(
                onPressed: () async {
                  Task newTask = Task(
                    id: '',
                    // Assign a unique ID
                    title: _titleController.text,
                    description: _descriptionController.text,
                    imageUrl: _image != null ? _image!.path : '',
                    // Add image path
                    date: _selectedDate!, // Add selected date
                  );

                  try {
                    // Save the new task to Hive
                    await _todoBox.add(newTask.toMap());
                    print('Task added to Hive: $newTask');
                  } catch (e) {
                    print('Error adding task to box: $e');
                  }

                  widget.bloc.addTask(newTask);
                  Navigator.pop(context);
                },
                child: const Text('Add Task'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
