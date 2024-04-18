import 'package:flutter/material.dart';

class DescriptonPoint extends StatelessWidget {
  final String description;
  final int numLines;
  const DescriptonPoint(
      {super.key, required this.description, this.numLines = 2});

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      style: TextStyle(
        fontSize: 18,
        color: Colors.grey[600],
      ),
      maxLines: numLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}
