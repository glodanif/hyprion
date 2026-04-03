import 'dart:math';

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
  final String mirrorOfId;
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
    required this.mirrorOfId,
    required this.currentPosition,
    required this.availableModes,
  });

  @override
  String toString() {
    return 'Display(id: $id, name: $name, model: $model, description: $description, scale: $scale, transformation: $transformation, resolution: $resolution, refreshRate: $refreshRate, isEnabled: $isEnabled, mirrorOfId: $mirrorOfId, currentPosition: $currentPosition, availableMods: $availableModes)';
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
    String? mirrorOfId,
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
      mirrorOfId: mirrorOfId ?? this.mirrorOfId,
      currentPosition: currentPosition ?? this.currentPosition,
      availableModes: availableModes ?? this.availableModes,
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
