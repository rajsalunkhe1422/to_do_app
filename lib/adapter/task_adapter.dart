import 'package:hive_flutter/adapters.dart';
import 'package:to_do_app/model/task_model.dart';

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 0; // Unique type ID for Task

  @override
  Task read(BinaryReader reader) {
    return Task(
      id: reader.readString(),
      title: reader.readString(),
      description: reader.readString(),
      imageUrl: reader.readString(),
      date: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.writeString(obj.description);
    writer.writeString(obj.imageUrl);
    writer.writeInt(obj.date!.millisecondsSinceEpoch);
  }
}
