import 'package:hyprion/data/entity/profile.dart';

class Config {
  final String currentProfileId;
  final List<Profile> profiles;

  Config({required this.currentProfileId, required this.profiles});
}
