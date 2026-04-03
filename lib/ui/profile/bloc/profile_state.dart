import 'package:hyprion/data/entity/profile.dart';
import 'package:hyprion/ui/profile/view_entity/monitor_view_entity.dart';

sealed class ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileLoadedState extends ProfileState {
  final Profile? profile;
  final List<MonitorViewEntity> monitors;

  ProfileLoadedState({this.profile, required this.monitors});
}
