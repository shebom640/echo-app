import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echo_app/components/text_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // user
  final currentUser = FirebaseAuth.instance.currentUser!;

  // all users
  final usersCollection = FirebaseFirestore.instance.collection('Users');

  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.grey[900],
              title: Text(
                "Edit " + field,
                style: TextStyle(color: Colors.white),
              ),
              content: TextField(
                autofocus: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Enter new $field",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onChanged: (value) {
                  newValue = value;
                },
              ),
              actions: [
                // cancel
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white),
                    )),

                // save
                TextButton(
                    onPressed: () => Navigator.of(context).pop(newValue),
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            ));
    // update in firestore
    if (newValue.trim().length > 0) {
      await usersCollection.doc(currentUser.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "P R O F I L E",
            style: TextStyle(color: Colors.white, letterSpacing: 2),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.grey[900],
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(currentUser.email)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final userData = snapshot.data!.data() as Map<String, dynamic>;
                return ListView(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    const Icon(
                      Icons.person,
                      size: 72,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text("Logged in as:",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[700],
                        )),
                    Text(
                      currentUser.email!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Text(
                        "My Details",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    MyTextBox(
                      text: userData['username'],
                      sectionName: 'username',
                      onPressed: () => editField('username'),
                    ),
                    MyTextBox(
                      text: userData['bio'],
                      sectionName: 'bio',
                      onPressed: () => editField('bio'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              return CircularProgressIndicator();
            }));
  }
}
