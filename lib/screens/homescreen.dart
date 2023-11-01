import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projects_viewer/screens/loading_screen.dart';
import 'package:projects_viewer/screens/project_add_screen.dart';
import 'package:projects_viewer/widgets/item_background_widget.dart';
import 'package:projects_viewer/widgets/item_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  void removeProjectFromFirestore(String projectId) {
    FirebaseFirestore.instance.collection('data').doc(userUuid).collection('Projects').doc(projectId).delete();
  }

  Future<bool> confirmProjectDeletion(context) async {
    bool flag = false;
    await showDialog(context: context, builder: (ctx) {return AlertDialog(
      title: const Text("Are You Sure?"),
      actions: [
        TextButton(onPressed: () {flag = true; Navigator.pop(context);} , child: const Text('Confirm')),
        TextButton(onPressed: () {Navigator.pop(context);} , child: const Text('Cancel')),
      ],
    );});
    return flag;
  }

  @override
  Widget build(BuildContext context) {

    void goToAddScreen() {
      Navigator.push(context, MaterialPageRoute(builder: (ctx) { return const ProjectAddScreen();}));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('data').doc(userUuid).collection('Projects').snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const LoadingScreen();
        } else {

        final userProjects = snapshot.data.docs.map((e) => e.data()).toList();

        return Scaffold(
          floatingActionButton: FloatingActionButton(onPressed: goToAddScreen, child: const Icon(Icons.add)),
          appBar: AppBar(title: const Text("Projects"), actions: [
            IconButton(onPressed: logout, icon: const Icon(Icons.logout)),
          ],),
          body: GridView.builder(
            itemCount: userProjects.length, 
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1,
            childAspectRatio: 2/3),
            itemBuilder: (ctx, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Dismissible(
                background: const ProjectItemBackground(dismissDirection: 'right'),
                secondaryBackground: const ProjectItemBackground(dismissDirection: 'left'),
                confirmDismiss: (dir) {return confirmProjectDeletion(context);},
                onDismissed: (direction) {removeProjectFromFirestore(userProjects[index]['projectId']);},
                key: ValueKey(userProjects[index]['projectId']),
                child: ProjectItem(
                  name: userProjects[index]['name'] as String?,
                  description: userProjects[index]['description'] as String?,
                  techStacks: userProjects[index]['techStack'] as List<dynamic>,
                  gitRepoUrls: userProjects[index]['gitRepoUrls'] as List<dynamic>?,
                  imageUrl: userProjects[index]['imageUrl'] as String?,
                ),
              ),
            ))
          );
        }
      }
    );
  }
}