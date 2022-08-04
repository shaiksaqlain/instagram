// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:insta_clone/utils/colors.dart';

class ScearchScreen extends StatefulWidget {
  const ScearchScreen({Key? key}) : super(key: key);

  @override
  State<ScearchScreen> createState() => _ScearchScreenState();
}

class _ScearchScreenState extends State<ScearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUser = false;
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: searchController,
          onFieldSubmitted: (value) {
            isShowUser = true;
            setState(() {});
          },
          decoration: const InputDecoration(
            label: Text("Sreach"),
          ),
        ),
      ),
      body: !isShowUser
          ? FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').get(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return StaggeredGridView.countBuilder(
                  crossAxisCount: 3,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return Image.network(snapshot.data!.docs[index]['postUrl']);
                  },
                  staggeredTileBuilder: (index) {
                    return StaggeredTile.count(
                      (index % 7 == 0) ? 2 : 1,
                      (index % 7 == 0) ? 2 : 1,
                    );
                  
                  },
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,

                );
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where('userName', isGreaterThan: searchController.text)
                  .get(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          snapshot.data!.docs[index]['picUrl'],
                        ),
                      ),
                      title: Text(snapshot.data!.docs[index]['userName']),
                    );
                  },
                );
              },
            ),
    );
  }
}
