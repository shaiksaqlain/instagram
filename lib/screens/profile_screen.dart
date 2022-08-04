// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/utils.dart';
import 'package:insta_clone/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ignore: prefer_typing_uninitialized_variables
  var userData;
  var postLen;
  var followers;
  bool isFollowing = false;

  var following;
  bool isLoading = false;
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    isLoading = true;
    setState(() {});
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      userData = snapshot.data();
      postLen = postSnap.docs.length;
      followers = snapshot.data()!['followers'].length;
      following = snapshot.data()!['following'].length;
      isFollowing = snapshot
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackbar(e.toString(), context);
    }
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(userData['userName']),
              centerTitle: false,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(
                              userData['picUrl'],
                            ),
                            radius: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    buildStatColumn(postLen, 'Posts'),
                                    buildStatColumn(followers, 'Followers'),
                                    buildStatColumn(following, 'Following'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid
                                        ? FollowButton(
                                            textColor: primaryColor,
                                            backgroundColor:
                                                mobileBackgroundColor,
                                            borderColor: Colors.grey,
                                            function: () {},
                                            text: "Edit Profile")
                                        : isFollowing
                                            ? FollowButton(
                                                textColor: Colors.white,
                                                backgroundColor: Colors.black,
                                                borderColor: Colors.grey,
                                                function: () {},
                                                text: "Unfollow")
                                            : FollowButton(
                                                textColor: Colors.white,
                                                backgroundColor:
                                                    primaryColor,
                                                borderColor: Colors.grey,
                                                function: () {},
                                                text: "follow")
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 3, left: 2),
                        child: Text(
                          userData['userName'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 3, left: 2),
                        child: Text(
                          userData['bio'],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  Widget buildStatColumn(int num, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          label,
          style: const TextStyle(
              fontSize: 17, fontWeight: FontWeight.w400, color: Colors.grey),
        )
      ],
    );
  }
}
