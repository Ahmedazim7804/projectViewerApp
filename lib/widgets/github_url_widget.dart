import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projects_viewer/provider/git_url_provider.dart';

class GithubUrlWidget extends ConsumerStatefulWidget {
  const GithubUrlWidget({super.key});

  @override
  ConsumerState<GithubUrlWidget> createState() => _GithubUrlWidgetState();
}

class _GithubUrlWidgetState extends ConsumerState<GithubUrlWidget> {
  final gitTextEditController = TextEditingController();

  bool validateGitUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return false;
    }
    if (!value.contains("https://github.com/") && !value.contains("https://www.github.com/")) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter valid git repo url"),
        ));
      return false;
    }

    return true;
  }

  void addGitRepo(List<String> gitUrls, String? value) {
    if (validateGitUrl(value)) {
    ref.watch(gitUrlProvider.notifier).state = [...gitUrls, value!];
    gitTextEditController.clear();
    }
  }

  void removeGitRepo(List<String> gitUrls, int index) {
    ref.watch(gitUrlProvider.notifier).state = (gitUrls..removeAt(index)).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<String> gitUrls = ref.watch(gitUrlProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              children: [
                const Text("Github Urls", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ListView.builder(itemCount: gitUrls.length ,shrinkWrap: true ,itemBuilder: (ctx, index) {return ListTile(leading: IconButton(icon: const Icon(Icons.cancel) ,onPressed: () {removeGitRepo(gitUrls, index);},), title: Text(gitUrls[index]));}),
                ListTile(title: TextField(controller: gitTextEditController ,decoration: const InputDecoration(hintText: "https://github.com/Ahmedazim7804/thisApp")), trailing: IconButton(onPressed: () {addGitRepo(gitUrls, gitTextEditController.text);}, icon: const Icon(Icons.add)),),
              ],
            ),
          )
      ),
    );
  }
}