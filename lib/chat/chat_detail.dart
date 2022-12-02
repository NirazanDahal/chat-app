import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_clippers/custom_clippers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatDetail extends StatefulWidget {
  final String chatRoomId;
  const ChatDetail({super.key, required this.chatRoomId});

  @override
  State<ChatDetail> createState() => _ChatDetailState();
}

bool _textFieldChanged = false;

class _ChatDetailState extends State<ChatDetail> {
  final TextEditingController _textFieldController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.purpleAccent,
                    )),
              ],
            ),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.call,
                    color: Colors.purpleAccent,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.video_camera_front,
                    color: Colors.purpleAccent,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.info,
                    color: Colors.purpleAccent,
                  )),
              const SizedBox(
                width: 10,
              )
            ],
            backgroundColor: Colors.black,
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("chats")
                      .doc(widget.chatRoomId)
                      .collection("messages")
                      .orderBy("created_at", descending: true)
                      .snapshots(),
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      final chats = snapshot.data?.docs ?? [];
                      return ListView.builder(
                          itemCount: chats.length,
                          reverse: true,
                          itemBuilder: (context, index) {
                            bool isSentByMe =
                                user?.uid == chats[index]["sent_by"];
                            return Row(
                              mainAxisAlignment: isSentByMe
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                if (!isSentByMe)
                                  ClipOval(
                                    child: Image.network(
                                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT2ivegcSCdaZPYRybbCcaJgWtpuqblhzAq66hP5hg&s",
                                      height: 40,
                                      width: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                // Text(isSentByMe ? "Hi" : "Hellow"),
                                // isSentByMe ? const Text("Hi") : const Text("Hellow Bro"),
                                ClipPath(
                                  clipper: isSentByMe
                                      ? LowerNipMessageClipper(isSentByMe
                                          ? MessageType.send
                                          : MessageType.receive)
                                      : LowerNipMessageClipper(isSentByMe
                                          ? MessageType.send
                                          : MessageType.receive),
                                  child: Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                        color: isSentByMe
                                            ? Colors.purpleAccent
                                            : Colors.green),
                                    child: Center(
                                      child: Text(
                                        chats[index][_textFieldController.text],
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ),
                                if (isSentByMe)
                                  ClipOval(
                                    child: Image.network(
                                      "https://lh3.googleusercontent.com/a/ALm5wu1CQBkVX3ON19EwDnjJsNTSuwD-Mp1mNgKAL8ui=s288-p-rw-no",
                                      height: 40,
                                      width: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                              ],
                            );
                          });
                    }

                    return const CircularProgressIndicator();
                  }),
                ),
              ),
              SizedBox(
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.blue,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.photo_rounded,
                            color: Colors.blue,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.mic,
                            color: Colors.blue,
                          )),
                      Expanded(
                        child: TextFormField(
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              setState(() {});
                              _textFieldChanged = true;
                            } else {
                              setState(() {});
                              _textFieldChanged = false;
                            }
                          },
                          onTap: () {
                            setState(() {});
                          },
                          controller: _textFieldController,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {},
                                  icon:
                                      const Icon(Icons.emoji_emotions_rounded)),
                              contentPadding: const EdgeInsets.all(10),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25))),
                        ),
                      ),
                      IconButton(
                          onPressed: () async {
                            final auth = FirebaseAuth.instance.currentUser;
                            if (_textFieldController.text.isNotEmpty) {
                              await FirebaseFirestore.instance
                                  .collection("chats")
                                  .doc(widget.chatRoomId)
                                  .collection("messages")
                                  .add({
                                "message": _textFieldController.text,
                                "created_at": DateTime.now().toString(),
                                "chat_room_id": widget.chatRoomId,
                                "sent_by": auth?.uid
                              });
                              _textFieldController.clear();
                            }
                          },
                          icon: Icon(
                            _textFieldChanged ? Icons.send : Icons.thumb_up,
                            color: Colors.blue,
                          )),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
