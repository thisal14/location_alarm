import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'Location Alarm';
  static const double defaultAlertDistance = 100.0;
  static const double minAlertDistance = 50.0;
  static const double maxAlertDistance = 1000.0;
  
  // Map settings
  static const double defaultZoom = 15.0;
  static const double trackingZoom = 18.0;
  
  // Sound files
  static const String defaultAlarmSound = 'alarm.mp3';
  static const String notificationSound = 'notification.mp3';
  
  // Colors
  static const primaryColor = Colors.blue;
  static const trackingActiveColor = Colors.green;
  static const trackingInactiveColor = Colors.grey;
}