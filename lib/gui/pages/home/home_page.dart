import 'package:flutter/material.dart';
import 'package:widget_image/gui/util/icon_names.dart';
import 'package:widget_image/gui/util/icon_search_delegate.dart';
import 'package:widget_image/gui/widgets/icon/icon_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Icons"),
        backgroundColor: Colors.blue[900],
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: IconSearchDelegate());
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: IconList(iconNames: IconNames.icons.keys.toList()),
    );
  }
}
