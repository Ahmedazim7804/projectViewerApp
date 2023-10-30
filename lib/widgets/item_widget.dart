import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'dart:math';

class ProjectItem extends StatelessWidget {
  const ProjectItem({super.key, required this.name, required this.description, required this.techStacks, required this.gitRepoUrls, required this.imageUrl});
  final String? name;
  final String? description;
  final List<dynamic> techStacks;
  final List<dynamic>? gitRepoUrls;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: SingleChildScrollView(
        child: Column(
          children: [
            FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: imageUrl!, fit: BoxFit.cover),
            Container(margin: const EdgeInsets.all(8),child: Text(name!, style: TextStyle(color: Theme.of(context).colorScheme.onBackground, fontSize: 28, fontWeight: FontWeight.bold))),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16),child: GridView.count(crossAxisSpacing: 10,childAspectRatio: 3/1,shrinkWrap: true,crossAxisCount: 3, children: techStacks.map((e) => ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.primaries[Random().nextInt(Colors.primaries.length)].withAlpha(180)),child: Text(e, style: const TextStyle(color: Colors.black),),)).toList())),
            ListTile(leading: const Icon(Icons.description),title: Text(description!)),
            ListTile(leading: const Icon(Icons.web_rounded),title: Text("Github Links", style: Theme.of(context).textTheme.titleMedium),subtitle: ListView.builder(shrinkWrap: true,itemBuilder: (ctx, index) => Text('${index+1}. ${gitRepoUrls![index]}', style: Theme.of(context).textTheme.titleSmall,),itemCount: gitRepoUrls!.length,))
            ],
          ),
        ),
      );
  }
}