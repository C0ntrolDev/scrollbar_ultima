<h1 id="header" align="center">
ScrollbarUltima
</h1>
<div id="header" align="center">
Powerful Flutter package that allows you to create highly customizable scrollbars!
</div>

## Try It!

### Default

<img src="https://raw.githubusercontent.com/C0ntrolDev/scrollbar_ultima/main/readme_images/default_example.gif" width="400" />

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Center(child: Text("Default Example"))),
    body: SafeArea(
      child: ScrollbarUltima(
        child: ListView.builder(itemCount: 100, itemBuilder: _buildItem),
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
```

### Semicircle with Item index precalculation

<img src="https://raw.githubusercontent.com/C0ntrolDev/scrollbar_ultima/main/readme_images/semicircle_example.gif" width="400" />

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
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
  );
}

Widget _buildItem(BuildContext context, int index) {
  return ListTile(
    title: Text("Title of $index item"),
    subtitle: Text("Subtitle of $index item"),
    trailing: const Text("^_^"),
  );
}
```

### Customized

<img src="https://raw.githubusercontent.com/C0ntrolDev/scrollbar_ultima/main/readme_images/customized_example.gif" width="400" />

```dart
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
```

## Features

- 🎨 **Fully Customizable Label, Thumb, Track** - Modify the appearance of label, thumb, and track.
- 🔄 **Various Label and Track Behaviors** - Implement different behaviors for labels and tracks.
- 📏 **Scrollable Area Specification** - Define the scrollable area for precise control.
- 📌 **Fixed Scroll Mode** - Scrolling is done element by element, which allows for smooth scrolling in large lists.
- 🔍 **Element Index Prediction** - Predict the index of elements for label displaying.
- 🖥️ **Various Screen Positions** - Place scrollbars at different positions on the screen.
- 🧩 **Seamless Integration with CustomScrollView** - Easily work with CustomScrollView for advanced scrolling effects.

## Core Features docs

| Property                          | Default value           | Description                                                                                                                                                                                                                                                                        |
| --------------------------------- | ----------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| thumbBuilder                      | default thumb           | Сustom builder for the Thumb. `animation` indicates how much the Thumb is currently shown/hidden. `widgetStates` represents the current state of the Thumb                                                                                                                         |
| labelBuilder                      | null                    | Сustom builder for the Label. `animation` indicates how much the Label is currently shown/hidden. `widgetStates` represents the current state of the Thumb. `offset` is the offset of the scrollController. `precalculatedIndex` indicates the estimated index of the current item |
| trackBuilder                      | null                    | Custom builder for the Track. `animation` indicates how much the Track is currently shown/hidden. `widgetStates` represents the current state of the Thumb                                                                                                                         |
| **isFixedScroll**                 | false                   | Special scroll mode. Performs non-linear scrolling, jumping between elements<br>This can be very useful in large lists where lags during Thumb movement are inevitable, as items will replace each other in fixed positions, and the lags will not be visible                      |
| **precalculateItemByOffset**      | false                   | hould the item index pre-calculate for display or use in labelBuilder                                                                                                                                                                                                              |
| **scrollbarPosition**             | ScrollbarPosition.Right | The position of ScrollbarUltima on the screen. Can be used for horizontal scroll!                                                                                                                                                                                                  |
| minScrollOffset & maxScrollOffset | null                    | Allow you to specify a range on what thumb moving                                                                                                                                                                                                                                  |
| dynamicThumbLength                | true                    | Should the Thumb length depend on the available scroll area and screen size                                                                                                                                                                                                        |

More docs can be found in **class description!**

## Additional information

- 📚 More examples can be found in the **examples** folder
- ⭐ I would appreciate it if you **star this repository!**

<h3 id="header" align="center">
^_^
</h3>
