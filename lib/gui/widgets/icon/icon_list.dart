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
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black.withOpacity(0.2))),
              child: ListTile(
                leading: Icon(
                  IconNames.icons[iconNames[index]],
                  color: Colors.blue[900],
                ),
                title: Text(iconNames[index]),
                trailing: Icon(Icons.arrow_forward_ios_outlined,
                    color: Colors.blue[900]),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return EditorPage(
                        iconData: IconNames.icons[iconNames[index]]!,
                        iconName: iconNames[index]);
                  }));
                },
              ),
            ),
          );
        });
  }
}
