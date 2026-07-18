import 'package:equatable/equatable.dart';

/// State of the self-profile edit submission.
///
/// Form field values live on [ProfileEditCubit] (controllers + selected gender +
/// picked image); this models only the async submit lifecycle the sheet reacts
/// to. Kept separate from the display `ProfileState` — editing and viewing are
/// two responsibilities.
sealed class ProfileEditState extends Equatable {
  const ProfileEditState();

  @override
  List<Object?> get props => <Object?>[];
}

final class ProfileEditInitial extends ProfileEditState {
  const ProfileEditInitial();
}

final class ProfileEditSubmitting extends ProfileEditState {
  const ProfileEditSubmitting();
}

final class ProfileEditSuccess extends ProfileEditState {
  const ProfileEditSuccess();
}

final class ProfileEditFailure extends ProfileEditState {
  const ProfileEditFailure(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
