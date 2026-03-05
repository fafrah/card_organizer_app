import 'package:flutter/material.dart';

class FoldersScreen extends StatelessWidget {
  const FoldersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Card Organizer")),

      body: ListView(
        children: [
          ListTile(
            title: Text("Hearts"),
            leading: Icon(Icons.favorite, color: Colors.red),
          ),

          ListTile(title: Text("Spades"), leading: Icon(Icons.star)),
        ],
      ),
    );
  }
}
