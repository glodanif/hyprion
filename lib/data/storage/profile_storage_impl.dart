import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:hyprion/data/entity/audio_sink.dart';
import 'package:hyprion/data/entity/config.dart';
import 'package:hyprion/data/entity/display.dart';
import 'package:hyprion/data/entity/monitor.dart';
import 'package:hyprion/data/entity/profile.dart';
import 'package:hyprion/data/entity/transformation.dart';

import 'profile_storage.dart';

class ProfileStorageImpl extends ProfileStorage {
  static const _fileName = 'profiles.json';
  final String appName;

  ProfileStorageImpl({required this.appName});

  @override
  Future<void> saveProfile(Profile profile) async {
    final config = await getConfig();
    final profiles = [...config.profiles];
    final existingIndex = profiles.indexWhere((p) => p.id == profile.id);

    if (existingIndex != -1) {
      profiles[existingIndex] = profile;
    } else {
      profiles.add(profile);
    }

    await _saveConfig(
      Config(currentProfileId: config.currentProfileId, profiles: profiles),
    );
  }

  @override
  Future<Profile?> getProfileById(String id) async {
    final config = await getConfig();
    try {
      return config.profiles.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> deleteProfileById(String id) async {
    final config = await getConfig();
    final profiles = [...config.profiles];
    profiles.removeWhere((p) => p.id == id);

    var currentProfileId = config.currentProfileId;
    if (config.currentProfileId == id) {
      currentProfileId = profiles.isNotEmpty ? profiles.first.id : '';
    }

    await _saveConfig(
      Config(currentProfileId: currentProfileId, profiles: profiles),
    );
  }

  @override
  Future<List<Profile>> getAllProfiles() async {
    final config = await getConfig();
    return config.profiles;
  }

  @override
  Future<Config> getConfig() async {
    final file = await _getProfilesFile();

    if (!await file.exists()) {
      return Config(currentProfileId: '', profiles: []);
    }

    final content = await file.readAsString();
    if (content.isEmpty) {
      return Config(currentProfileId: '', profiles: []);
    }

    final decoded = json.decode(content);
    if (decoded is! Map) {
      return Config(currentProfileId: '', profiles: []);
    }

    final data = decoded.cast<String, dynamic>();

    // Backward compatible with old format: { "profiles": [...] }
    final profilesList = data['profiles'] as List? ?? [];
    final currentProfileId = data['current_profile_id'] as String? ?? '';

    return Config(
      currentProfileId: currentProfileId,
      profiles: profilesList
          .map((p) => _profileFromMap(p as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<void> setCurrentProfileId(String id) async {
    final config = await getConfig();
    await _saveConfig(Config(currentProfileId: id, profiles: config.profiles));
  }

  Future<void> _saveConfig(Config config) async {
    final file = await _getProfilesFile();
    final data = {
      'current_profile_id': config.currentProfileId,
      'profiles': config.profiles.map((p) => _profileToMap(p)).toList(),
    };

    const encoder = JsonEncoder.withIndent('  ');
    final jsonString = encoder.convert(data);
    debugPrint(jsonString);
    await file.writeAsString(jsonString);
  }

  Future<File> _getProfilesFile() async {
    final configHome =
        Platform.environment['XDG_CONFIG_HOME'] ??
        '${Platform.environment['HOME']}/.config';

    final configDir = Directory('$configHome/$appName');
    if (!await configDir.exists()) {
      await configDir.create(recursive: true);
    }

    final file = File('${configDir.path}/$_fileName');
    if (!await file.exists()) {
      await file.create();
      await file.writeAsString('{"current_profile_id":"","profiles":[]}');
    }

    return file;
  }

  Map<String, dynamic> _profileToMap(Profile profile) {
    return {
      'id': profile.id,
      'name': profile.name,
      'displays': profile.displays.map((d) => _monitorToMap(d)).toList(),
      if (profile.audioSink != null)
        'audio_sink': _audioSinkToMap(profile.audioSink!),
    };
  }

  Profile _profileFromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'] as String,
      name: map['name'] as String,
      displays: (map['displays'] as List)
          .map((d) => _monitorFromMap(d as Map<String, dynamic>))
          .toList(),
      audioSink: map['audio_sink'] != null
          ? _audioSinkFromMap(map['audio_sink'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> _monitorToMap(Monitor display) {
    return {
      'id': display.id,
      'name': display.name,
      'model': display.model,
      'refresh_rate': display.refreshRate,
      'scale': display.scale,
      'width': display.size.width,
      'height': display.size.height,
      'position_x': display.position.x,
      'position_y': display.position.y,
      'transformation': display.transformation.code,
      'is_enabled': display.isEnabled,
      'mirror_of_name': display.mirrorOfName,
    };
  }

  Monitor _monitorFromMap(Map<String, dynamic> map) {
    return Monitor(
      id: map['id'] as int,
      name: map['name'] as String,
      model: map['model'] as String,
      refreshRate: (map['refresh_rate'] as num).toDouble(),
      scale: (map['scale'] as num).toDouble(),
      size: Size(
        width: (map['width'] as num).toInt(),
        height: (map['height'] as num).toInt(),
      ),
      position: Point<int>(map['position_x'] as int, map['position_y'] as int),
      transformation: Transformation.values.firstWhere(
        (t) => t.code == map['transformation'] as int,
      ),
      isEnabled: map['is_enabled'] as bool,
      mirrorOfName: map['mirror_of_name'] as String,
    );
  }

  Map<String, dynamic> _audioSinkToMap(AudioSink audioSink) {
    return {'id': audioSink.id, 'name': audioSink.name};
  }

  AudioSink _audioSinkFromMap(Map<String, dynamic> map) {
    return AudioSink(id: map['id'] as String, name: map['name'] as String);
  }
}
