import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_terms_and_policies.dart';

/// The terms & privacy text shown at signup.
///
/// Separate from [RegistrationCubit] on purpose: fetching legal copy is not
/// registering an account, and a screen that renders the terms dialog has no
/// business holding something that can also call `register()`.
///
/// ## Failing to load must not block signup
///
/// If the request fails, the user can still tick the box and register — they are
/// simply shown a fallback message in place of the text. Making consent
/// impossible because a GET failed would be a worse outcome than showing the
/// terms from a cached/known source. The **checkbox is still mandatory**; only
/// the *display* degrades.
@injectable
class TermsCubit extends Cubit<TermsState> {
  TermsCubit(this._getTermsAndPolicies) : super(const TermsState());

  final GetTermsAndPolicies _getTermsAndPolicies;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    final result = await _getTermsAndPolicies();
    emit(
      result.fold(
        (Failure failure) =>
            TermsState(isLoading: false, errorMessage: failure.message),
        (List<String> paragraphs) =>
            TermsState(isLoading: false, paragraphs: paragraphs),
      ),
    );
  }
}

final class TermsState extends Equatable {
  const TermsState({
    this.paragraphs = const <String>[],
    this.isLoading = false,
    this.errorMessage,
  });

  final List<String> paragraphs;
  final bool isLoading;
  final String? errorMessage;

  bool get hasText => paragraphs.isNotEmpty;

  TermsState copyWith({
    List<String>? paragraphs,
    bool? isLoading,
    String? errorMessage,
  }) => TermsState(
    paragraphs: paragraphs ?? this.paragraphs,
    isLoading: isLoading ?? this.isLoading,
    errorMessage: errorMessage ?? this.errorMessage,
  );

  @override
  List<Object?> get props => [paragraphs, isLoading, errorMessage];
}
