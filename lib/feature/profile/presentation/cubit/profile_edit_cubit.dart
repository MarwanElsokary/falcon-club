import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../shared/domain/entities/gender.dart';
import '../../../../shared/domain/entities/profile.dart';
import '../../../../shared/domain/value_objects/phone_number.dart';
import '../../domain/entities/update_profile_params.dart';
import '../../domain/usecases/update_my_profile.dart';
import 'profile_edit_state.dart';

/// Owns the self-profile edit form and drives the save through [UpdateMyProfile].
///
/// Replaces `ClubTeamCubit.initProfileForm` / `emitUpdateProfile`, which held the
/// form on the god-cubit and hand-built the multipart. Two bugs are fixed here by
/// construction:
///
/// * **Gender.** [seed] takes the gender from the domain [Profile] (already
///   parsed from the Arabic read), so it preselects the real value instead of
///   defaulting to male. The save writes [Gender.apiValue]. When gender is
///   unknown the cubit refuses to guess — [submit] requires one to be chosen.
/// * **Photo.** [currentPhotoUrl] lets the sheet show the existing picture; a new
///   pick goes to [newImagePath] and only then is a `Photo` part sent.
@injectable
class ProfileEditCubit extends Cubit<ProfileEditState> {
  ProfileEditCubit(this._updateMyProfile) : super(const ProfileEditInitial());

  final UpdateMyProfile _updateMyProfile;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  /// The chosen gender, or null when the stored value was unknown and the coach
  /// has not picked one yet. Never silently defaulted.
  Gender? gender;

  /// The saved photo URL, shown as a preview until a new image is picked.
  String? currentPhotoUrl;

  /// A newly-picked local image path; null means "keep the current photo".
  String? newImagePath;

  /// Populates the form from the loaded profile. Called each time the sheet
  /// opens so it always reflects the latest display.
  void seed(Profile profile) {
    firstNameController.text = profile.firstName;
    lastNameController.text = profile.lastName;
    phoneController.text = profile.phone ?? '';
    gender = profile.gender;
    currentPhotoUrl = profile.photoUrl;
    newImagePath = null;
    // Reset only if a prior submit left a terminal state (sheet reopened);
    // a fresh cubit is already Initial, so this is a no-op in the common path.
    if (!isClosed && state is! ProfileEditInitial) {
      emit(const ProfileEditInitial());
    }
  }

  void selectGender(Gender value) => gender = value;

  void setImage(String path) => newImagePath = path;

  /// Submits the edit. The sheet validates names/phone/gender in the form first;
  /// the guards here are the domain's own last line — the phone is re-validated
  /// through the value object, and an unknown gender is refused rather than
  /// invented.
  Future<void> submit() async {
    final Gender? chosenGender = gender;
    if (chosenGender == null) {
      emit(const ProfileEditFailure('يرجى اختيار الجنس'));
      return;
    }

    final Either<ValidationFailure, PhoneNumber> phoneResult =
        PhoneNumber.forSaudiRegistration(phoneController.text);
    final PhoneNumber? phone = phoneResult.toNullable();
    if (phone == null) {
      emit(
        ProfileEditFailure(
          phoneResult.fold((failure) => failure.message, (_) => ''),
        ),
      );
      return;
    }

    emit(const ProfileEditSubmitting());

    final result = await _updateMyProfile(
      UpdateProfileParams(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        phone: phone,
        gender: chosenGender,
        imagePath: newImagePath,
      ),
    );
    if (isClosed) return;

    emit(
      result.match(
        (failure) => ProfileEditFailure(failure.message),
        (_) => const ProfileEditSuccess(),
      ),
    );
  }

  @override
  Future<void> close() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    return super.close();
  }
}
