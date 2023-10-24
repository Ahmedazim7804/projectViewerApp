import 'package:flutter/material.dart';

class TechStackWidget extends StatefulWidget {
  const TechStackWidget({super.key});

  @override
  State<TechStackWidget> createState() => _TechStackWidgetState();
}

class _TechStackWidgetState extends State<TechStackWidget> {
  List<String> techStacks = ['flutter', 'dart', 'python'];
  final textEditController = TextEditingController();

  void addTechStack(String? value) {
    if (value != null && value.trim().isNotEmpty) {
    setState(() {
      techStacks.add(value);
      textEditController.clear();
    });
    }
  }

  void removeTechStack(int index) {
    setState(() {
    techStacks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<int> wdwdw = [1];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              children: [
                const Text("Tech Stacks", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                GridView.builder(itemCount: techStacks.length, shrinkWrap: true ,gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 3/1) ,itemBuilder: (ctx, index) {return ListTile(leading: IconButton(icon: const Icon(Icons.cancel), onPressed: () {removeTechStack(index);},), title: Text(techStacks[index]));}),
                Padding(padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),child: ListTile(trailing: IconButton(icon: const Icon(Icons.add_sharp), onPressed: () {addTechStack(textEditController.text);},) , title: TextField(controller: textEditController, onSubmitted: addTechStack, decoration: const InputDecoration(hintText: "i.e, Flutter"),))),
              ],
            ),
          )
    
      ),
    );
  }
}