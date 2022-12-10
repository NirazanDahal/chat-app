import 'package:chat_app/auth/login_screen.dart';
import 'package:chat_app/chat/chat_detail.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/profile/profile_screen.dart';
import 'package:chat_app/utils/app_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

bool _navigationButtonPresses = false;

class _ChatScreenState extends State<ChatScreen> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 19, 18, 18),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Chats"),
        leading: InkWell(
          onTap: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => const ProfileScreen()));
          },
          child: ClipOval(
            child: Image.network(
              "https://lh3.googleusercontent.com/a/ALm5wu1CQBkVX3ON19EwDnjJsNTSuwD-Mp1mNgKAL8ui=s288-p-rw-no",
              fit: BoxFit.cover,
              height: 40,
              width: 40,
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(AppSettings.navigatorKey.currentContext!)
                    .pushAndRemoveUntil(
                        CupertinoPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (route) => false);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .where(
                    "uid",
                    isNotEqualTo: user?.uid,
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List users = snapshot.data?.docs ?? [];
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          String loggedinUserUid = user!.uid;
                          String otherUserUid = users[index]['uid'];
                          String chatRoomId =
                              createChatRoom(loggedinUserUid, otherUserUid);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ChatDetail(
                                conversationTitle: users[index]['name'],
                                chatRoomId: chatRoomId,
                              ),
                            ),
                          );
                        },
                        title: Text(
                          users[index]['name'],
                          style: const TextStyle(
                              color: Color.fromARGB(255, 193, 183, 183)),
                        ),
                        tileColor: Colors.blue,
                        contentPadding: const EdgeInsets.all(5),
                        leading: ClipOval(
                          child: Image.network(
                            "https://hatrabbits.com/wp-content/uploads/2017/01/random.jpg",
                            fit: BoxFit.cover,
                            height: 40,
                            width: 40,
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  iconSize: 37,
                  onPressed: () {
                    setState(() {});
                    _navigationButtonPresses = true;
                  },
                  icon: Icon(Icons.chat_bubble_rounded,
                      color: _navigationButtonPresses
                          ? Colors.blueAccent
                          : const Color.fromARGB(255, 193, 183, 183)),
                ),
                IconButton(
                  iconSize: 50,
                  onPressed: () {
                    setState(() {});
                    _navigationButtonPresses = true;
                  },
                  icon: Icon(Icons.video_call_rounded,
                      color: _navigationButtonPresses
                          ? Colors.blueAccent
                          : const Color.fromARGB(255, 193, 183, 183)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
