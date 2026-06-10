import '../../data/model/user_role.dart';

class DrawerPermissions {
  static bool canShowProfile(UserRole role) {
    return role == UserRole.club || role == UserRole.scout;
  }

  static bool clubInfoScreen(UserRole role) {
    return role == UserRole.mainClub;
  }

  static bool canShowMyTeam(UserRole role) {
    return role == UserRole.mainClub;
  }

  static bool canShowRank(UserRole role) {
    return role == UserRole.club ||
        role == UserRole.scout ||
        role == UserRole.mainClub;
  }

  static bool canShowExperiments(UserRole role) {
    return role == UserRole.club ||
        role == UserRole.mainClub ||
        role == UserRole.scout;
  }

  static bool canShowTraining(UserRole role) {
    return true;
  }

  static bool canShowNotifications(UserRole role) {
    return true;
  }

  static bool canDeleteAccount(UserRole role) {
    return role != UserRole.mainClub;
  }
}
