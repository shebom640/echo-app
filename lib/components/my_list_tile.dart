import 'package:flutter/material.dart';
class MyListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function()? onTap;

  const MyListTile({super.key, required this.icon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 20.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.white,),
        title: Text(text, style: TextStyle(color: Colors.white),),
        onTap: onTap,
      ),
    );
  }
}
