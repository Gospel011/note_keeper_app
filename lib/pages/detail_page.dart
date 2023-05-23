import 'package:flutter/material.dart';
import '../ui_components/my_textfield.dart';
import '../ui_components/my_buttons.dart';
import '../sql_helper/helper.dart';

class DetailsPage extends StatefulWidget {
  String appBarTitle;
  String? noteTitle;
  String? noteDescription;
  String? id;
  String priority;

  DetailsPage(
      {super.key,
      required this.appBarTitle,
      required this.noteTitle,
      required this.noteDescription,
      required this.priority,
      this.id});

  @override
  State<StatefulWidget> createState() {
    return _DetailsPageState();
  }
}

class _DetailsPageState extends State<DetailsPage> {
  List<String> priorities = ['High', 'Low'];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  int _onChangedCount = 0;

  @override
  void initState() {
    super.initState();
    if (widget.appBarTitle == 'Edit Note') {
      titleController.text = widget.noteTitle.toString();
      descriptionController.text = widget.noteDescription.toString();
    }
  }

  List<DropdownMenuItem> items() {
    List<DropdownMenuItem> list = priorities.map((item) {
      return DropdownMenuItem(value: item, child: Text(item));
    }).toList();

    return list;
  }

  void save({String? id}) {
    debugPrint('save button was pressed');
    debugPrint(
        'appBarTitle is ${widget.appBarTitle} and id is $id and noteTitle is ${widget.noteTitle.toString()}\n title contoller = ${titleController.text}');

    if (titleController.text == '') {
      debugPrint('First if save block');
      AlertDialog alertDialog = const AlertDialog(
        title: Text('Note Not Saved'),
        content: Text('Your note title cannot be empty.'),
      );
      showDialog(
        context: context,
        builder: (context) => alertDialog,
      );
    } else if (widget.appBarTitle == 'Add new note' && _onChangedCount == 0) {
      debugPrint('add new note else if block');
      //note title is used to know if this method is called from the
      //floating action button in the notes page
      widget.noteTitle = titleController.text;
      int response = 0;
      SQLHelper.insertItem(
              title: titleController.text,
              description: descriptionController.text,
              priority: widget.priority)
          .then((value) => response = value);

      debugPrint(response < 0
          ? 'Something happened'
          : 'successfully inserted item with title "${titleController.text}", priority = ${widget.priority} and id = ');
      // Navigator.pop(context, true);
    } else if (widget.appBarTitle == 'Edit Note' && id != null) {
      debugPrint('edit note else if block');
      int response = 0;
      SQLHelper.updateItem(id, widget.priority,
              title: titleController.text,
              description: descriptionController.text)
          .then((value) => response = value);

      // Navigator.pop(context, true);

      print('update response is $response');
    } else {
      debugPrint('final save else block');
      int response = 0;
      SQLHelper.updateItem(id!, widget.priority,
              title: titleController.text,
              description: descriptionController.text)
          .then((value) => response = value);

      // Navigator.pop(context, true);

      print('update response is $response');
    }
  }

  // Confirm delete
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

  void onDeletePressed() {
    //TODO implement Delete functionality
    debugPrint('Delete button was pressed');
    confirmDelete(context).then((value) {
      if (value == true) {
        if (widget.id == null) {
          Navigator.pop(context);
          debugPrint('Popped current route since there\'s no id');
        } else {
          SQLHelper.deleteItem(widget.id!).then((value) {});
          debugPrint('deleted an item');
          Navigator.pop(context, true);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (titleController.text == '') {
          Navigator.pop(context);
        }
        save(id: widget.id);
        Navigator.pop(context, true);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              GestureDetector(
                  onTap: () {
                    if (titleController.text == '') {
                      Navigator.pop(context);
                    }
                    save(id: widget.id);
                    Navigator.pop(context, true);
                  },
                  child: Icon(Icons.arrow_back)),
              const SizedBox(width: 25),
              Text(widget.appBarTitle),
            ],
          ),
          backgroundColor: Colors.grey.shade700,
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),

                // Row containing DropdownButton with a convienience sizedbox
                Row(
                  children: [
                    Expanded(
                      child: DropdownButton(
                        dropdownColor: Colors.blueGrey[200],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 18),
                        items: items(),
                        onChanged: (value) {
                          setState(() {
                            widget.priority = value;
                          });
                        },
                        value: widget.priority,
                        isExpanded: true,
                      ),
                    ),
                    Expanded(flex: 2, child: SizedBox())
                  ],
                ),

                const SizedBox(
                  height: 30,
                ),

                // Text field => Title
                MyTextField(
                  controller: titleController,
                  hintText: 'Title',
                  maxLines: 1,
                  onChanged: (value) async {
                    if (_onChangedCount == 0) {
                      save();
                      _onChangedCount++;
                      SQLHelper.getLastInsertedItem().then((note) => widget.id = note.id);
                    }
                  },
                ),

                const SizedBox(
                  height: 30.0,
                ),

                //Text field => Description
                MyTextField(
                    hintText: 'Description', controller: descriptionController),

                const SizedBox(height: 30),

                //Row with two elevated buttons
                Row(
                  children: [
                    // save button
                    Expanded(
                        child: MyElevatedButton(
                            child: 'Save',
                            onPressed: () {
                              save(id: widget.id);
                            })),

                    const SizedBox(width: 10),

                    // Delete button
                    Expanded(
                        child: MyElevatedButton(
                            child: 'Delete', onPressed: onDeletePressed))
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
