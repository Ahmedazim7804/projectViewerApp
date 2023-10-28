import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class ProjectItem extends StatelessWidget {
  const ProjectItem({super.key, required this.name, required this.description, required this.techStacks, required this.gitRepoUrls, required this.imageUrl});
  final String? name;
  final String? description;
  final List<String>? techStacks;
  final List<String>? gitRepoUrls;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Card(child: Stack(
      children: [
        FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: imageUrl!, fit: BoxFit.scaleDown,)
      ],
    ));
  }
}