import 'dart:async';

class AppPermissionHandler {
  static final AppPermissionHandler _instance =
      AppPermissionHandler._();
  factory AppPermissionHandler() => _instance;
  AppPermissionHandler._();

  Future<bool> requestStoragePermission() async {
    return true;
  }

  Future<bool> requestSensorPermission() async {
    return true;
  }

  Future<bool> requestNotificationPermission() async {
    return true;
  }

  Future<bool> hasStoragePermission() async {
    return true;
  }
}
