class Note {
  String? _id;
  String? get id => _id;

  late String title;
  String? description;
  late String date;
  late String priority;

 // Constructor to manually specify the instance variables of the note
  Note(
      {required this.title,
      this.description,
      required this.date,
      required this.priority});

 // Constructor to manually specify the instance variable of the not with id
  Note.withId(this._id,
      {required this.title,
      this.description,
      required this.date,
      required this.priority});

  // Method to get a map object representation of the note object
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': _id,
      'title': title,
      'description': description,
      'date': date,
      'priority': priority
    };
    return map;
  }

  // Constructor to create a note object from a map
  Note.fromMap(Map<String, dynamic> mapObject) {
    _id = mapObject['id'];
    title = mapObject['title'];
    description = mapObject['description'];
    date = mapObject['date'];
    priority = mapObject['priority'];
  }
}
