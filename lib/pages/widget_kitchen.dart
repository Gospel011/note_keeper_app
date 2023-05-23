import 'package:flutter/material.dart';

class WidgetKitchen extends StatefulWidget {
  @override
  State<WidgetKitchen> createState() => _WidgetKitchenState();
}

class _WidgetKitchenState extends State<WidgetKitchen> {
  String btnTxt = 'Show Dialog';

  Future<bool> confirmDelete(BuildContext context) async {
    bool response = false;
    AlertDialog alertDialog = AlertDialog(
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: ElevatedButton(
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: ElevatedButton(
                child: Text(btnTxt),
                onPressed: () {
                  bool delete = false;
                  confirmDelete(context).then((value) {
                    delete = value;
                    debugPrint('delete is $delete');
                    if (delete == true) {
                      setState(() {
                        btnTxt = '';
                      });
                    }
                  });
                })));
  }
}
