import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projects_viewer/screens/project_add_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    void goToAddScreen() {
      Navigator.push(context, MaterialPageRoute(builder: (ctx) { return const ProjectAddScreen();}));
    }


    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: goToAddScreen, child: const Icon(Icons.add)),
      appBar: AppBar(title: const Text("Projects"), actions: [
        IconButton(onPressed: () {FirebaseAuth.instance.signOut();}, icon: const Icon(Icons.logout)),
      ],),
      body: const Center(child: Text("Hello"),
      ));
  }
}