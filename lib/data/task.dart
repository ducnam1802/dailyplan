import 'package:flutter/material.dart';

class Task {
  String id;
  String content;
  DateTime day;
  TimeOfDay timeStart;
  TimeOfDay timeEnd;
  String location;
  List<String> chairs;
  String note;
  List<String> status;
  String reviewer;

   Task({
    required this.id,
    required this.content,
    required this.day,
    required this.timeStart,
    required this.timeEnd,
    required this.location,
    required this.chairs,
    required this.note,
    required this.status,
    required this.reviewer,
  });
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      content: json['content'] as String,
      day: DateTime.parse(json['day'] as String),
      timeStart: _parseTime(json['timeStart'] as String),
      timeEnd: _parseTime(json['timeEnd'] as String),
      location: json['location'] as String,
      chairs: List<String>.from(json['chairs'] as List<dynamic>),
      note: json['note'] as String,
      status: List<String>.from(json['status'] as List<dynamic>),
      reviewer: json['reviewer'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'day': day.toIso8601String(),
      'timeStart': _formatTime(timeStart),
      'timeEnd': _formatTime(timeEnd),
      'location': location,
      'chairs': chairs,
      'note': note,
      'status': status,
      'reviewer': reviewer,
    };
  }
   static TimeOfDay _parseTime(String formattedString) {
    final timeParts = formattedString.split(':');
    return TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
  }

  static String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}