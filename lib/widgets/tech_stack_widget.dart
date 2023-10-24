import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projects_viewer/provider/tech_stack_provider.dart';

class TechStackWidget extends ConsumerStatefulWidget {
  const TechStackWidget({super.key});

  @override
  ConsumerState<TechStackWidget> createState() => _TechStackWidgetState();
}

class _TechStackWidgetState extends ConsumerState<TechStackWidget> {
  final textEditController = TextEditingController();

  void addTechStack(List<String> techStacks, String? value) {
    if (value != null && value.trim().isNotEmpty) {
    ref.read(techStackProvider.notifier).state = [...techStacks, value];
    textEditController.clear();
    }
  }

  void removeTechStack(List<String> techStacks, int index) {
    ref.read(techStackProvider.notifier).state = (techStacks..removeAt(index)).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<String> techStacks = ref.watch(techStackProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              children: [
                const Text("Tech Stacks", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                GridView.builder(itemCount: techStacks.length, shrinkWrap: true ,gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 3/1) ,itemBuilder: (ctx, index) {return ListTile(leading: IconButton(icon: const Icon(Icons.cancel), onPressed: () {removeTechStack(techStacks,index);},), title: Text(techStacks[index]));}),
                Padding(padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),child: ListTile(trailing: IconButton(icon: const Icon(Icons.add_sharp), onPressed: () {addTechStack(techStacks, textEditController.text);},) , title: TextField(controller: textEditController, onSubmitted: (value) {addTechStack(techStacks, value);}, decoration: const InputDecoration(hintText: "i.e, Flutter"),))),
              ],
            ),
          )
      ),
    );
  }
}