import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:insta_clone/screens/feed_screen.dart';
import 'package:insta_clone/screens/add_post.dart';
import 'package:insta_clone/screens/profile_screen.dart';
import 'package:insta_clone/screens/search_screen.dart';

const webScreenSize = 600;
List<Widget> homeScreenItems = [
  const FeedScreen(),
  const ScearchScreen(),
  const AddScreen(),
  const AddScreen(),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];
