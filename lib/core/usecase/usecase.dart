import 'package:fpdart/fpdart.dart';

import '../error/failures.dart';

/// Every fallible operation in the app returns this.
///
/// Replaces the old untyped `Future<ApiResult>` (i.e. `ApiResult<dynamic>`),
/// which forced callers to index raw maps (`data['status']`) and gave the type
/// system nothing to check. `Either` makes the failure path part of the
/// signature — a caller cannot reach the success value without handling the
/// failure first.
typedef ResultFuture<T> = Future<Either<Failure, T>>;

/// For operations whose success carries no value (delete, accept, reject).
typedef ResultVoid = ResultFuture<void>;

/// A single business operation, invocable as a function.
///
/// SRP: one use case = one verb = one reason to change. This is the unit that
/// replaces the god cubits — `LoginCubit`'s ten responsibilities become ten
/// use cases, each independently testable without a widget tree.
///
/// DIP: use cases live in `domain` and depend only on repository *interfaces*
/// also declared in `domain`. The concrete repository in `data` implements
/// them. Dependencies therefore point inward, toward the domain.
///
/// ISP: the interface is exactly one method. Nothing that consumes a use case
/// is forced to know about anything else.
abstract interface class UseCase<Output, Input> {
  ResultFuture<Output> call(Input input);
}

/// Same contract for operations that genuinely take no input.
///
/// This is why there is no `NoParams` marker type: an interface should not
/// demand an argument that carries no information (ISP). A second interface is
/// cheaper than a placeholder every caller has to construct and every reader has
/// to ignore.
abstract interface class UseCaseWithoutInput<Output> {
  ResultFuture<Output> call();
}
