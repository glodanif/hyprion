import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyprion/data/entity/display.dart';
import 'package:hyprion/data/storage/profile_storage.dart';
import 'package:hyprion/data/system/display_manager.dart';
import 'package:hyprion/ui/profile/bloc/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileStorage _profileStorage;
  final DisplayManager _displayManager;

  List<Display> _availableDisplays = [];

  ProfileCubit(this._profileStorage, this._displayManager)
    : super(ProfileLoadingState());

  Future<void> loadProfile(String? profileId) async {
    final displaysResult = await _displayManager.getAvailableDisplays();
    _availableDisplays = displaysResult.fold(
      (displays) => displays,
      (failure) => [],
    );
    _availableDisplays.sort((a, b) {
      if (a.isEnabled != b.isEnabled) {
        return a.isEnabled ? -1 : 1;
      }
      return a.id.compareTo(b.id);
    });

    debugPrint('Available displays: $_availableDisplays');

    if (profileId == null) {
      emit(ProfileLoadedState(displays: _availableDisplays));
      return;
    }

    emit(ProfileLoadingState());
    final profile = await _profileStorage.getProfileById(profileId);
    emit(ProfileLoadedState(profile: profile, displays: _availableDisplays));
  }
}
