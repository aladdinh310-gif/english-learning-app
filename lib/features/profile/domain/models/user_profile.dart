class UserProfile {
  const UserProfile({
    required this.displayName,
    required this.email,
    required this.avatarIndex,
  });

  final String displayName;
  final String email;
  final int avatarIndex;

  UserProfile copyWith({String? displayName, String? email, int? avatarIndex}) {
    return UserProfile(
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      avatarIndex: avatarIndex ?? this.avatarIndex,
    );
  }
}
