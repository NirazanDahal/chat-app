import 'package:chat_app/auth/login_screen.dart';
import 'package:chat_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddTodo extends StatefulWidget {
  final String? documentId;
  final String? title;
  const AddTodo({super.key, this.documentId, this.title});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final TextEditingController _addController = TextEditingController();
  final GlobalKey<FormState> _todoKey = GlobalKey<FormState>();

  todo() async {
    if (_todoKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (widget.documentId == null) {
        await FirebaseFirestore.instance
            .collection("todos")
            .add({"task": _addController.text, "Created By": user?.uid});
      } else {
        await FirebaseFirestore.instance
            .collection("todos")
            .doc(widget.documentId)
            .update({"task": _addController.text});
      }
    }

    Navigator.pop(AppSettings.navigatorKey.currentContext!);
    _addController.clear();
  }

  @override
  void initState() {
    super.initState();
    if (widget.title != null) {
      _addController.text = widget.title!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(widget.documentId == null ? "Add" : "Update"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _todoKey,
          child: Column(children: [
            const SizedBox(height: 20),
            TextFormField(
              controller: _addController,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  return null;
                } else {
                  return "Task cannot be null";
                }
              },
              decoration: InputDecoration(
                  hintText: "Add Todo",
                  suffix: IconButton(
                      onPressed: () {
                        _addController.clear();
                      },
                      icon: const Icon(Icons.clear))),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel")),
                ElevatedButton(
                    onPressed: () {
                      todo();
                    },
                    child: Text(widget.documentId == null ? "Add" : "Update"))
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
