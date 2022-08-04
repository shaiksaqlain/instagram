// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/resourse/firestore_methods.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../providers.dart/user_provider.dart';
import '../widgets/comment_card.dart';

class Comments extends StatefulWidget {
  final snap;
  const Comments({Key? key, required this.snap}) : super(key: key);

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final TextEditingController _controller = TextEditingController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text("Comments"),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("posts")
            .doc(widget.snap['postId'])
            .collection('comments')
            .orderBy('datePublish', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return CommentCard(
                snap: snapshot.data!.docs[index].data(),
              );
            },
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 16, right: 8),
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(user.picUrl),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                      hintText: "Comment as ${user.userName}",
                      border: InputBorder.none),
                ),
              ),
              InkWell(
                onTap: () async {
                  await FireStoremethods().postComment(
                      widget.snap['postId'],
                      _controller.text,
                      user.uid,
                      user.userName,
                      user.picUrl,
                      context);

                  _controller.clear();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  child: const Text(
                    "Post",
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
