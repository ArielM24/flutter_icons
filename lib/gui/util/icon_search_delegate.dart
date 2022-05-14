import 'package:flutter/material.dart';
import 'package:widget_image/gui/util/icon_names.dart';
import 'package:widget_image/gui/widgets/icon/icon_list.dart';

class IconSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return const BackButton();
  }

  @override
  Widget buildResults(BuildContext context) {
    debugPrint(query);
    List<String> keys = IconNames.icons.keys
        .toList()
        .where((key) => key.contains(query))
        .toList();
    return IconList(iconNames: keys);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    debugPrint(query);
    List<String> keys = IconNames.icons.keys
        .toList()
        .where((key) => key.contains(query))
        .toList();
    return IconList(iconNames: keys);
  }
}
