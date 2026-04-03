import 'dart:io';

import 'package:hyprion/data/dependencies/dependencies.dart';

class HyprlandDependencies implements Dependencies {

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
    return Platform.environment.containsKey('HYPRLAND_INSTANCE_SIGNATURE');
  }

  @override
  Future<bool> isAudioManagerRunning() async {
    final result = await Process.run('wpctl', ['status']);
    return result.exitCode == 0;
  }
}
