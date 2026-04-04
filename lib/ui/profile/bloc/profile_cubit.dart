import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyprion/data/entity/display.dart';
import 'package:hyprion/data/entity/profile.dart';
import 'package:hyprion/data/entity/transformation.dart';
import 'package:hyprion/data/storage/profile_storage.dart';
import 'package:hyprion/data/system/display_manager.dart';
import 'package:hyprion/ui/profile/bloc/profile_state.dart';
import 'package:hyprion/ui/profile/view_entity/monitor_view_entity.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileStorage _profileStorage;
  final DisplayManager _displayManager;

  List<Display> _availableDisplays = [];
  List<MonitorViewEntity> _availableMonitors = [];

  Profile? _currentProfile;

  ProfileCubit(this._profileStorage, this._displayManager)
    : super(ProfileLoadingState());

  Future<void> loadProfile(String? profileId) async {
    final displaysResult = await _displayManager.getAvailableDisplays();
    _availableDisplays = displaysResult.fold(
      (displays) => displays,
      (failure) => [],
    );

    _availableMonitors = _availableDisplays
        .map((display) => MonitorViewEntity(display: display))
        .toList();

    if (profileId == null) {
      _emitMonitors();
      return;
    }

    emit(ProfileLoadingState());
    _currentProfile = await _profileStorage.getProfileById(profileId);
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

  void _emitMonitors() {
    emit(
      ProfileLoadedState(
        profile: _currentProfile,
        monitors: _availableMonitors,
      ),
    );
  }
}
