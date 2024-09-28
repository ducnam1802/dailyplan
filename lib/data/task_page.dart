import 'dart:convert';

import 'package:daily_planner/createtask_page.dart';
import 'package:flutter/material.dart';
import 'package:daily_planner/data/task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    final pref = await SharedPreferences.getInstance();
    List<String> allTasks = pref.getStringList('tasks') ?? [];
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    List<Task> activeTasks = allTasks
        .map((taskJson) => Task.fromJson(jsonDecode(taskJson)))
        .where((task) => !task.day.isBefore(today))
        .toList();
    setState(() {
      tasks = activeTasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhiệm vụ hàng ngày'),
        backgroundColor: Colors.blue,
      ),
      body: RefreshIndicator(
          onRefresh: loadTasks,
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (BuildContext context, int index) {
              Task task = tasks[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  leading: Image.asset('assets/images/task.png',
                      width: 80, height: 250),
                  title: Text(task.content,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Nội dung công việc: ${task.content}"),
                      Text(
                        "Ngày làm: ${task.day.toIso8601String().substring(0, 10)}",
                        style: const TextStyle(color: Colors.green),
                      ),
                      Text("Giờ bắt đầu: ${task.timeStart.format(context)}"),
                      Text("Giờ kết thúc: ${task.timeEnd.format(context)}"),
                      Text("Địa điểm: ${task.location}"),
                      Text("Chủ tọa: ${task.chairs}"),
                      Text("Ghi chú: ${task.note}"),
                      Text("Trạng thái: ${task.status}"),
                      Text("Người kiểm duyệt: ${task.reviewer}"),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {},
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              );
            },
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(builder: (context) => CreateTaskPage()),
          )
              .then((value) {
            if (value == true) {
              loadTasks();
            }
          });
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  void updateTask(Task task) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> tasks = prefs.getStringList('tasks') ?? [];
    int index =
        tasks.indexWhere((t) => Task.fromJson(jsonDecode(t)).id == task.id);
    if (index != -1) {
      tasks[index] = jsonEncode(task.toJson());
      await prefs.setStringList('tasks', tasks);
    }
  }
}
