// ignore_for_file: unused_field, unused_element, prefer_final_fields, use_build_context_synchronously, prefer_const_constructors

import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta_clone/resourse/firestore_methods.dart';
import 'package:insta_clone/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/models/user_model.dart' as model;
import 'package:insta_clone/providers.dart/user_provider.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/utils.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  Uint8List? _file;
  TextEditingController _discriptionController = TextEditingController();
  bool _isLoading = false;

  //upload Post data to firebase
  void post(String uid, String username, String profileImage) async {
    _isLoading = true;
    setState(() {});
    try {
      String res = await FireStoremethods().upload("posts", _file!, true,
          _discriptionController.text, username, uid, profileImage);
      if (res == "success") {
        _isLoading = false;
        setState(() {});
        _file = null;
        showSnackbar(res, context);
      }
    } catch (e) {
      showSnackbar(e.toString(), context);
    }
    _isLoading = false;
    setState(() {});
  }

  //select image to upload into firebase
  _selectImage(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(title: const Text("Create a Post"), children: [
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text("Take photo"),
            onPressed: () async {
              Navigator.of(context).pop();
              Uint8List file = await picImage(ImageSource.camera, context);
              _file = file;
              setState(() {});
            },
          ),
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text("Choose from gallary"),
            onPressed: () async {
              Navigator.of(context).pop();
              Uint8List file = await picImage(ImageSource.gallery, context);
              _file = file;
              setState(() {});
            },
          ),
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? Center(
            child: IconButton(
              onPressed: () => _selectImage(context),
              icon: const Icon(Icons.upload),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                onPressed: () {
                  _file = null;
                  setState(() {});
                },
                icon: const Icon(Icons.arrow_back),
              ),
              title: const Text("Post to"),
              actions: [
                TextButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext build) => LoginScreen()));
                    },
                    child: const Text("exit")),
                TextButton(
                  onPressed: () => post(user.uid, user.userName, user.picUrl),
                  child: const Text(
                    "Post",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                _isLoading ? LinearProgressIndicator() : Container(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.picUrl),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextField(
                        controller: _discriptionController,
                        decoration: const InputDecoration(
                            hintText: "Write your caption...",
                            border: InputBorder.none),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 40,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: MemoryImage(_file!),
                                fit: BoxFit.fill,
                                alignment: FractionalOffset.topCenter),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
  }
}
