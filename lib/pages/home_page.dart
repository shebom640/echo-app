import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echo_app/components/drawer.dart';
import 'package:echo_app/components/echo_posts.dart';
import 'package:echo_app/components/text_field.dart';
import 'package:echo_app/helper/helper_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  void postMessage() {
    // only post if textfield is not empty
    if (textController.text.isNotEmpty) {
      // store in firebase
      FirebaseFirestore.instance.collection("User Posts").add({
        'UserEmail': currentUser.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
      });
    }

    // clear the text field
    setState(() {
      textController.clear();
    });
  }

  void goToProfilePage() {
    // Pop menu drawer
    Navigator.pop(context);

    // go to profile page
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ProfilePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
        title: Text(
          "E C H O",
          style: TextStyle(
              letterSpacing: 5,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("User Posts")
                .orderBy("TimeStamp", descending: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      // get the message
                      final post = snapshot.data!.docs[index];
                      return EchoPosts(
                        message: post["Message"],
                        user: post['UserEmail'],
                        postId: post.id,
                        likes: List<String>.from(post['Likes'] ?? []),
                        time: formatData(post['TimeStamp']),
                      );
                    });
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Error: ${snapshot.error}"),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          )),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                Expanded(
                    child: MyTextField(
                        controller: textController,
                        hintText: 'Write something...',
                        obsecureText: false)),
                IconButton(
                    onPressed: postMessage, icon: Icon(Icons.post_add_outlined))
              ],
            ),
          )
        ],
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSignUp: signOut,
      ),
    );
  }
}
