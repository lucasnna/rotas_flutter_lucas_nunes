import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: MaterialApp(
        title: 'To-Do List',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: const TaskListScreen(),
      ),
    );
  }
}

class TaskProvider extends ChangeNotifier {
  List<String> tasks = [];

  void addTask(String task) {
    tasks.add(task);
    notifyListeners();
  }

  void removeTask(int index) {
    tasks.removeAt(index);
    notifyListeners();
  }
}

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var tasksProvider = Provider.of<TaskProvider>(context);
    var tasks = tasksProvider.tasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(tasks[index]),
            onDismissed: (direction) {
              tasksProvider.removeTask(index);
            },
            background: Container(
              color: const Color.fromARGB(255, 132, 0, 255),
              alignment: Alignment.centerRight,
              child: const Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ),
            child: ListTile(
              title: Text(tasks[index]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );
          if (newTask != null) {
            tasksProvider.addTask(newTask);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddTaskScreen extends StatelessWidget {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var tasksProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Incluir Tarefa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                labelText: 'Titulo da Tarefa',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final taskTitle = _textEditingController.text.trim();
                if (taskTitle.isNotEmpty) {
                  tasksProvider.addTask(taskTitle);
                  Navigator.pop(context);
                }
              },
              child: const Text('Incluir Tarefa'),
            ),
          ],
        ),
      ),
    );
  }
}
