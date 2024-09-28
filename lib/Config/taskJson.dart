import 'dart:convert';
import 'package:daily_planner/data/task.dart';
import 'package:shared_preferences/shared_preferences.dart';

void saveTasks(List<Task> tasks) async {
  final prefs = await SharedPreferences.getInstance();
  String json = jsonEncode(tasks.map((task) => task.toJson()).toList());
  await prefs.setString('tasks', json);
}

Future<List<Task>> loadTasks() async {
  final prefs = await SharedPreferences.getInstance();
  String? json = prefs.getString('tasks');
  if (json == null) return [];
  Iterable data = jsonDecode(json);
  return data.map((taskJson) => Task.fromJson(taskJson)).toList();
}