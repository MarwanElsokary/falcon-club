enum UserRole {
  scout,
  club,
  mainClub,
}

class UserRoleHelper {
  static UserRole getCurrentRole(String? role) {
    switch (role) {
      case 'Scout':
        return UserRole.scout;

      case 'MainClub':
        return UserRole.mainClub;

      default:
        return UserRole.club;
    }
  }
}