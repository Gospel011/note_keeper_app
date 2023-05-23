import 'package:flutter/material.dart';

class MyElevatedButton extends StatelessWidget {
  String child;
  void Function() onPressed;

  MyElevatedButton({super.key, required this.child, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.grey.shade800)),
        onPressed: onPressed,
        child: Text(
          "$child",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
