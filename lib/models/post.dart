// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';

class Post {  
  final String description;
  final String userName;
  final String uid;
  final String postId;
  final  datePublish;
  final String postUrl;
  final String profileImage;
  final  likes;

  Post(
      {required this.description,
      required this.userName,
      required this.uid,
      required this.postId,
      required this.datePublish,
      required this.postUrl,
      required this.profileImage,
      required this.likes});

  Map<String, dynamic> tojson() => {
        "description": description,
        "userName": userName,
        "uid": uid,
        "postId": postId,
        "datePublish": datePublish,
        "postUrl": postUrl,
        "profileImage": profileImage,
        "likes": likes
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      description: snapshot['description'],
      userName: snapshot['userName'],
      uid: snapshot['uid'],
      postId: snapshot['postId'],
      datePublish: snapshot['datePublish'],
      postUrl: snapshot['postUrl'],
      profileImage: snapshot['profileImage'],
      likes: snapshot['likes'],
    );
  }
}
