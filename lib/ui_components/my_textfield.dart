import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final int? maxLines;
  final void Function(String)? onChanged;

  const MyTextField(
      {this.maxLines,
      this.onChanged,
      super.key,
      required this.hintText,
      required this.controller});
  @override
  Widget build(BuildContext context) {
    
    return TextField(
      onChanged: controller.text == '' ? onChanged : null,
      style: (hintText == 'Title')
          ? const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
          : null,
      maxLines: maxLines,
      controller: controller,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 18),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.white, width: 2.0)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade400, width: 2.0))),
    );
  }
}
