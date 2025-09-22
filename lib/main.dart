import 'package:flutter/material.dart';
import 'screens/map_screen.dart';
import 'services/permission_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PermissionService.initialize();
  runApp(LocationAlarmApp());
}

class LocationAlarmApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location Alarm',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MapScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}