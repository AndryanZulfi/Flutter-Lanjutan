import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat/screens/auth/login_screen.dart';
import 'package:firebase_chat/utils/helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final colleciton = "chat-agustus2026";
  late TextEditingController textFieldMessageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textFieldMessageController = TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),  
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: actionLogout,
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            listChat(),
            textFieldMessage()
          ],
        )),
    );
  }

  Widget listChat(){
    return Expanded(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection(colleciton).orderBy("time", descending: true).snapshots(), 
        builder: (context, snapshot){
          if(snapshot.hasError){
            return Center(child: CircularProgressIndicator(),);
          }
          return snapshot.data?.size == 0
          ? Center(child: Text("Belum ada pesan"),)
          : ListView.builder(
            reverse: true,
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index){
              final data = snapshot.data?.docs[index].data();
              final messageText = data?['message'] ?? '';
              final sender = data?['sender'] ?? '';
              final timestamp = data?['time'] ?? '';
              final isSender = sender == FirebaseAuth.instance.currentUser?.email;
              
              final docId = snapshot.data?.docs[index].id ?? '';
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Column(
                  crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(sender, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    Row(
                      mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
                      children: [
                        if (isSender) ...[
                          IconButton(onPressed: () => showAlertEdit(docId, messageText), icon: const Icon(Icons.edit, size: 18)),
                          IconButton(onPressed: () => actionDelete(docId), icon: const Icon(Icons.delete, size: 18)),
                        ],
                        Flexible(
                          child: Material(
                            borderRadius: BorderRadius.only(
                              topRight: isSender ? Radius.zero : const Radius.circular(16),
                              topLeft: isSender ? const Radius.circular(16) : Radius.zero,
                              bottomLeft: const Radius.circular(16),
                              bottomRight: const Radius.circular(16),
                            ),
                            color: isSender ? Colors.blue : Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                messageText,
                                style: TextStyle(color: isSender ? Colors.white : Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
            );
        }),
    );
  }
   
  void actionDelete(String id) async {
    try {
      await FirebaseFirestore.instance.collection(colleciton).doc(id).delete();
    } catch (exc) {
      Helper.showSnackBar(context, 'Error deleting message');
    }
  }
  Widget textFieldMessage(){
    return TextField(
      controller: textFieldMessageController,
      textInputAction: TextInputAction.send,
      onSubmitted: (value){
        sendMessage();
      },
      decoration: InputDecoration(
        hintText: "Ketik pesan",
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        suffixIcon: IconButton(
            onPressed: sendMessage,
            icon: Icon(Icons.send)
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(16)
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1),
            borderRadius: BorderRadius.circular(16)
        ),
      ),
    );
  }

  void sendMessage() async{
    if(textFieldMessageController.text.trim().isEmpty){
      return;
    }

    try {
      await FirebaseFirestore.instance.collection(colleciton).add({
        "message": textFieldMessageController.text.trim(),
        "sender": FirebaseAuth.instance.currentUser?.email,
        "time": DateTime.now(),
        
      });

      textFieldMessageController.clear();


    } catch (e) {
      Helper.showSnackBar(context, "Error sending message");
    }
  }

  void actionLogout() async{
   try{
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()), 
        (route) => false);
   } catch(e){
    Helper.showSnackBar(context, "Error logout");
   }
  }

  void showAlertEdit(String id, String message){
    showDialog(context: context, 
    builder: (alertContext){
      final editController = TextEditingController(text: message);
      return AlertDialog(
        title: Text("Edit Message"),
        content: TextField(
          controller: editController,
          autofocus: true,
          maxLines: null,
          decoration: InputDecoration(
            hintText: "Edit message",
            
          ),
          ),
          actions: [
            TextButton(
              onPressed: (){
                if (editController.text.trim().isNotEmpty){
                  actionEdit(id, editController.text.trim());
                  Navigator.pop(alertContext);
                }
              },
              child: Text("Simpan"),
            )
          ],
      );
    });
  }

  void actionEdit(String id, String message) async {
    try {
      await FirebaseFirestore.instance.collection(colleciton).doc(id).update({"message": message});
    } catch (exc) {
      Helper.showSnackBar(context, 'Error edit message');
    }
  }
}