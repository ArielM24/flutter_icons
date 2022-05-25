import 'dart:io';
import 'dart:html' as html;
import 'package:flutter/foundation.dart';
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
  double size = 700;
  Color mainColor = const Color(0xFF0C439B);
  Color pickerColor = Colors.blue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.iconName),
        backgroundColor: Colors.blue[900],
      ),
      body: SingleChildScrollView(
        child: Row(children: [
          SizedBox(
            height: 700,
            width: 700,
            child: Icon(
              widget.iconData,
              size: size,
              color: mainColor,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Text("Tamaño ${size.toStringAsFixed(2)} px"),
              ),
              SizedBox(
                width: 400,
                child: Slider(
                  activeColor: Colors.blue[900],
                  value: size,
                  min: 1,
                  max: 700,
                  label: size.toStringAsFixed(2),
                  onChanged: (value) {
                    setState(() {
                      size = value;
                    });
                  },
                  divisions: 700,
                ),
              ),
              Container(
                width: 400,
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: pickColor,
                        icon: Icon(Icons.color_lens, color: Colors.blue[900])),
                    ColorPickerInput(
                      mainColor,
                      (Color c) {
                        setState(() {
                          mainColor = c;
                          pickerColor = c;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 22.0),
                child: ElevatedButton.icon(
                  onPressed: saveImage,
                  icon: const Icon(Icons.save),
                  label: const Text("Save"),
                  style: ElevatedButton.styleFrom(primary: Colors.blue[900]),
                ),
              )
            ],
          ),
        ]),
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
                        mainColor = c;
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
            child: Icon(widget.iconData, color: mainColor, size: size),
          ),
        ),
        size: Size(size, size));
    debugPrint("${byteData.lengthInBytes}");
    if (kIsWeb) {
      downloadImage(byteData);
      return "";
    }

    return await writeImage(byteData);
  }

  Future<String> writeImage(ByteData byteData) async {
    if (!kIsWeb) {
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
    return "";
  }

  downloadImage(ByteData byteData) async {
    final blob = html.Blob([byteData.buffer.asUint8List()]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = "none"
      ..download = "${widget.iconName}.png";
    html.document.body?.children.add(anchor);
    anchor.click();
    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }

  sendImage() async {
    String iconPath = await saveImage();
    await Share.shareFiles([iconPath], text: widget.iconName);
  }
}
