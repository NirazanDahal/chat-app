import 'package:chat_app/profile/edit_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile View"),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Center(
            child: ClipOval(
              child: Image.network(
                "https://lh3.googleusercontent.com/a/ALm5wu1CQBkVX3ON19EwDnjJsNTSuwD-Mp1mNgKAL8ui=s288-p-rw-no",
                height: 0.4 * size.width,
                width: 0.4 * size.width,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Nirajan Dahal",
            style: TextStyle(fontSize: 25),
          ),
          const SizedBox(
            height: 5,
          ),
          const Text("nirajandahal57@gmai.com"),
          const SizedBox(
            height: 5,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => const Editprofile()));
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [Icon(Icons.edit), Text("Edit Profile")],
              ))
        ],
      ),
    );
  }
}
