import 'package:chat_app/auth/login_screen.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/todopages/add_todo.dart';
import 'package:chat_app/utils/snacks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

bool _isPressed = false;

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                    AppSettings.navigatorKey.currentContext!,
                    CupertinoPageRoute(
                        builder: (context) => const LoginScreen()),
                    (route) => false);
              },
              icon: const Icon(Icons.logout))
        ],
        centerTitle: true,
        title: const Text("Todos"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("todos")
            .where("Created By", isEqualTo: user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List data = snapshot.data?.docs ?? [];
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: ((context, index) {
                return ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: const Icon(Icons.work),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => AddTodo(
                                        documentId: data[index].id,
                                        title: data[index]["task"],
                                      )));
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.green,
                        )),
                    IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => CupertinoAlertDialog(
                                  title: const Text("Are you sure ?"),
                                  content: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextButton(
                                          onPressed: () async {
                                            await FirebaseFirestore.instance
                                                .collection("todos")
                                                .doc(data[index].id)
                                                .delete();

                                            Navigator.pop(AppSettings
                                                .navigatorKey.currentContext!);
                                            showDeleteSnack(
                                                "Task deleted successfully ");
                                          },
                                          child: const Text("Yes")),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("No")),
                                    ],
                                  )));
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        )),
                  ]),
                  title: Center(
                      child: _isPressed
                          ? Text(
                              data[index]["task"],
                              style: const TextStyle(
                                  decoration: TextDecoration.lineThrough),
                            )
                          : Text(data[index]["task"])),
                );
              }),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              CupertinoPageRoute(builder: (context) => const AddTodo()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
