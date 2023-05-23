import 'package:flutter/material.dart';
import '/pages/detail_page.dart';
import '../sql_helper/note_model.dart';
import '../sql_helper/helper.dart';

class NotesPage extends StatefulWidget {
  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  int count = 0;
  List<Map<String, dynamic>> noteList = [];

  void updateNoteList() {
    Future<List<Note>> notelistFuture = SQLHelper.getNotesList();
    notelistFuture.then((value) {
      setState(() {
        List<Map<String, dynamic>> localNoteList = [];
        if (noteList.isEmpty) {
          debugPrint('if block');
          for (int i = 0; i < value.length; i++) {
            noteList.add(value[i].toMap());
          }
        } else {
          debugPrint('else block');
          for (int i = 0; i < value.length; i++) {
            localNoteList.add(value[i].toMap());
          }
          noteList = localNoteList;
          print(noteList);
        }

        count = noteList.length;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    updateNoteList();
    debugPrint('updated note list to $noteList');
  }

  void navigateToDetailPage(
      {String? id,
      required String appBarTitle,
      required String priority,
      String? noteTitle,
      String? noteDescription}) async {
    bool? refresh = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => DetailsPage(
                priority: priority,
                id: id,
                appBarTitle: appBarTitle,
                noteTitle: noteTitle ?? '',
                noteDescription: noteDescription ?? ''))));

    debugPrint('refresh = $refresh');

    refresh == true ? updateNoteList() : () {};
  }

  Future<bool> confirmDelete(BuildContext context) async {
    bool response = false;
    AlertDialog alertDialog = AlertDialog(
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.blueGrey[900])),
            child: Text('Yes'),
            onPressed: () {
              response = true;
              Navigator.pop(context);
            },
          ),
        )
      ],
      title: Text('Are sure you want to delete this note'),
    );
    await showDialog<bool>(context: context, builder: (context) => alertDialog);
    debugPrint('response is $response');
    return response;
  } // Confirm delete

  // delete note
  void deleteNote(String id) {
    confirmDelete(context).then(
      (value) {
        if (value == true) {
          debugPrint('delete id is $id');
          SQLHelper.deleteItem(id);
          updateNoteList();
        }
      },
    );
  }

  Widget itemBuilder(BuildContext, index) {
    print('item builder index is $index');
    return Card(
      color: Colors.blueGrey,
      margin: EdgeInsets.all(8),
      child: ListTile(
        onTap: () {
          print('note priority is ${noteList[index]['priority']}');

          navigateToDetailPage(
              priority: noteList[index]['priority'],
              id: noteList[index]['id'],
              appBarTitle: 'Edit Note',
              noteTitle: itemBuilderTitleAndSubtitle(index)['title'],
              noteDescription: noteList[index]['description'] ?? '');
        },
        leading: CircleAvatar(
          backgroundColor: Colors.grey[350],
          child: noteList[index]['priority'] == 'High' ? const Icon(Icons.watch_later_outlined) : const Icon(Icons.more_time_outlined),
        ),
        trailing: GestureDetector(
            onTap: () {
              String id = noteList[index]['id'];
              deleteNote(id);
            },
            child: Icon(Icons.delete)),
        title: Text(itemBuilderTitleAndSubtitle(index)['title'].toString()),
        subtitle:
            Text(itemBuilderTitleAndSubtitle(index)['subtitle'].toString()),
      ),
    );
  }

  // to return the title and subtitle of all notes in the notes list if the
  //index is in the notes lis or a default one if the index is not in the notes
  //list
  Map<String, String> itemBuilderTitleAndSubtitle(index) {
    if (index < noteList.length) {
      return {
        'title': noteList[index]['title'],
        'subtitle': noteList[index]['date']
      };
    } else {
      return {
        'title': 'My Example Note',
        'subtitle': 'Created at ${DateTime.now().toString().substring(0, 10)}'
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Stateful notes page built with count = $count');
    // updateNoteList();

    return Scaffold(
      appBar: AppBar(
        title: Text('My Notes'),
        backgroundColor: Colors.grey.shade700,
      ),
      body: SafeArea(
          child: ListView.builder(
        itemBuilder: itemBuilder,
        itemCount: count,
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            navigateToDetailPage(
                priority: 'High', appBarTitle: 'Add new note', noteTitle: '');
            // count++;
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey[900],
        tooltip: 'Add Note',
      ),
    );
  }
}
