class UserProfile {
  const UserProfile({
    required this.fullName,
    required this.headline,
    this.bio,
  });

  final String fullName;
  final String headline;
  final String? bio;

  factory UserProfile.fromSettingsJson(Map<String, dynamic> json) {
    final profile = json['profile'] as Map<String, dynamic>? ?? {};
    return UserProfile(
      fullName: (profile['fullName'] as String?) ?? '',
      headline: (profile['headline'] as String?) ?? '',
      bio: profile['bio'] as String?,
    );
  }
}

class AiSettings {
  const AiSettings({
    required this.mentorMode,
    this.hasApiKey = false,
  });

  final String mentorMode; // off | managed | byok
  final bool hasApiKey;

  factory AiSettings.fromJson(Map<String, dynamic> json) {
    return AiSettings(
      mentorMode: (json['mentorMode'] as String?) ?? 'off',
      hasApiKey: json['hasApiKey'] == true,
    );
  }
}
