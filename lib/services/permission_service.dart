import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<void> initialize() async {
    await requestLocationPermission();
    await requestNotificationPermission();
  }

  static Future<bool> requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    
    if (status.isDenied) {
      status = await Permission.location.request();
    }
    
    if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    }
    
    return status.isGranted;
  }

  static Future<bool> requestNotificationPermission() async {
    PermissionStatus status = await Permission.notification.request();
    return status.isGranted;
  }

  static Future<bool> hasLocationPermission() async {
    return await Permission.location.isGranted;
  }
}