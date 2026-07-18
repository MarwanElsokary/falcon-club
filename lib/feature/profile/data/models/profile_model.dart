import '../../../../core/networking/json.dart';
import '../../../../shared/domain/entities/gender.dart';
import '../../../../shared/domain/entities/profile.dart';
import '../../../../shared/domain/entities/subscription.dart';
import '../../../../shared/domain/entities/user_role.dart';

/// Parses `Club/GetProfile` (the current user's own account) into [Profile].
///
/// ## ✅ Verified against a live Scout-token capture
///
/// `{ "data": { "id", "isSubscribed": false, "accountNumber", "firstName",
/// "lastName", "email", "phoneNumber", "photo": null, "gender": "ذكر" } }`
///
/// * **gender** is an Arabic label → [Gender.fromArabic] (null when
///   null/unrecognised — never assumed male).
/// * the payload carries **no `remainingSubscriptionDays`**, so
///   [Subscription.isActive] reduces to `isSubscribed` here. It is still read
///   tolerantly (null when absent), so the days-check activates automatically if
///   the backend ever starts sending it.
/// * **[role]** is not in the payload; it is passed in from the stored session
///   by `ProfileRepositoryImpl`.
///
/// The capture came from a Scout token (the lean own-account shape); a Coach's
/// own profile is the same endpoint and shape. Every field is read tolerantly,
/// so an absent field degrades to null rather than throwing.
abstract final class ProfileModel {
  const ProfileModel._();

  static Profile fromJson(Map<String, dynamic> json, {required UserRole role}) {
    final Map<String, dynamic> data = Json.asObject(json['data']);

    return Profile(
      id: Json.asString(data['id']) ?? '',
      firstName: Json.asString(data['firstName']) ?? '',
      lastName: Json.asString(data['lastName']) ?? '',
      role: role,
      email: Json.asString(data['email']),
      phone: Json.asString(data['phoneNumber']),
      photoUrl: Json.asString(data['photo']),
      gender: Gender.fromArabic(Json.asString(data['gender'])),
      accountNumber: Json.asString(data['accountNumber']),
      subscription: Subscription(
        isPurchased: Json.asBool(data['isSubscribed']) ?? false,
        remainingDays: Json.asInt(data['remainingSubscriptionDays']),
      ),
      isProfileCompleted: Json.asBool(data['isCompleted']) ?? true,
    );
  }
}
