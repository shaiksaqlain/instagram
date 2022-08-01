// ignore_for_file: unnecessary_null_comparison

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta_clone/auth/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

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
        //Add user to datebase
        firebaseFirestore.collection("users").doc(credential.user!.uid).set({
          'userName': userName,
          'password': password,
          'uid': credential.user!.uid,
          'bio': bio,
          'email': email,
          "followers": [],
          'following': [],
          'photoUrl': picUrl
        });
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
