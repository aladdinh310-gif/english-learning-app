import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/models/user_profile.dart';

class ProfileData extends ChangeNotifier {
  ProfileData._() : _profile = _defaultProfile() {
    _load();
  }

  static final ProfileData instance = ProfileData._();

  UserProfile _profile;

  UserProfile get profile => _profile;

  static UserProfile _defaultProfile() {
    return const UserProfile(
      displayName: 'Ali',
      email: 'ali@example.com',
      avatarIndex: 0,
    );
  }

  Future<void> _load() async {
    final preferences = await SharedPreferences.getInstance();
    _profile = _profile.copyWith(
      displayName: preferences.getString('profile.displayName'),
      avatarIndex: preferences.getInt('profile.avatarIndex'),
    );
    notifyListeners();
  }

  Future<void> updateProfile({
    required String displayName,
    required int avatarIndex,
  }) async {
    final trimmedName = displayName.trim();
    if (trimmedName.isEmpty) {
      throw ArgumentError('Display name cannot be empty.');
    }
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('profile.displayName', trimmedName);
    await preferences.setInt('profile.avatarIndex', avatarIndex);
    _profile = _profile.copyWith(
      displayName: trimmedName,
      avatarIndex: avatarIndex,
    );
    notifyListeners();
  }
}
