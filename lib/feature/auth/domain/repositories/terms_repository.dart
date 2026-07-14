import '../../../../core/usecase/usecase.dart';

/// The terms & privacy text shown at signup.
///
/// ISP: its own tiny port rather than another method on [AuthRepository].
/// Fetching legal copy is not authentication, and a screen that renders the
/// terms dialog has no business holding something that can also call
/// `register()`.
abstract interface class TermsRepository {
  /// The terms paragraphs, in display order. Empty when unavailable — the
  /// dialog degrades rather than blocking signup.
  ResultFuture<List<String>> getTermsAndPolicies();
}
