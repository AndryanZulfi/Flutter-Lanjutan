import 'package:flutter/material.dart';
import 'package:todo_list_app/database/todo_database.dart';
import 'package:todo_list_app/model/todo.dart';
import 'package:todo_list_app/screens/detail_screen.dart';
import 'package:todo_list_app/screens/form_screen.dart';
import 'package:todo_list_app/utils/helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late TodoDatabase todoDatabase;
  List<Todo> listTodo = [];
  bool isLoading = false;
  int? selectedTodoId;


  @override
  void initState() {
    super.initState();
    todoDatabase = TodoDatabase();
    getListTodo();
  }

  void getListTodo() async {
    isLoading = true;
    await todoDatabase.getAllTodo()
        .then((value){
          listTodo = value;
        })
        .catchError((error){
          Helper.showSnackbar(context, "Error saat menampilkan data $error");
        })
        .whenComplete((){
          setState(() {
            isLoading = false;
          });
        });
  }

  void actionDelete() {
    setState(() {
      selectedTodoId = null;
    });
    getListTodo();
  }
  
  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenOrientation = MediaQuery.of(context).orientation;
    Widget body;

    if (screenOrientation == Orientation.landscape) {
      body = Row(
        children: [
          Expanded(
            child: buildListTodo(
              selectedId: (id) {
                setState(() {
                  selectedTodoId = id;
                });
              },
            ),
          ),
          Expanded(
            child: selectedTodoId != null
                ? DetailScreen(id: selectedTodoId!, isLandscape: true, onDelete: () => actionDelete(),)
                : const Center(
                    child: Text("Silahkan pilih data"),
                  ),
          ),
        ],
      );
    } else {
      body = buildListTodo(
        selectedId: (id) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailScreen(id: id, isLandscape: false,)),
          ).then((value) {
            if (value == Helper.NEED_REFRESH) {
              getListTodo();
            }
          });
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Todo List"),
      ),
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FormScreen()),
          ).then((value) {
            if (value == Helper.NEED_REFRESH) {
              getListTodo();
            }
          });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildListTodo({required void Function(int id) selectedId}) {
    return Center(
      child: isLoading
          ? const CircularProgressIndicator()
          : listTodo.isEmpty
              ? const Text("Belum ada data")
              : ListView.builder(
                  itemCount: listTodo.length,
                  itemBuilder: (context, index) {
                    final todo = listTodo[index];
                    return cardTodo(todo, selectedId);
                  },
                ),
    );
  }

  /// tampilkan card/kotak data
  Widget cardTodo(Todo todo, void Function(int id) selectedId) {
    return GestureDetector(
      onTap: () {
        selectedId(todo.id ?? 0);
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      todo.title,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  todo.isCompleted
                      ? Icon(Icons.check_circle, color: Colors.green)
                      : Icon(
                        Icons.do_not_disturb_on_rounded,
                        color: Colors.orange,
                      ),
                ],
              ),
              Text("Kategori: ${todo.category}", style: TextStyle(fontSize: 20)),
              Text("Prioritas: ${todo.priority}", style: TextStyle(fontSize: 20)),
              Text("Hari: ${todo.days}", style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }


}
