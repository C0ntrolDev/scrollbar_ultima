import 'package:flutter/material.dart';

class MaterialStateBuilder extends StatefulWidget {
  final Widget Function(
      BuildContext context,
      Set<WidgetState> materialStates,
      void Function(WidgetState) addMaterialState,
      void Function(WidgetState) removeMaterialState) builder;

  const MaterialStateBuilder({super.key, required this.builder});

  @override
  State<MaterialStateBuilder> createState() => _MaterialStateBuilderState();
}

class _MaterialStateBuilderState extends State<MaterialStateBuilder>
    with MaterialStateMixin {
  @override
  Widget build(BuildContext context) {
    return widget.builder(
        context, materialStates, addMaterialState, removeMaterialState);
  }
}
