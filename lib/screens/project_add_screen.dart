import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projects_viewer/provider/git_url_provider.dart';
import 'package:projects_viewer/provider/tech_stack_provider.dart';
import 'package:projects_viewer/widgets/github_url_widget.dart';
import 'package:projects_viewer/widgets/tech_stack_widget.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final database = FirebaseFirestore.instance;
FirebaseStorage firebaseStorage = FirebaseStorage.instance;

class ProjectAddScreen extends ConsumerStatefulWidget {
  const ProjectAddScreen({super.key});

  @override
  ConsumerState<ProjectAddScreen> createState() => _ProjectAddScreenState();
}

class _ProjectAddScreenState extends ConsumerState<ProjectAddScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? imagePath;
  String? name;
  String? description;

  String? nameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter valid project name";
    }
    return null;
  }

  String? descriptionValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Don't leave description empty";
    }
    return null;
  }

  void addProject() async {
    final isDataValid = formKey.currentState!.validate();
    formKey.currentState!.save();

    if (!isDataValid) {
      return;
    }

    if (imagePath == null) {
      return;
    }

    final uuid = FirebaseAuth.instance.currentUser!.uid;

    final data = database.collection('data').doc('${uuid}_$name');

    final storageRef = firebaseStorage.ref().child('project_images').child('${uuid}_$name.jpg');
    await storageRef.putFile(File(imagePath!));
    final downloadUrl = await storageRef.getDownloadURL();


    await data.set({
        'name': name,
        'description': description,
        'techStack' : ref.read(techStackProvider),
        'gitRepoUrls' : ref.read(gitUrlProvider),
        'imageUrl' : downloadUrl
    });
  }

  void pickImage() async {
    ImagePicker imagePicker = ImagePicker();
    final filePath = await imagePicker.pickImage(source: ImageSource.gallery);

    if (filePath == null) {
      return;
    }

    setState(() {
      imagePath = filePath.path;
    });
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(title: const Text("Add Project"),),
      floatingActionButton: FloatingActionButton(onPressed: addProject, child: const Icon(Icons.add)),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Stack(alignment: Alignment.bottomRight, children: [imagePath == null ? Image.asset('assets/image.png', width: 200) : Image.file(File(imagePath!), width: 200), IconButton(onPressed: pickImage, icon: const Icon(Icons.add ), style: IconButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.onPrimary),)]),
                Card(
                  margin: const EdgeInsets.all(20),
                  elevation: 8,
                  shadowColor: Theme.of(context).colorScheme.onSecondary,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ListTile(leading: const Icon(Icons.architecture) ,title: TextFormField(validator: nameValidator, decoration: const InputDecoration(labelText: "Name"), onSaved: (value) {name = value;})),
                        ListTile(leading: const Icon(Icons.description) ,title: TextFormField(validator: descriptionValidator, decoration: const InputDecoration(labelText: "Description"), keyboardType: TextInputType.multiline, minLines: 1, maxLines: 5, maxLength: 250, onSaved: (value) {description = value;},)),
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