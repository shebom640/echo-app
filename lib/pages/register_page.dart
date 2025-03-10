import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/button.dart';
import '../components/text_field.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    // text editing controllers
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    final _confirmPasswordController = TextEditingController();

    void displayMessage(String message) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(message),
          ));
    }

    void signUp() async{
      // show loading circle
      showDialog(context: context, builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ));
      // make sure passwords match
      if (_passwordController.text != _confirmPasswordController.text) {
        Navigator.pop(context);
        displayMessage("Passwords does not match");
        return;
      }

      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);

        FirebaseFirestore.instance.collection("Users").doc(userCredential.user!.email).set(
            {
              'username': _emailController.text.split('@')[0], // initial username
              'bio': 'Empty Bio...' // initial bio
            });

        if(context.mounted) Navigator.pop(context);


      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        displayMessage(e.code);

      }
     }

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // const SizedBox(
                //   height: 50,
                // ),
                // logo
                Icon(
                  Icons.lock,
                  size: 100,
                ),
                const SizedBox(
                  height: 25,
                ),
                // Welcome Text
                Text(
                  "Let's create an account for you!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 25,
                ),

                // textfields

                MyTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    obsecureText: false),

                const SizedBox(
                  height: 10,
                ),

                MyTextField(
                    controller: _passwordController,
                    hintText: 'Password',
                    obsecureText: true),

                const SizedBox(
                  height: 10,
                ),

                MyTextField(
                    controller: _confirmPasswordController,
                    hintText: 'Confirm Password',
                    obsecureText: true),

                const SizedBox(
                  height: 25,
                ),

                MyButton(onTap: signUp, text: 'Sign Up'),

                const SizedBox(
                  height: 10,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? "),
                    const SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Login now",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
