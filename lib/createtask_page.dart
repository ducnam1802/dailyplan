import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({super.key});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  DateTime? _day;
  TimeOfDay? _timeStart;
  TimeOfDay? _timeEnd;
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _reviewerController = TextEditingController();
  final List<String> _chairs = [];
  final List<String> _chairsOption = ['Thanh Ngân', 'Hữu Nghĩa'];
  final List<String> _status = [];
  final List<String> availableStatuses = [
    'Tạo mới',
    'Thực hiện',
    'Thành công',
    'Kết thúc'
  ];

  void _toggleStatus(String status) {
    setState(() {
      if (_status.contains(status)) {
        _status.remove(status);
      } else {
        _status.add(status);
      }
    });
  }

  List<Widget> _buildStatusCheckboxes() {
    return availableStatuses.map((status) {
      return CheckboxListTile(
        value: _status.contains(status),
        onChanged: (bool? newValue) {
          if (newValue != null) {
            _toggleStatus(status);
          }
        },
        title: Text(status),
      );
    }).toList();
  }

  void _pickDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _day ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        _day = date;
      });
    }
  }

  void _pickTimeStart() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: _timeStart ?? TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        _timeStart = time;
      });
    }
  }

  void _pickTimeEnd() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: _timeEnd ?? TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        _timeEnd = time;
      });
    }
  }

  Future<void> _saveTask() async {
    if (_formkey.currentState!.validate()) {
      if (_day == null || _timeStart == null || _timeEnd == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vui lòng chọn đầy đủ ngày và giờ.')),
        );
        return;
      }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> tasks = prefs.getStringList('tasks') ?? [];
      final newTaskData = json.encode({
        'id': _idController.text,
        'content': _contentController.text,
        'day': _day?.toIso8601String() ?? '',
        'timeStart': _timeStart != null
            ? '${_timeStart!.hour}:${_timeStart!.minute}'
            : '',
        'timeEnd':
            _timeEnd != null ? '${_timeEnd!.hour}:${_timeEnd!.minute}' : '',
        'location': _locationController.text,
        'chairs': _chairs,
        'note': _noteController.text,
        'status': _status,
        'reviewer': _reviewerController.text,
      });
      tasks.add(newTaskData);
      await prefs.setStringList('tasks', tasks);
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tạo nhiệm vụ mới"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _idController,
                decoration: InputDecoration(labelText: 'Mã công việc'),
                validator: (value) =>
                    value!.isEmpty ? 'Không được để trống' : null,
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(labelText: 'Nội dung công việc'),
                validator: (value) =>
                    value!.isEmpty ? 'Không được để trống' : null,
              ),
              SizedBox(height: 30),
              ListTile(
                title: Text(_day == null
                    ? 'Chọn ngày'
                    : DateFormat('dd/MM/yyyy').format(_day!)),
                trailing: Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),
              SizedBox(height: 30),
              ListTile(
                title: Text(_timeStart == null
                    ? 'Chọn giờ bắt đầu'
                    : _timeStart!.format(context)),
                trailing: Icon(Icons.access_time),
                onTap: _pickTimeStart,
              ),
              SizedBox(height: 30),
              ListTile(
                title: Text(_timeEnd == null
                    ? 'Chọn giờ kết thúc'
                    : _timeEnd!.format(context)),
                trailing: Icon(Icons.access_time),
                onTap: _pickTimeEnd,
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Địa điểm'),
                validator: (value) =>
                    value!.isEmpty ? 'Không được để trống' : null,
              ),
              SizedBox(height: 30),
              DropdownButtonFormField<String>(
                value: _chairs.isNotEmpty ? _chairs.first : null,
                onChanged: (String? newValue) {
                  setState(() {
                    if (newValue != null) {
                      if (_chairs.contains(newValue)) {
                        _chairs.remove(newValue);
                      } else {
                        _chairs.add(newValue);
                      }
                    }
                  });
                },
                items:
                    _chairsOption.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Chọn người chủ trì',
                ),
              ),
              Wrap(
                spacing: 8.0,
                children: _chairs
                    .map((String name) => Chip(
                          label: Text(name),
                          onDeleted: () {
                            setState(() {
                              _chairs.remove(name);
                            });
                          },
                        ))
                    .toList(),
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(labelText: 'ghi chú'),
                validator: (value) =>
                    value!.isEmpty ? 'Không được để trống' : null,
              ),
              SizedBox(height: 30),
             ..._buildStatusCheckboxes(),
             SizedBox(height: 30),
              TextFormField(
                controller: _reviewerController,
                decoration: InputDecoration(labelText: 'Người kiểm duyệt'),
                validator: (value) =>
                    value!.isEmpty ? 'Không được để trống' : null,
              ),
              SizedBox(height: 30),
              Align(
                alignment: Alignment.center,
                child: 
                  ElevatedButton(  
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),            
                    onPressed: _saveTask,
                    child: const Text('Lưu nhiệm vụ', style: TextStyle(color: Colors.white),),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
