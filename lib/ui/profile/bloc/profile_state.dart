import 'package:hyprion/data/entity/display.dart';
import 'package:hyprion/data/entity/profile.dart';

sealed class ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileLoadedState extends ProfileState {
  final Profile? profile;
  final List<Display> displays;

  ProfileLoadedState({this.profile, required this.displays});
}
