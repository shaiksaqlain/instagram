// ignore_for_file: empty_catches, avoid_print

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:insta_clone/models/post.dart';
import 'package:insta_clone/resourse/storage_methods.dart';
import 'package:insta_clone/utils/utils.dart';
import 'package:uuid/uuid.dart';

class FireStoremethods {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  //upload post
  Future<String> upload(
    String childName,
    Uint8List file,
    bool ispost,
    String description,
    String userName,
    String uid,
    String profileImage,
  ) async {
    String res = "some error occured";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage(childName, file, ispost);
      String postId = const Uuid().v1();
      Post post = Post(
          description: description,
          userName: userName,
          uid: uid,
          postId: postId,
          datePublish: DateTime.now(),
          postUrl: photoUrl,
          profileImage: profileImage,
          likes: []);
      _firebaseFirestore.collection("posts").doc(postId).set(post.tojson());
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost(
      String postId, String uid, List likes, bool ispostBigLike) async {
    try {
      if (likes.contains(uid)) {
        await _firebaseFirestore.collection('posts').doc(postId).update(
          {
            "likes": FieldValue.arrayRemove([uid]),
          },
        );
      } else {
        await _firebaseFirestore.collection('posts').doc(postId).update(
          {
            "likes": FieldValue.arrayUnion([uid])
          },
        );
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  Future<void> postComment(String postId, String text, String uid, String name,
      String profilePic, BuildContext context) async {
    try {
      if (text.isNotEmpty) {
        String cmtID = const Uuid().v1();
        await _firebaseFirestore
            .collection("posts")
            .doc(postId)
            .collection('comments')
            .doc(cmtID)
            .set(
          {
            'profilePic': profilePic,
            'name': name,
            'uid': uid,
            'text': text,
            'commentId': cmtID,
            'datePublish': DateTime.now()
          },
        );
      } else {
        showSnackbar("Text is empty !", context);
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      _firebaseFirestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }
}
