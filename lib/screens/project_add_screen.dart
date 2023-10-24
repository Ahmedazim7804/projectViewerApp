import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projects_viewer/widgets/github_url_widget.dart';
import 'package:projects_viewer/widgets/tech_stack_widget.dart';
import 'package:transparent_image/transparent_image.dart';


class ProjectAddScreen extends StatefulWidget {
  const ProjectAddScreen({super.key});

  @override
  State<ProjectAddScreen> createState() => _ProjectAddScreenState();
}

class _ProjectAddScreenState extends State<ProjectAddScreen> {
  String? _imagePath;

  void addProject() {
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(title: const Text("Add Project"),),
      floatingActionButton: FloatingActionButton(onPressed: addProject, child: const Icon(Icons.add)),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              children: [
                Stack(alignment: Alignment.bottomRight, children: [Image.asset('assets/image.png', width: 200), IconButton(onPressed: () {}, icon: const Icon(Icons.add ), style: IconButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.onPrimary),)]),
                Card(
                  margin: const EdgeInsets.all(20),
                  elevation: 8,
                  shadowColor: Theme.of(context).colorScheme.onSecondary,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ListTile(leading: const Icon(Icons.architecture) ,title: TextFormField(decoration: const InputDecoration(labelText: "Name"))),
                        ListTile(leading: const Icon(Icons.description) ,title: TextFormField(decoration: const InputDecoration(labelText: "Description"), keyboardType: TextInputType.multiline, minLines: 1, maxLines: 5, maxLength: 250,)),
                      ],
                    ),
                  )
                ),
                const TechStackWidget(),
                const GithubUrlWidget()
                ]
                ),
            ),
        )
        ),
      );
  }
}