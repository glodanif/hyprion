import 'package:hyprion/data/entity/config.dart';
import 'package:hyprion/data/entity/profile.dart';

abstract class ProfileStorage {
  Future<void> saveProfile(Profile profile);

  Future<Profile?> getProfileById(String id);

  Future<void> deleteProfileById(String id);

  Future<List<Profile>> getAllProfiles();

  Future<Config> getConfig();

  Future<void> setCurrentProfileId(String id);
}
