// ignore_for_file: unnecessary_null_comparison

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta_clone/auth/storage_methods.dart';
import 'package:insta_clone/models/user_model.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await firebaseFirestore.collection("users").doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }

  //Signup method\

  Future<String> signUpMethod({
    required String email,
    required String password,
    required String userName,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error is occured";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          userName.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        // register the User

        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        //call the storage method

        String picUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        model.User user = model.User(
            userName: userName,
            bio: bio,
            email: email,
            followers: [],
            following: [],
            password: password,
            picUrl: picUrl,
            uid: credential.user!.uid);

        //Add user to datebase
        firebaseFirestore.collection("users").doc(credential.user!.uid).set(
              user.tojson(),
            );
        res = "success";
      } else {
        res = "All fields required";
      }
    } catch (e) {
      res = e.toString();
      return res;
    }
    return res;
  }

  Future<String> loginUser(
      {required String userName, required String password}) async {
    String res = "some error Occured";
    try {
      if (userName.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: userName, password: password);
        res = "Success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
