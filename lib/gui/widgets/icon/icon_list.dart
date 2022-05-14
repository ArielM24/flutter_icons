import 'package:flutter/material.dart';
import 'package:widget_image/gui/pages/editor/editor_page.dart';
import 'package:widget_image/gui/util/icon_names.dart';

class IconList extends StatelessWidget {
  final List<String> iconNames;
  const IconList({Key? key, required this.iconNames}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: iconNames.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(
              IconNames.icons[iconNames[index]],
              color: Colors.blue,
            ),
            title: Text(iconNames[index]),
            subtitle: const Divider(),
            trailing: const Icon(Icons.arrow_forward_ios_outlined),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return EditorPage(
                    iconData: IconNames.icons[iconNames[index]]!,
                    iconName: iconNames[index]);
              }));
            },
          );
        });
  }
}
