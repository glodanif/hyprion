import 'dart:math';

import 'package:hyprion/data/entity/monitor.dart';
import 'package:hyprion/data/entity/transformation.dart';

class Display {
  final int id;
  final String name;
  final String model;
  final String description;
  final double scale;
  final Transformation transformation;
  final Size resolution;
  final double refreshRate;
  final bool isEnabled;
  final String mirrorOfName;
  final Point<int> currentPosition;
  final List<Mode> availableModes;

  const Display({
    required this.id,
    required this.name,
    required this.model,
    required this.description,
    required this.scale,
    required this.transformation,
    required this.resolution,
    required this.refreshRate,
    required this.isEnabled,
    required this.mirrorOfName,
    required this.currentPosition,
    required this.availableModes,
  });

  factory Display.fromMonitor(Monitor monitor, {Display? liveDisplay}) {
    return Display(
      id: liveDisplay?.id ?? monitor.id,
      name: monitor.name,
      model: monitor.model,
      description: liveDisplay?.description ?? '',
      scale: monitor.scale,
      transformation: monitor.transformation,
      resolution: monitor.size,
      refreshRate: monitor.refreshRate,
      isEnabled: monitor.isEnabled,
      mirrorOfName: monitor.mirrorOfName,
      currentPosition: monitor.position,
      availableModes: liveDisplay?.availableModes ?? const [],
    );
  }

  @override
  String toString() {
    return 'Display(id: $id, name: $name, model: $model, description: $description, scale: $scale, transformation: $transformation, resolution: $resolution, refreshRate: $refreshRate, isEnabled: $isEnabled, mirrorOfName: $mirrorOfName, currentPosition: $currentPosition, availableMods: $availableModes)';
  }

  Display copyWith({
    int? id,
    String? name,
    String? model,
    String? description,
    double? scale,
    Transformation? transformation,
    Size? resolution,
    double? refreshRate,
    bool? isEnabled,
    String? mirrorOfName,
    Point<int>? currentPosition,
    List<Mode>? availableModes,
  }) {
    return Display(
      id: id ?? this.id,
      name: name ?? this.name,
      model: model ?? this.model,
      description: description ?? this.description,
      scale: scale ?? this.scale,
      transformation: transformation ?? this.transformation,
      resolution: resolution ?? this.resolution,
      refreshRate: refreshRate ?? this.refreshRate,
      isEnabled: isEnabled ?? this.isEnabled,
      mirrorOfName: mirrorOfName ?? this.mirrorOfName,
      currentPosition: currentPosition ?? this.currentPosition,
      availableModes: availableModes ?? this.availableModes,
    );
  }

  Monitor toMonitor() {
    return Monitor(
      id: id,
      name: name,
      model: model,
      refreshRate: refreshRate,
      scale: scale,
      size: resolution,
      position: currentPosition,
      transformation: transformation,
      isEnabled: isEnabled,
      mirrorOfName: mirrorOfName,
    );
  }
}

class Mode {
  final int width;
  final int height;
  final List<double> refreshRates;

  const Mode({
    required this.width,
    required this.height,
    required this.refreshRates,
  });

  @override
  String toString() {
    return 'Mode(width: $width, height: $height, refreshRates: $refreshRates)';
  }
}

class Size {
  final int width;
  final int height;

  const Size({required this.width, required this.height});

  @override
  String toString() {
    return 'Size(width: $width, height: $height)';
  }
}
