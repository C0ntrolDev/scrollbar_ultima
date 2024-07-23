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
            colorScheme:
                ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 0, 98), brightness: Brightness.dark),
            useMaterial3: true,
            brightness: Brightness.dark),
        home: const CustomizedExampleMainScreen());
  }
}

class CustomizedExampleMainScreen extends StatelessWidget {
  const CustomizedExampleMainScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollbarUltima.semicircle(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        arrowsColor: Theme.of(context).colorScheme.onSurface,
        labelBehaviour: LabelBehaviour.showOnlyWhileAndAfterDragging,
        labelContentBuilder: (offset, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: Text(index.toString()),
        ),
        isFixedScroll: true,
        precalculateItemByOffset: true,
        alwaysShowThumb: false,
        prototypeItem: _buildItem(context, 0),
        hideThumbWhenOutOfOffset: true,
        minScrollOffset: 200 - 70,
        itemPrecalculationOffset: 200 - 70,
        scrollbarPadding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.vertical + 70),
        child: CustomScrollView(
          slivers: [
            const SliverAppBar(
                forceElevated: true,
                pinned: true,
                expandedHeight: 200,
                collapsedHeight: 70,
                flexibleSpace: FlexibleSpaceBar(title: Text("Customized Example"))),
            SliverList.builder(itemCount: 100, itemBuilder: _buildItem),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return ListTile(
      title: Text("Title of $index item"),
      subtitle: Text("Subtitle of $index item"),
      trailing: const Text("^_^"),
    );
  }
}