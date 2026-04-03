import 'package:hyprion/data/entity/display.dart';

class MonitorViewEntity {
  final Display display;

  MonitorViewEntity({required this.display});

  MonitorViewEntity copyWith({Display? display}) {
    return MonitorViewEntity(display: display ?? this.display);
  }
}
