import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

/// The composition root for the Clean Architecture stack.
///
/// DIP, enforced by the container: implementations are bound to their
/// interfaces via `@LazySingleton(as: SomeInterface)`, so a cubit or use case
/// can only ever resolve the *abstraction*. The concrete class is never named
/// above the data layer.
///
/// This replaces 42 hand-written `getIt.registerX(...)` calls in
/// `dependency_injection.dart`, several of which were untyped
/// (`registerLazySingleton(() => RequestsRepo(...))`) and therefore resolved by
/// inference — a signature change would silently rebind them.
///
/// Migration note: this coexists with the legacy `setupGetIt()` on the same
/// [GetIt] instance during the transition. `RegisterModule` now owns `Dio` and
/// `ApiService`, so the legacy repositories keep resolving them unchanged.
/// Registrations move over feature by feature; when `setupGetIt()` is empty, it
/// is deleted.
///
/// Deliberately does not declare its own `getIt` variable: `dependency_injection.dart`
/// already exports one for the same [GetIt.instance], and two same-named
/// top-level symbols would be ambiguous in any file importing both.
@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() => GetIt.instance.init();
