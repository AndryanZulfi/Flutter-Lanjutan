import 'package:flutter/material.dart';
import 'package:todo_list_app/database/todo_database.dart';
import 'package:todo_list_app/main.dart';
import 'package:todo_list_app/model/todo.dart';
import 'package:todo_list_app/utils/helper.dart';

class FormScreen extends StatefulWidget {

  final Todo? updateTodo;
  const FormScreen({super.key, this.updateTodo});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {

  String? title;
  String? selectedCategory;
  String? selectedPriority;
  List<String> selectedDays = [];
  bool isCompleted = false;  
  
  final categories = ["Pekerjaan", "Pribadi", "Lainnya"];
  final priorities = ["Tinggi","Sedang","Rendah"];
  final days = ["Senin","Selasa","Rabu","Kamis","Jumat","Sabtu","Minggu"];

  late GlobalKey<FormState> formKey;
  late TodoDatabase todoDatabase;

  @override
  void initState() {
    super.initState();

    formKey = GlobalKey();
    todoDatabase = TodoDatabase();

    if(widget.updateTodo != null){
      title = widget.updateTodo?.title;
      selectedCategory = widget.updateTodo?.category;
      selectedPriority = widget.updateTodo?.priority;
      selectedDays = widget.updateTodo?.days.split(",") ?? [];
      isCompleted = widget.updateTodo?.isCompleted ?? false;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Form Screen"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Judul"),
              TextFormField(
                initialValue: title,
                decoration: InputDecoration(hintText: "Masukkan judul"),
                onChanged: (value){
                  title = value.trim();
                },
                validator: (value){
                  if(value == null || value.trim().isEmpty){
                    return "Judul tidak boleh kosong";
                  }
                  return null;
                },
              ),
              SizedBox(height: 8),
              Text("Kategori"),
              DropdownButtonFormField(
                  initialValue: selectedCategory,
                  hint: Text("Pilih Kategori"),
                  items: categories.map((category){
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (onSelected){
                    setState(() {
                      selectedCategory = onSelected;
                    });
                  },
                  validator: (value){
                    if (value == null){
                      return "Kategori wajib dipilih";
                    }
                    return null;
                  },
              ),
              SizedBox(height: 8),
              Text("Prioritas"),
              Row(
                children: priorities.map((priority){
                  return Flexible(
                    child: RadioMenuButton(
                        value: priority, 
                        groupValue: selectedPriority, 
                        onChanged: (onSelected){
                          setState(() {
                            selectedPriority = onSelected;
                          });
                        }, 
                        child: Text(priority),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 8),
              Text("Hari"),
              Wrap(
                children: days.map((day){
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CheckboxMenuButton(
                          value: selectedDays.contains(day), 
                          onChanged: (isSelected){
                            setState(() {
                              if (isSelected == true){
                                selectedDays.add(day);
                              } else {
                                selectedDays.remove(day);
                              }
                            });
                          }, 
                          child: Text(day)
                      )
                    ],
                  );
                }).toList(),
              ),
              SizedBox(height: 8),
              Text("Sudah Selesai?"),
              Switch(
                  value: isCompleted,
                  onChanged: (value){
                    setState(() {
                      isCompleted = value;
                    });
                  }
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                    onPressed: (){
                      if(formKey.currentState!.validate()
                          && selectedPriority != null
                          && selectedDays.isNotEmpty){
                        widget.updateTodo != null ? actionUpdate() : actionInsert();
                      } else {
                        Helper.showSnackbar(context, "Lengkapi yang kosong");
                      }
                    },
                    child: Text("Submit")
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void actionInsert() async {

    final todo = Todo(
      title: title!,
      category: selectedCategory!,
      priority: selectedPriority!,
      days: selectedDays.join(","),
      isCompleted: isCompleted,
      time: DateTime.now(),
    );

    try{
      await todoDatabase.insertTodo(todo);
      Helper.showSnackbar(context, "Insert data berhasil", bgColor: Colors.green);

      Navigator.pop(context, Helper.NEED_REFRESH);
    } catch (exc){
      Helper.showSnackbar(context, "Insert data gagal, $exc");
    }

  }

  void actionUpdate() async {

    final todo = Todo(
      id: widget.updateTodo?.id,
      title: title!,
      category: selectedCategory!,
      priority: selectedPriority!,
      days: selectedDays.join(","),
      isCompleted: isCompleted,
      time: DateTime.now(),
    );

    try{
      await todoDatabase.updateTodo(todo);
      Helper.showSnackbar(context, "Update data berhasil", bgColor: Colors.green);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
          (route) => false,
      );
    } catch (exc){
      Helper.showSnackbar(context, "Update data gagal, $exc");
    }

  }


}