/// Defines the two supported user types in the app.
///
/// - [club]: Full club experience (team management, invitations, reports, etc.)
/// - [scout]: Independent scout with limited access (no team, no invitations)
enum UserType {
  club,
  scout;

  /// Convert enum to string for storage/API.
  String toValue() => name;

  /// Parse a string back to [UserType]. Defaults to [club] if unknown.
  static UserType fromValue(String? value) {
    if (value == null || value.isEmpty) return UserType.club;
    return UserType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => UserType.club,
    );
  }

  /// Arabic display name for UI.
  String get displayName {
    switch (this) {
      case UserType.club:
        return 'نادي';
      case UserType.scout:
        return 'كشاف مستقل';
    }
  }

  /// Whether this user type has access to team management.
  bool get hasTeamAccess => this == UserType.club;

  /// Whether this user type can send invitations.
  bool get canSendInvitations => this == UserType.club;
}
