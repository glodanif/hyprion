import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyprion/data/storage/profile_storage.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final ProfileStorage _profileStorage;

  HomeCubit(this._profileStorage) : super(HomeLoadingState());

  Future<void> loadProfiles() async {
    emit(HomeLoadingState());
    final profiles = await _profileStorage.getAllProfiles();
    debugPrint('Loaded $profiles profiles');
    emit(HomeLoadedState(profiles: profiles));
  }
}
