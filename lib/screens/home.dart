import 'dart:ffi';
import '../data/database.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todoapp/data/database.dart';
import '../util/dailogbox.dart';
import '../util/todotile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//refencre of hive box
  final _myBox = Hive.box('mybox');
  ToDoDatabase db = ToDoDatabase();

  @override
  void initState() {
    // if this app is pening for1st time
    if (_myBox.get('ToDOList') == null) {
      db.createInitiallData();
    } else {
      //if exists already or app is opened data will load this
      db.loadData();
    }

    // TODO: implement initState
    super.initState();
  }

  // text controller
  final _controller = TextEditingController();

  // List ToDoList = [
  //   ['MAKE TUTORIAL', false],
  //   ['DO EXERCISE', false],
  // ];
  void CheckboxChanged(bool? value, int index) {
    setState(() {
      db.ToDoList[index][1] = !db.ToDoList[index][1];
    });
    db.updatedatabase();
  }

  // save a new task
  void SaveMyTask() {
    setState(() {
      db.ToDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updatedatabase();
  }

  // create a new task
  void createNewTask() {
    showDialog(
      context: context,
      builder: (ctx) {
        return dailogBox(
          controller: _controller,
          onSave: SaveMyTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  // delete Task;
  void deleteTask(int index) {
    setState(() {
      db.ToDoList.removeAt(index);
    });
    db.updatedatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        centerTitle: true,
        title: Text('To Do App'),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: db.ToDoList.length,
        itemBuilder: (BuildContext context, int index) {
          return ToDoTile(
              TaskName: db.ToDoList[index][0],
              TaskCompleted: db.ToDoList[index][1],
              onChanged: (value) => CheckboxChanged(value, index),
              deleteFunction: (context) => deleteTask(index));
        },

        // children: [
        //   ToDoTile(
        //     TaskName: 'make a tea',
        //     TaskCompleted: true,
        //     onChanged: (p0) {},
        //   ),
        //   ToDoTile(
        //     TaskName: 'class taken',
        //     TaskCompleted: true,
        //     onChanged: (p0) {},
        //   ),
        //   ToDoTile(
        //     TaskName: 'go to gym',
        //     TaskCompleted: true,
        //     onChanged: (p0) {},
        //   ),
        // ],
      ),
    );
  }
}
