import 'package:flutter/material.dart';
import '/pages/notes_page.dart';
import 'package:note_keeper_app/pages/widget_kitchen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoteKeeper',
      home: NotesPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
