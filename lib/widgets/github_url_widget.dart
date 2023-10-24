import 'package:flutter/material.dart';

class GithubUrlWidget extends StatefulWidget {
  const GithubUrlWidget({super.key});

  @override
  State<GithubUrlWidget> createState() => _TechStackWidgetState();
}

class _TechStackWidgetState extends State<GithubUrlWidget> {
  List<String> gitUrls = ['sudokuApp'];
  final gitTextEditController = TextEditingController();

  bool validateGitUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return false;
    }
    if (value.substring(0, 19) != "https://github.com/" && value.substring(0, 23) != "https://www.github.com/") {
      return false;
    }

    return true;
  }

  void addGitRepo(String? value) {
    if (validateGitUrl(value)) {
    setState(() {
      gitUrls.add(value!);
      gitTextEditController.clear();
    });
    }
  }

  void removeGitRepo(int index) {
    setState(() {
      gitUrls.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              children: [
                const Text("Github Urls", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ListView.builder(itemCount: gitUrls.length ,shrinkWrap: true ,itemBuilder: (ctx, index) {return ListTile(leading: IconButton(icon: const Icon(Icons.cancel) ,onPressed: () {removeGitRepo(index);},), title: Text(gitUrls[index]));}),
                ListTile(title: TextField(controller: gitTextEditController ,decoration: const InputDecoration(hintText: "https://github.com/Ahmedazim7804/thisApp")), trailing: IconButton(onPressed: () {addGitRepo(gitTextEditController.text);}, icon: const Icon(Icons.add)),),
              ],
            ),
          )
      ),
    );
  }
}