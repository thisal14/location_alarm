import 'package:flutter/material.dart';
import '../models/alarm_settings.dart';

class ControlPanel extends StatelessWidget {
  final AlarmSettings settings;
  final bool isTrackingActive;
  final VoidCallback onStartTracking;
  final VoidCallback onStopTracking;
  final Function(AlarmSettings) onSettingsChanged;

  const ControlPanel({
    Key? key,
    required this.settings,
    required this.isTrackingActive,
    required this.onStartTracking,
    required this.onStopTracking,
    required this.onSettingsChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Distance slider
          Row(
            children: [
              Text('Alert Distance: '),
              Expanded(
                child: Slider(
                  value: settings.alertDistance,
                  min: 50,
                  max: 1000,
                  divisions: 19,
                  label: '${settings.alertDistance.round()}m',
                  onChanged: (value) {
                    onSettingsChanged(settings.copyWith(alertDistance: value));
                  },
                ),
              ),
            ],
          ),
          
          // Control buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: isTrackingActive ? null : onStartTracking,
                child: Text('Start Journey'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
              ElevatedButton(
                onPressed: isTrackingActive ? onStopTracking : null,
                child: Text('Stop Journey'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ],
          ),
          
          // Status indicator
          if (isTrackingActive)
            Container(
              margin: EdgeInsets.only(top: 8),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '🎯 Journey Active - Alert at ${settings.alertDistance.round()}m',
                style: TextStyle(color: Colors.green[800]),
              ),
            ),
        ],
      ),
    );
  }
}