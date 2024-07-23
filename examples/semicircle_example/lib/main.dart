import 'package:flutter/material.dart';
import 'package:scrollbar_ultima/scrollbar_ultima.dart';

void main() {
  runApp(const SemicircleExampleApp());
}

class SemicircleExampleApp extends StatelessWidget {
  const SemicircleExampleApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 0, 98)),
          useMaterial3: true,
        ),
        home: Scaffold(
          appBar: AppBar(title: const Center(child: Text("Semicircle Example"))),
          body: SafeArea(
            child: ScrollbarUltima.semicircle(
              labelContentBuilder: (offset, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                  child: Text(
                    index.toString(),
                    style: const TextStyle(color: Colors.grey),
                  )),
              precalculateItemByOffset: true,
              prototypeItem: _buildItem(context, 0),
              child: ListView.builder(itemCount: 100, itemBuilder: _buildItem),
            ),
          ),
        ));
  }

  Widget _buildItem(BuildContext context, int index) {
    return ListTile(
      title: Text("Title of $index item"),
      subtitle: Text("Subtitle of $index item"),
      trailing: const Text("^_^"),
    );
  }
}
