import '../entities/exercise_capability.dart';

/// Answers "what may the person currently using this app do with an exercise?".
///
/// Synchronous on purpose. The role and the subscription are already on the
/// device — they were written at sign-in and when the profile last loaded — so
/// resolving a capability is a lookup, not I/O. Making it a `Future` would force
/// every widget that needs to decide whether to *render* a button into an async
/// build, which is how permission checks end up being skipped "just for now".
///
/// A capability must be cheap enough that there is never an excuse not to ask.
abstract interface class ViewerCapabilityPort {
  ExerciseCapability current();
}
