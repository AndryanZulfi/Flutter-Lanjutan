import 'package:flutter/material.dart';
import 'package:todo_list_app/database/todo_database.dart';
import 'package:todo_list_app/model/todo.dart';
import 'package:todo_list_app/screens/form_screen.dart';
import 'package:todo_list_app/utils/helper.dart';

class DetailScreen extends StatefulWidget {

  final int id;
  final bool isLandscape;
  final VoidCallback? onDelete;


  const DetailScreen({
    super.key,
    required this.id,
    this.isLandscape = false,
    this.onDelete,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  late TodoDatabase todoDatabase;
  Todo? detailTodo;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    todoDatabase = TodoDatabase();
    getDetailTodo();
  }

  @override
  void didUpdateWidget(covariant DetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.id != oldWidget.id) {
      getDetailTodo();
    }
  }

  void getDetailTodo() async {
    isLoading = true;
    await todoDatabase.getTodoById(widget.id)
      .then((value){
        detailTodo = value;
      })
      .catchError((error){
        Helper.showSnackbar(context, "Error saat menampilkan detail $error");
      })
      .whenComplete((){
        setState(() {
          isLoading = false;
        });
     });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail"),
        automaticallyImplyLeading: !widget.isLandscape,
        actions: [
          IconButton(
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FormScreen(updateTodo: detailTodo))
                );
              },
              icon: Icon(Icons.edit)
          ),
          IconButton(onPressed: showConfirmDelete, icon: Icon(Icons.delete)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    detailTodo?.title ?? "no title",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                detailTodo?.isCompleted == true
                    ? Icon(Icons.check_circle, color: Colors.green)
                    : Icon(
                  Icons.do_not_disturb_on_rounded,
                  color: Colors.orange,
                ),
              ],
            ),
            Text("Kategori: ${detailTodo?.category}", style: TextStyle(fontSize: 20)),
            Text("Prioritas: ${detailTodo?.priority}", style: TextStyle(fontSize: 20)),
            Text("Hari: ${detailTodo?.days}", style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }

  void showConfirmDelete(){
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (alertContext){
          return AlertDialog(
            title: Text("Konfirmasi"),
            content: Text("Apakah anda yakin untuk menghapus data ini?"),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(alertContext);
                  },
                  child: Text("Batal")
              ),
              TextButton(
                  onPressed: (){
                    Navigator.pop(alertContext);
                    actionDelete();
                  },
                  child: Text("Hapus")
              ),
            ],
          );
        }
    );
  }

  void actionDelete() async {
    try{
      await todoDatabase.deleteTodo(widget.id);
      Helper.showSnackbar(context, "Hapus data berhasil", bgColor: Colors.green);

      if (!widget.isLandscape) {
        Navigator.pop(context, Helper.NEED_REFRESH);
      } else {
        widget.onDelete?.call();
      }

    }catch (exc){
      Helper.showSnackbar(context, "Hapus data gagal, $exc");
    }
  }

}
