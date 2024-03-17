import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final int? maxLength;

  const CustomTextField(
      {super.key,
      required this.controller,
      required this.label,
      this.validator, this.maxLength});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: maxLength != null ? 5 : 10,),
      child: TextFormField(
        readOnly: label == "Latitude *" || label == "Longitude *",//label == "Latitude *" || label == "Longitude *" ? true : false,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          labelText: label,
        ),
        controller: controller,
        validator: validator,
        maxLength: maxLength, 
      ),
    );
  }
}
