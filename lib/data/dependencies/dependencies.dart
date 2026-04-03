abstract class Dependencies {
  String get windowMangerName;
  String get audioManagerName;
  String get windowManagerCommand;
  String get audioManagerCommand;
  Future<bool> isWindowManagerRunning();
  Future<bool> isAudioManagerRunning();
}
