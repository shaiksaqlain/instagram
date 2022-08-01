import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //future method to upload images into firebase storage
  Future<String> uploadImageToStorage(
      String childName, Uint8List file, bool ispost)async {
    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);

    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot= await uploadTask;
   String dwldUrl= await snapshot.ref.getDownloadURL();
   return dwldUrl;
  }
}
