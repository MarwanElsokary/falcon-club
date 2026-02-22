import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../enums/user_type.dart';
import '../helpers/constants.dart';
import '../helpers/shared_pref_helper.dart';

/// Global cubit that manages the current user type (club or scout).
///
/// This cubit is provided at the app root level so that any screen
/// can read the user type and adapt its UI accordingly.
class UserTypeCubit extends Cubit<UserType> {
  UserTypeCubit() : super(UserType.club);

  /// Load the user type from SharedPreferences on app start.
  Future<void> loadUserType() async {
    final stored = await SharedPrefHelper.getString(SharedPrefKeys.userType);
    final userType = UserType.fromValue(stored);
    log('🔍 UserTypeCubit: loaded userType = ${userType.name}');
    emit(userType);
  }

  /// Set the user type and persist it to SharedPreferences.
  Future<void> setUserType(UserType type) async {
    await SharedPrefHelper.setData(SharedPrefKeys.userType, type.toValue());
    log('✅ UserTypeCubit: saved userType = ${type.name}');
    emit(type);
  }

  /// Check if the current user is a club user.
  bool get isClub => state == UserType.club;

  /// Check if the current user is an independent scout.
  bool get isScout => state == UserType.scout;
}
