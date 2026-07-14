/// The three roles that can authenticate.
///
/// Note there is deliberately no `player` case: a Player is *viewed* data, not
/// a session identity. Players are represented by the [Player] entity and read
/// via read-only use cases; they never log in.
///
/// OCP: behaviour that varies by role is expressed as members on this enum
/// (see [homeRoute] and the capability getters) rather than as `switch` /
/// `if (role == 'Scout')` chains scattered across the app. Adding a role means
/// adding a case here and letting the compiler point at every exhaustive switch
/// that must be updated — instead of hunting for string comparisons.
///
/// This replaces three *contradictory* hand-rolled dispatchers
/// (`login_screen`, `login_button_widget`, `splash_screen`), which each
/// re-derived the role→route mapping and disagreed for `Club`.
enum UserRole {
  club(apiValue: 'Club'),
  scout(apiValue: 'Scout'),
  mainClub(apiValue: 'MainClub');

  const UserRole({required this.apiValue});

  /// The exact string the backend uses. Kept here so no other file hard-codes
  /// `'Scout'` / `'MainClub'` literals.
  final String apiValue;

  /// Strict parse: `null` when the backend sent a role this app cannot host.
  ///
  /// **Use this at the sign-in boundary.** The backend also issues the role
  /// `Player`, and players are not users of this app — the current login code
  /// blocks them explicitly. [fromApiValue] would quietly map `Player` to
  /// [UserRole.club] and let them into the Club shell, so authentication must
  /// use this method and refuse a `null`.
  static UserRole? tryFromApiValue(String? value) {
    if (value == null || value.isEmpty) return null;
    for (final UserRole role in UserRole.values) {
      if (role.apiValue == value) return role;
    }
    return null;
  }

  /// Lenient parse, for reading a role this app has **already accepted** and
  /// persisted. Falls back to [UserRole.club], preserving today's
  /// `UserRoleHelper` behaviour for stored values.
  ///
  /// Never use this on a login response — see [tryFromApiValue].
  static UserRole fromApiValue(String? value) =>
      tryFromApiValue(value) ?? UserRole.club;

  bool get canReviewJoinRequests => this == UserRole.mainClub;

  bool get canManageTeam => this == UserRole.club || this == UserRole.mainClub;

  bool get canUploadPlayerAttempts => this == UserRole.club;

  bool get canBrowseFavorites => this == UserRole.club;

  /// Scouts pay for access; clubs are onboarded by the main club.
  bool get requiresSubscription => this == UserRole.scout;
}
