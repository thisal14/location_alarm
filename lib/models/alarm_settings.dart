class AlarmSettings {
  final double alertDistance;
  final bool isVibrationEnabled;
  final bool isSoundEnabled;
  final String soundFile;
  final int repeatCount;

  AlarmSettings({
    this.alertDistance = 100.0,
    this.isVibrationEnabled = true,
    this.isSoundEnabled = true,
    this.soundFile = 'alarm.mp3',
    this.repeatCount = 3,
  });

  AlarmSettings copyWith({
    double? alertDistance,
    bool? isVibrationEnabled,
    bool? isSoundEnabled,
    String? soundFile,
    int? repeatCount,
  }) {
    return AlarmSettings(
      alertDistance: alertDistance ?? this.alertDistance,
      isVibrationEnabled: isVibrationEnabled ?? this.isVibrationEnabled,
      isSoundEnabled: isSoundEnabled ?? this.isSoundEnabled,
      soundFile: soundFile ?? this.soundFile,
      repeatCount: repeatCount ?? this.repeatCount,
    );
  }
}