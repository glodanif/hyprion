import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyprion/data/entity/display.dart';
import 'package:hyprion/data/entity/profile.dart';
import 'package:hyprion/data/entity/transformation.dart';
import 'package:hyprion/data/storage/profile_storage.dart';
import 'package:hyprion/data/system/display_manager.dart';
import 'package:hyprion/ui/profile/bloc/profile_state.dart';
import 'package:hyprion/ui/profile/view_entity/monitor_view_entity.dart';
import 'package:uuid/uuid.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileStorage _profileStorage;
  final DisplayManager _displayManager;

  List<Display> _availableDisplays = [];
  List<MonitorViewEntity> _availableMonitors = [];

  bool _isNewProfile = true;
  late Profile _currentProfile;

  ProfileCubit(this._profileStorage, this._displayManager)
    : super(ProfileLoadingState());

  Future<void> loadProfile(String? profileId) async {
    _isNewProfile = profileId == null;
    emit(ProfileLoadingState());

    final displaysResult = await _displayManager.getAvailableDisplays();
    _availableDisplays = displaysResult.fold(
      (displays) => displays,
      (failure) => [],
    );

    if (profileId == null) {
      _availableMonitors = _availableDisplays
          .map(
            (display) => MonitorViewEntity(display: display, isAvailable: true),
          )
          .toList();

      _currentProfile = Profile(
        id: '',
        name: 'Unnamed Profile',
        displays: _availableDisplays.map((d) => d.toMonitor()).toList(),
      );
    } else {
      final profile = await _profileStorage.getProfileById(profileId);
      if (profile != null) {
        _currentProfile = profile;

        final liveByName = {for (final d in _availableDisplays) d.name: d};
        final profileNames = <String>{};
        _availableMonitors = [];

        for (final monitor in _currentProfile.displays) {
          profileNames.add(monitor.name);
          final liveDisplay = liveByName[monitor.name];

          _availableMonitors.add(
            MonitorViewEntity(
              display: Display.fromMonitor(monitor, liveDisplay: liveDisplay),
              isAvailable: liveDisplay != null,
            ),
          );
        }

        for (final liveDisplay in _availableDisplays) {
          if (!profileNames.contains(liveDisplay.name)) {
            _availableMonitors.add(
              MonitorViewEntity(
                display: liveDisplay.copyWith(isEnabled: false),
                isAvailable: true,
              ),
            );
          }
        }
      } else {
        _availableMonitors = _availableDisplays.map((display) {
          return MonitorViewEntity(
            display: display.copyWith(isEnabled: false),
            isAvailable: true,
          );
        }).toList();
      }
    }

    debugPrint('Loaded profile: ${_currentProfile.id}');
    _emitMonitors();
  }

  Future<void> setEnabled(int index, bool enabled) async {
    final monitorIndex = _availableMonitors.indexWhere(
      (monitor) => monitor.display.id == index,
    );
    if (monitorIndex != -1) {
      final monitor = _availableMonitors[monitorIndex];
      final updatedDisplay = monitor.display.copyWith(isEnabled: enabled);
      _availableMonitors[monitorIndex] = monitor.copyWith(
        display: updatedDisplay,
      );
      _emitMonitors();
    }
  }

  Future<void> setMode(
    int displayId,
    int width,
    int height,
    double refreshRate,
  ) async {
    final monitorIndex = _availableMonitors.indexWhere(
      (monitor) => monitor.display.id == displayId,
    );
    if (monitorIndex != -1) {
      final monitor = _availableMonitors[monitorIndex];
      final updatedDisplay = monitor.display.copyWith(
        resolution: Size(width: width, height: height),
        refreshRate: refreshRate,
      );
      _availableMonitors[monitorIndex] = monitor.copyWith(
        display: updatedDisplay,
      );
      _emitMonitors();
    }
  }

  Future<void> setTransformation(
    int index,
    Transformation transformation,
  ) async {
    final monitorIndex = _availableMonitors.indexWhere(
      (monitor) => monitor.display.id == index,
    );
    if (monitorIndex != -1) {
      final monitor = _availableMonitors[monitorIndex];
      final updatedDisplay = monitor.display.copyWith(
        transformation: transformation,
      );
      _availableMonitors[monitorIndex] = monitor.copyWith(
        display: updatedDisplay,
      );
      _emitMonitors();
    }
  }

  Future<void> setScale(int index, double scale) async {
    final monitorIndex = _availableMonitors.indexWhere(
      (monitor) => monitor.display.id == index,
    );
    if (monitorIndex != -1) {
      final monitor = _availableMonitors[monitorIndex];
      final updatedDisplay = monitor.display.copyWith(scale: scale);
      _availableMonitors[monitorIndex] = monitor.copyWith(
        display: updatedDisplay,
      );
      _emitMonitors();
    }
  }

  Future<void> setProfileName(String name) async {
    _currentProfile = _currentProfile.copyWith(name: name);
    _emitMonitors();
  }

  void removeUnavailableMonitor(int displayId) {
    _availableMonitors.removeWhere(
      (m) => m.display.id == displayId && !m.isAvailable,
    );
    _emitMonitors();
  }

  Future<void> saveProfile() async {
    final updatedProfile = _currentProfile.copyWith(
      id: _isNewProfile ? Uuid().v4() : _currentProfile.id,
      displays: _availableMonitors
          .map((monitor) => monitor.display.toMonitor())
          .toList(),
    );
    await _profileStorage.saveProfile(updatedProfile);
    emit(ProfileCompletedState());
  }

  Future<void> removeProfile() async {
    await _profileStorage.deleteProfileById(_currentProfile.id);
    emit(ProfileCompletedState());
  }

  void _emitMonitors() {
    emit(
      ProfileLoadedState(
        profile: _currentProfile,
        monitors: _availableMonitors,
      ),
    );
  }
}
