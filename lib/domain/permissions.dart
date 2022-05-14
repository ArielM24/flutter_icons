import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

checkPermissions() async {
  if (!(await Permission.storage.isGranted)) {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    debugPrint("${statuses[Permission.storage]}");
  }
}
