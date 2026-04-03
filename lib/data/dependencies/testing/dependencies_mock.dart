import '../dependencies.dart';

class DependenciesMock implements Dependencies {
  final bool _windowManagerRunning;
  final bool _audioManagerRunning;

  DependenciesMock({
    bool windowManagerRunning = true,
    bool audioManagerRunning = true,
  }) : _windowManagerRunning = windowManagerRunning,
       _audioManagerRunning = audioManagerRunning;

  @override
  String get audioManagerCommand => "wpctl";

  @override
  String get audioManagerName => "PipeWire";

  @override
  String get windowManagerCommand => "hyprctl";

  @override
  String get windowMangerName => "Hyprland";

  @override
  Future<bool> isWindowManagerRunning() async {
    return _windowManagerRunning;
  }

  @override
  Future<bool> isAudioManagerRunning() async {
    return _audioManagerRunning;
  }
}
