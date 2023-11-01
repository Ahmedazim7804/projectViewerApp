import 'package:flutter/material.dart';

class ProjectItemBackground extends StatelessWidget {
  const ProjectItemBackground({super.key, required this.dismissDirection});
  final String dismissDirection;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red,
      child: Center(
        child: ListTile(
          leading: dismissDirection == 'right' ? const Icon(Icons.delete, color: Colors.white, size: 80,) : null,
          trailing: dismissDirection == 'left' ? const Icon(Icons.delete, color: Colors.white, size: 80,) : null
          )
        )
    );
  }
}