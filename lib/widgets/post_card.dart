// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/models/user_model.dart';
import 'package:insta_clone/providers.dart/user_provider.dart';
import 'package:insta_clone/resourse/firestore_methods.dart';
import 'package:insta_clone/screens/comments.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/utils.dart';
import 'package:insta_clone/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({Key? key, this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentlen = 0;

  @override
  void initState() {
    getcomments();
    super.initState();
  }

  getcomments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentlen = snap.docs.length;
      setState(() {});
    } catch (e) {
      showSnackbar(e.toString(), context);
    }
  }

  bool isAnimating = false;
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    widget.snap["profileImage"],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.snap["userName"],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shrinkWrap: true,
                          children: ['Delete']
                              .map((e) => InkWell(
                                    onTap: () {
                                      FireStoremethods().deletePost(
                                        widget.snap['postId'],
                                      );
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 16),
                                      child: Text(e),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.more_vert,
                  ),
                )
              ],
            ),
          ),
          //Image section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: GestureDetector(
              onDoubleTap: () async {
                await FireStoremethods().likePost(widget.snap['postId'],
                    user.uid, widget.snap['likes'], true);
                setState(() {
                  isAnimating = true;
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: double.infinity,
                    child: Image.network(
                      widget.snap["postUrl"],
                      fit: BoxFit.cover,
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: isAnimating ? 1 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: LikeAnimation(
                      isAnimating: isAnimating,
                      duration: const Duration(milliseconds: 400),
                      onEnd: () {
                        setState(
                          () {
                            isAnimating = false;
                          },
                        );
                      },
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 130,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          //like comments section
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap["likes"].contains(user.uid),
                smallLike: true,
                child: IconButton(
                    onPressed: () async {
                      await FireStoremethods().likePost(widget.snap['postId'],
                          user.uid, widget.snap['likes'], false);
                      setState(() {
                        isAnimating = true;
                      });
                    },
                    icon: widget.snap["likes"].contains(user.uid)
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                          )),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => Comments(
                              snap: widget.snap,
                            )));
                  },
                  icon: const Icon(Icons.comment_outlined)),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.send_rounded)),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.bookmark_border_outlined),
                  ),
                ),
              )
            ],
          ),

          //Description and comments
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.snap["likes"].length} likes",
                  style: Theme.of(context).textTheme.bodyText1,
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 10, left: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.white),
                    children: [
                      TextSpan(
                        text: "${widget.snap["userName"]}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: " ${widget.snap["description"]}",
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => Comments(
                    snap: widget.snap,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.only(top: 5, left: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "View all ${commentlen.toString()} Comments",
                    style: const TextStyle(fontSize: 14, color: secondaryColor),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 5, left: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat.yMMMd().format(
                    widget.snap['datePublish'].toDate(),
                  ),
                  style: const TextStyle(fontSize: 10, color: secondaryColor),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
