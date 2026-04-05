import 'package:hyprion/data/entity/config.dart';

sealed class HomeState {}

class HomeLoadingState extends HomeState {}

class HomeLoadedState extends HomeState {
  final Config config;

  HomeLoadedState({required this.config});
}
