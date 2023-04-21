import 'package:hive/hive.dart';

class ToDoDatabase {
  List ToDoList = [];

  //reference of our box
  final _myBox = Hive.box('mybox');

  //run this method for 1st time ever opening this app
  void createInitiallData() {
    ToDoList = [
      ["Wake up at 5am", false],
      ["Do Exercise", false],
    ];
  }

  //load the data from datbase
  void loadData() {
    ToDoList = _myBox.get("ToDoList");
  }

  //update the database
  void updatedatabase() {
    _myBox.put("ToDoList", ToDoList);
  }
}
