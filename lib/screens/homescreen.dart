import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projects_viewer/screens/project_add_screen.dart';
import 'package:projects_viewer/widgets/item_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  Future<List<Map<String, dynamic>?>> get projectsFromFirebase async {
      List<String> userProjectIds = [];
      final List<Map<String, dynamic>?> userProjects = [];
      await FirebaseFirestore.instance.collection('data').doc(userUuid).collection('Projects').get().then((value) {
        for (final doc in value.docs) {
          userProjectIds.add(doc.id);
        }
        });

      for (final docId in userProjectIds) {
        await FirebaseFirestore.instance.collection('data').doc(userUuid).collection('Projects').doc(docId).get().then((value) {
          userProjects.add(value.data());
        });
      }

      return userProjects;
    }

  @override
  Widget build(BuildContext context) {

    final userProjects = [
      {
        'name': 'Project1',
        'description': "This is my project",
        'techStack' : ['flutter', 'dart', 'python'],
        'gitRepoUrls' : ['https://github.com/ahmedazim7804/sudokuApp'],
        'imageUrl' : 'https://firebasestorage.googleapis.com/v0/b/nsutaiproject.appspot.com/o/project_images%2Frq059YhvhgaA1EyueL4ujSVlXtV2_hellodhdnd.jpg?alt=media&token=9e8ddfe2-54be-4b56-81e4-d653bee3358d',
        'projectId': ' f9355210-f14f-1d67-81b3-7d9137f1c00e'
      },
      {
        'name': 'Project2',
        'description': "This is my 2nd project",
        'techStack' : ['flutter', 'dart', 'python'],
        'gitRepoUrls' : ['https://github.com/ahmedazim7804/sudokuApp'],
        'imageUrl' : 'https://firebasestorage.googleapis.com/v0/b/nsutaiproject.appspot.com/o/project_images%2Frq059YhvhgaA1EyueL4ujSVlXtV2_hellodhdnd.jpg?alt=media&token=9e8ddfe2-54be-4b56-81e4-d653bee3358d',
        'projectId': ' f9355210-f14f-1d67-81b3-7d9137f1c22w'
      },
    ];

    void goToAddScreen() {
      Navigator.push(context, MaterialPageRoute(builder: (ctx) { return const ProjectAddScreen();}));
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: goToAddScreen, child: const Icon(Icons.add)),
      appBar: AppBar(title: const Text("Projects"), actions: [
        IconButton(onPressed: logout, icon: const Icon(Icons.logout)),
      ],),
      body: GridView.builder(
        itemCount: userProjects.length, 
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
        childAspectRatio: 2/3),
        itemBuilder: (ctx, index) => ProjectItem(
          name: userProjects[index]['name'] as String?,
          description: userProjects[index]['description'] as String?,
          techStacks: userProjects[index]['techStacks'] as List<String>?,
          gitRepoUrls: userProjects[index]['gitRepoUrls'] as List<String>?,
          imageUrl: userProjects[index]['imageUrl'] as String?,
        ))
      );
  }
}