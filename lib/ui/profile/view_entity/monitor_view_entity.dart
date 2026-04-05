import 'package:hyprion/data/entity/display.dart';

class MonitorViewEntity {
  final bool isAvailable;
  final Display display;

  MonitorViewEntity({required this.display, required this.isAvailable});

  MonitorViewEntity copyWith({Display? display, bool? isAvailable}) {
    return MonitorViewEntity(
      display: display ?? this.display,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
