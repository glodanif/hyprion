import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:fpdart/fpdart.dart';
import 'package:hyprion/data/dependencies/dependencies.dart';
import 'package:hyprion/data/entity/display.dart';
import 'package:hyprion/data/entity/failure.dart';
import 'package:hyprion/data/entity/transform.dart';

import 'display_manager.dart';

class DisplayManagerImpl implements DisplayManager {
  final Dependencies _dependencies;

  DisplayManagerImpl(this._dependencies);

  @override
  Future<Either<List<Display>, Failure>> getAvailableDisplays() async {
    try {
      final output = await Process.run(_dependencies.windowManagerCommand, [
        '-j',
        'monitors',
        'all',
      ]);

      final List<dynamic> monitorsJson = jsonDecode(output.stdout.toString());
      final displays = monitorsJson.map((json) => _parseDisplay(json)).toList();

      return Left(displays);
    } catch (e) {
      return Right(Failure(e.toString()));
    }
  }

  Display _parseDisplay(Map<String, dynamic> json) {
    final resolution = Size(
      width: json['width'] as int,
      height: json['height'] as int,
    );

    final refreshRate = (json['refreshRate'] as num).toDouble();

    final availableMods = _parseAvailableModes(json['availableModes']);

    final transformCode = json['transform'] as int;
    final transform = Transform.values.firstWhere(
      (t) => t.code == transformCode,
      orElse: () => Transform.normal,
    );

    final mirrorOf = json['mirrorOf'] as String;

    return Display(
      id: json['id'] as int,
      name: json['name'] as String,
      model: json['model'] as String,
      description: json['description'] as String,
      scale: (json['scale'] as num).toDouble(),
      transform: transform,
      resolution: resolution,
      refreshRate: refreshRate,
      isEnabled: !(json['disabled'] as bool),
      mirrorOfId: mirrorOf == 'none' ? '' : mirrorOf,
      currentPosition: Point(json['x'] as int, json['y'] as int),
      availableModes: availableMods,
    );
  }

  List<Mode> _parseAvailableModes(dynamic modesData) {
    if (modesData is List) {
      return _groupModesByResolution(_parseModesFromList(modesData));
    }

    if (modesData is String && modesData.isNotEmpty) {
      return _groupModesByResolution(_parseModesFromString(modesData));
    }

    return [];
  }

  List<_ModeEntry> _parseModesFromList(List<dynamic> modesList) {
    final modes = <_ModeEntry>[];
    final modePattern = RegExp(r'(\d+)x(\d+)@([\d.]+)');

    for (final modeString in modesList) {
      final match = modePattern.firstMatch(modeString.toString());
      if (match != null) {
        modes.add(
          _ModeEntry(
            width: int.parse(match.group(1)!),
            height: int.parse(match.group(2)!),
            refreshRate: double.parse(match.group(3)!),
          ),
        );
      }
    }
    return modes;
  }

  List<_ModeEntry> _parseModesFromString(String modesString) {
    final modes = <_ModeEntry>[];
    final modePattern = RegExp(r'(\d+)x(\d+)@([\d.]+)');
    final matches = modePattern.allMatches(modesString);

    for (final match in matches) {
      modes.add(
        _ModeEntry(
          width: int.parse(match.group(1)!),
          height: int.parse(match.group(2)!),
          refreshRate: double.parse(match.group(3)!),
        ),
      );
    }
    return modes;
  }

  List<Mode> _groupModesByResolution(List<_ModeEntry> entries) {
    final Map<String, List<double>> resolutionMap = {};

    for (final entry in entries) {
      final key = '${entry.width}x${entry.height}';
      resolutionMap.putIfAbsent(key, () => []).add(entry.refreshRate);
    }

    final mods = <Mode>[];
    for (final entry in entries) {
      final key = '${entry.width}x${entry.height}';
      if (resolutionMap.containsKey(key)) {
        mods.add(
          Mode(
            width: entry.width,
            height: entry.height,
            refreshRates: resolutionMap[key]!,
          ),
        );
        resolutionMap.remove(key);
      }
    }

    return mods;
  }
}

class _ModeEntry {
  final int width;
  final int height;
  final double refreshRate;

  _ModeEntry({
    required this.width,
    required this.height,
    required this.refreshRate,
  });
}
