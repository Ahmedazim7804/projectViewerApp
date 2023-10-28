import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projects_viewer/provider/git_url_provider.dart';
import 'package:projects_viewer/provider/tech_stack_provider.dart';
import 'package:projects_viewer/widgets/github_url_widget.dart';
import 'package:projects_viewer/widgets/tech_stack_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

final database = FirebaseFirestore.instance;
FirebaseStorage firebaseStorage = FirebaseStorage.instance;
final userUuid = FirebaseAuth.instance.currentUser!.uid;
const uuidGenerator = Uuid();

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

  void showProgressBar(BuildContext context) {
    showDialog(barrierDismissible: false,context: context, builder: (ctx) {return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      child: const SizedBox(height: 100, width: 100,child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Text("Please Wait....")
        ],
      ))
    );});
  }


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

  void addProject(BuildContext ctx) async {
    try {

    final isDataValid = formKey.currentState!.validate();
    formKey.currentState!.save();

    if (!isDataValid) {
      return;
    }

    if (imagePath == null) {
      return;
    }

    showProgressBar(ctx);    

    final projectId = uuidGenerator.v1();

    final primaryCollection = database.collection('data').doc(userUuid);
    final secondaryCollection = primaryCollection.collection('Projects').doc(projectId);

    final storageRef = firebaseStorage.ref().child('project_images').child('${userUuid}_$name.jpg');
    await storageRef.putFile(File(imagePath!));
    final downloadUrl = await storageRef.getDownloadURL();

    await secondaryCollection.set({
        'name': name,
        'description': description,
        'techStack' : ref.read(techStackProvider),
        'gitRepoUrls' : ref.read(gitUrlProvider),
        'imageUrl' : downloadUrl,
        'projectId': projectId
    });

    Navigator.pop(context);
    Navigator.pop(context);

    }
    catch (e) {
      print(e);
    } 
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
    // FirebaseFirestore.instance.collection('data').get().then((value){
    //   for (var element in value.docs) { 
    //         FirebaseFirestore.instance.collection('data').doc(element.id).collection("projects").get().then((v) => print(v.docs.length));
    //   }
      
    // });
    return Scaffold(
      appBar: AppBar(title: const Text("Add Project"),),
      floatingActionButton: FloatingActionButton(onPressed: () {addProject(context);}, child: const Icon(Icons.add)),
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