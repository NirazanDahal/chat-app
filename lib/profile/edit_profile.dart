import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Editprofile extends StatefulWidget {
  const Editprofile({super.key});

  @override
  State<Editprofile> createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit profile"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Center(
              child: Container(
                height: 0.3 * size.width,
                width: 0.3 * size.width,
                decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(60)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(hintText: "Name"),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(hintText: "Email"),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(hintText: "Password"),
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(hintText: "Confirm Password"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: () {}, child: const Text("Cancel")),
                ElevatedButton(onPressed: () {}, child: const Text("Save"))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
