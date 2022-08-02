import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/providers.dart/user_provider.dart';
import 'package:insta_clone/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:insta_clone/models/user_model.dart' as model;

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  String username = "";
  @override
  void initState() {
    getUserDetails();
    super.initState();
  }

  getUserDetails() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    username = (snap.data() as Map<String, dynamic>)['userName'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user.picUrl),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Username: ${user.userName}",
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            "Emai: ${user.email}",
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            "uid: ${user.uid}",
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            "followers: ${user.followers}",
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            "following: ${user.following}",
            style: const TextStyle(color: Colors.white),
          ),
          TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => const LoginScreen()));
              },
              child: const Text("Signout"))
        ],
      ),
    ));
  }
}
