import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:hyprion/data/entity/audio_sink.dart';
import 'package:hyprion/data/entity/monitor.dart';
import 'package:hyprion/data/entity/profile.dart';
import 'package:hyprion/data/entity/transform.dart';

import 'profile_storage.dart';

class ProfileStorageImpl extends ProfileStorage {
  static const _fileName = 'profiles.json';
  final String appName;

  ProfileStorageImpl({required this.appName});

  @override
  Future<void> saveProfile(Profile profile) async {
    final profiles = await getAllProfiles();
    final existingIndex = profiles.indexWhere((p) => p.id == profile.id);

    if (existingIndex != -1) {
      profiles[existingIndex] = profile;
    } else {
      profiles.add(profile);
    }

    await _saveProfiles(profiles);
  }

  @override
  Future<Profile?> getProfileById(String id) async {
    final profiles = await getAllProfiles();
    try {
      return profiles.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> deleteProfileById(String id) async {
    final profiles = await getAllProfiles();
    profiles.removeWhere((p) => p.id == id);
    await _saveProfiles(profiles);
  }

  @override
  Future<List<Profile>> getAllProfiles() async {
    final file = await _getProfilesFile();

    if (!await file.exists()) {
      return [];
    }

    final content = await file.readAsString();
    if (content.isEmpty) {
      return [];
    }

    final data = json.decode(content) as Map<String, dynamic>;
    final profilesList = data['profiles'] as List?;

    if (profilesList == null) {
      return [];
    }

    return profilesList
        .map((p) => _profileFromMap(p as Map<String, dynamic>))
        .toList();
  }

  Future<void> _saveProfiles(List<Profile> profiles) async {
    final file = await _getProfilesFile();
    final data = {'profiles': profiles.map((p) => _profileToMap(p)).toList()};

    const encoder = JsonEncoder.withIndent('  ');
    final jsonString = encoder.convert(data);
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
      await file.writeAsString('{"profiles":[]}');
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
      'refresh_rate': display.refreshRate,
      'scale': display.scale,
      'width': display.size.width,
      'height': display.size.height,
      'position_x': display.position.x,
      'position_y': display.position.y,
      'transformation': display.transform.code,
      'is_enabled': display.isEnabled,
    };
  }

  Monitor _monitorFromMap(Map<String, dynamic> map) {
    return Monitor(
      id: map['id'] as String,
      name: map['name'] as String,
      refreshRate: map['refresh_rate'] as int,
      scale: (map['scale'] as num).toDouble(),
      size: Size(
        (map['width'] as num).toDouble(),
        (map['height'] as num).toDouble(),
      ),
      position: Point<int>(map['position_x'] as int, map['position_y'] as int),
      transform: Transform.values.firstWhere(
        (t) => t.code == map['transformation'] as int,
      ),
      isEnabled: map['is_enabled'] as bool,
    );
  }

  Map<String, dynamic> _audioSinkToMap(AudioSink audioSink) {
    return {'id': audioSink.id, 'name': audioSink.name};
  }

  AudioSink _audioSinkFromMap(Map<String, dynamic> map) {
    return AudioSink(id: map['id'] as String, name: map['name'] as String);
  }
}
