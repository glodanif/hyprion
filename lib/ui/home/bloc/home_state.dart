import 'package:hyprion/data/entity/profile.dart';

sealed class HomeState {}

class HomeLoadingState extends HomeState {}

class HomeLoadedState extends HomeState {
  final List<Profile> profiles;

  HomeLoadedState({required this.profiles});
}
