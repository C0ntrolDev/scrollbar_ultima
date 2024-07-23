import 'package:flutter/material.dart';
import 'package:scrollbar_ultima/scrollbar_ultima.dart';

void main() {
  runApp(const DeffaultExampleApp());
}

class DeffaultExampleApp extends StatelessWidget {
  const DeffaultExampleApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 0, 98)),
          useMaterial3: true,
        ),
        home: Scaffold(
          appBar: AppBar(title: const Center(child: Text("Deffault Example"))),
          body: SafeArea(
            child: ScrollbarUltima(
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
