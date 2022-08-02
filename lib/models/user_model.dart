import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String userName;
  final String password;
  final String uid;
  final String bio;
  final String email;
  final List followers;
  final List following;
  final String picUrl;

  User(
      {required this.userName,
      required this.password,
      required this.uid,
      required this.bio,
      required this.email,
      required this.followers,
      required this.following,
      required this.picUrl});

  Map<String, dynamic> tojson() => {
        "userName": userName,
        "password": password,
        "uid": uid,
        "bio": bio,
        "email": email,
        "followers": followers,
        "following": following,
        "picUrl": picUrl
      };
  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      userName: snapshot['userName'],
      password: snapshot['password'],
      uid: snapshot['uid'],
      bio: snapshot['bio'],
      email: snapshot['email'],
      followers: snapshot['followers'],
      following: snapshot['following'],
      picUrl: snapshot['picUrl'],
    );
  }
}
