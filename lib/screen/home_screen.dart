import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String API_URL = "http://127.0.0.1:5001/todos";
  
  Future<List<dynamic>> getTodoList() async {
    final response = await http.get(Uri.parse(API_URL));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    getTodoList().then((value) {
      print(value);
      setState(() {
        todolist = value;
      });
    });
  }

  List<dynamic> todolist = [];
  final TextEditingController task = TextEditingController();

  void _addTodoItem() {
    if (task.text.isNotEmpty) {
      setState(() {
        todolist.add(task.text);
        task.clear();
      });
    }
  }

  void _deleteTodoItem(int index) {
    setState(() {
      todolist.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: task,
                      decoration: const InputDecoration(
                        labelText: 'สิ่งที่ต้องทำ',
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _addTodoItem,
                      child: const Text('เพิ่มสิ่งที่ต้องทำ'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: todolist.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(todolist[index].toString()), // Ensure the dynamic type is displayed as string
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteTodoItem(index),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
