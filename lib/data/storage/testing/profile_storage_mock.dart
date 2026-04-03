import 'package:hyprion/data/entity/profile.dart';

import '../profile_storage.dart';

class ProfileStorageMock extends ProfileStorage {
  @override
  Future<void> saveProfile(Profile profile) async {}

  @override
  Future<Profile?> getProfileById(String id) async {
    return null;
  }

  @override
  Future<void> deleteProfileById(String id) async {}

  @override
  Future<List<Profile>> getAllProfiles() async {
    return [];
  }
}
