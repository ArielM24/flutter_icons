import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:widget_image/domain/permissions.dart';
import 'package:widget_to_image/widget_to_image.dart';

class EditorPage extends StatefulWidget {
  final IconData iconData;
  final String iconName;
  const EditorPage({Key? key, required this.iconData, required this.iconName})
      : super(key: key);

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  double size = 100;
  Color color = Colors.blue;
  Color pickerColor = Colors.blue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.iconName),
        backgroundColor: Colors.blue[900],
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.width,
            child: Icon(
              widget.iconData,
              size: size,
              color: color,
            ),
          ),
          Text("Tamaño ${size.toStringAsFixed(2)} px"),
          Slider(
            activeColor: Colors.blue[900],
            value: size,
            min: 1,
            max: MediaQuery.of(context).size.width,
            label: size.toStringAsFixed(2),
            onChanged: (value) {
              setState(() {
                size = value;
              });
            },
            divisions: 299,
          ),
          ListTile(
            leading: Container(width: 30, height: 30, color: color),
            title: ColorPickerInput(
              color,
              (Color c) {
                setState(() {
                  color = c;
                  pickerColor = c;
                });
              },
            ),
            trailing: IconButton(
                onPressed: pickColor,
                icon: Icon(Icons.color_lens, color: Colors.blue[900])),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
              heroTag: "save",
              tooltip: "Save icon as an image",
              backgroundColor: Colors.blue[900],
              onPressed: saveImage,
              child: const Icon(Icons.save_as)),
          const SizedBox(width: 20),
          FloatingActionButton(
              heroTag: "send",
              tooltip: "Send icon as an image",
              backgroundColor: Colors.blue[900],
              onPressed: sendImage,
              child: const Icon(Icons.send)),
        ],
      ),
    );
  }

  pickColor() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Pick a color"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  ColorPicker(
                    pickerColor: pickerColor,
                    onColorChanged: (Color c) {
                      setState(() {
                        color = c;
                        pickerColor = c;
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<String> saveImage() async {
    await checkPermissions();
    ByteData byteData = await WidgetToImage.widgetToImage(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SizedBox(
            width: size,
            height: size,
            child: Icon(widget.iconData, color: color, size: size),
          ),
        ),
        size: Size(size, size));
    debugPrint("${byteData.lengthInBytes}");
    debugPrint("${await getExternalStorageDirectories()}");
    File f = File("/storage/emulated/0/FlutterIcons/${widget.iconName}.png");
    await f.create(recursive: true);
    await f.writeAsBytes(byteData.buffer.asUint8List());
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Icon saved in ${f.path}"),
      backgroundColor: Colors.blue[900],
    ));
    return f.path;
  }

  sendImage() async {
    String iconPath = await saveImage();
    await Share.shareFiles([iconPath], text: widget.iconName);
  }
}
