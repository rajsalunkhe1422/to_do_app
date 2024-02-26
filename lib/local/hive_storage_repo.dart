
import 'package:hive/hive.dart';

class HiveStorageRepo {

  bool toBoolean(String str, [strict = false]) {
    if (strict == true) {
      return str == '1' || str == 'true';
    }
    return str != '0' && str != 'false' && str != '';
  }
  static const todo = 'todo';
  static const String taskListKey = 'task_list';
  var hiveBox = Hive.box(todo);
}

