import 'dart:async';

import 'package:wine_cellar/core/models/profile.dart';
import 'package:wine_cellar/ui/constants.dart';

import 'database_service.dart';

class ProfileService {
  DatabaseService _db;

  StreamController<List<Profile>> _profilesController =
      StreamController.broadcast();

  Sink<List<Profile>> get profileSink => _profilesController.sink;

  Stream<List<Profile>> get profileStream => _profilesController.stream;

  ProfileService({DatabaseService db}) : _db = db;

  Future<List<Profile>> getAllProfiles() async {
    final List<Profile> profiles = [];
    final response = await _db.getTable('profiles');
    response.forEach((p) => profiles.add(Profile.fromJson(p)));
    return profiles;
  }

  Future<String> getDefaultCellar() async {
    String cellarName;
    List<Profile> profiles = await getAllProfiles();
    profiles.forEach((p) {
      if (p.isDefault) {
        cellarName = p.cellarName;
      }
    });
    return cellarName;
  }

  Future<void> updateProfile(Profile profile)async{
   await _db.update('profiles', profile.toJson());
   sinkProfiles();
  }

  Future<void> iniDb() async {
    await _db.iniDb();
  }

  Future<void> sinkProfiles() async {
    List<Profile> profiles = await getAllProfiles();
    profiles.forEach((p) {
      if (p.isDefault) {
        profiles.remove(p);
        profiles.insert(0, p);
      }
    });
    profileSink.add(profiles);
  }

  Future<void> addProfile(String displayName, String cellarName) async {
    int id = await _db.getId('profiles');
    final profile = Profile(
        cellarName: cellarName,
        color: (colors).first,
        id: id,
        displayName: displayName);
    await setDefault(profile);
  }

  Future<void> removeProfile(int id) async {
    await _db.remove('profiles', id);
    await sinkProfiles();
  }

  Future<void> setDefault(Profile profile) async {
    List<Profile> profiles = await getAllProfiles();
    profiles.forEach((p) {
      if (p.isDefault) {
        p.isDefault = !p.isDefault;
        _db.update('profiles', p.toJson());
      }
    });
    _db.remove('profiles', profile.id);
    profile.isDefault = true;
    _db.insert('profiles', profile.toJson());
    await sinkProfiles();
  }

  void closeControllers() {
    _profilesController.close();
  }
}
