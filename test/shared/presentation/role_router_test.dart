import 'package:falconclubapp/core/routing/routes.dart';
import 'package:falconclubapp/shared/domain/entities/user_role.dart';
import 'package:falconclubapp/shared/presentation/routing/role_router.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RoleRouter', () {
    // The three dispatchers this replaces disagreed:
    //   splash_screen.dart:203      Club -> clubMain   MainClub -> mainClub
    //   login_screen.dart:47        Club -> clubMain   MainClub -> clubMain   <-- wrong
    //   login_button_widget.dart:39 Club -> mainClub   MainClub -> mainClub   <-- wrong
    // and two of them fired at once on every login. These tests pin the one
    // correct mapping.
    test('a Club lands on the Club shell', () {
      expect(
        RoleRouter.homeRouteFor(UserRole.club),
        AppRoute.clubMainScreen,
      );
    });

    test('a Main Club lands on the Main Club shell, not the Club shell', () {
      expect(
        RoleRouter.homeRouteFor(UserRole.mainClub),
        AppRoute.mainClubScreen,
      );
    });

    test('a Scout lands on the Scout shell', () {
      expect(
        RoleRouter.homeRouteFor(UserRole.scout),
        AppRoute.scoutMainScreen,
      );
    });

    test('every role has a distinct home', () {
      final Set<String> routes = UserRole.values
          .map(RoleRouter.homeRouteFor)
          .toSet();

      expect(routes, hasLength(UserRole.values.length));
    });
  });
}
