// import 'package:chat_app/main.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class UpdatePage extends StatefulWidget {
//   final String? documentId;
//   final String? title;
//   const UpdatePage({super.key, this.documentId, this.title});

//   @override
//   State<UpdatePage> createState() => _UpdatePageState();
// }

// class _UpdatePageState extends State<UpdatePage> {
//   final TextEditingController _updateController = TextEditingController();

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   _updateController.text = widget.title!;
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Update Todo"),
//       ),
//       body: Column(
//         children: [
//           const SizedBox(
//             height: 20,
//           ),
//           TextFormField(
//             controller: _updateController,
//             decoration: const InputDecoration(hintText: "Update"),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           ElevatedButton(
//               onPressed: () async {
//                 await FirebaseFirestore.instance
//                     .collection("todos")
//                     .doc(widget.documentId)
//                     .update({"task": _updateController.text});

//                 Navigator.of(AppSettings.navigatorKey.currentContext!).pop();
//               },
//               child: const Text("Update"))
//         ],
//       ),
//     );
//   }
// }
