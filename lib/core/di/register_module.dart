import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../networking/api_service.dart';
import '../networking/dio_factory.dart';

/// Supplies third-party objects that injectable cannot construct itself
/// (no annotated constructor to read).
///
/// DIP: this is the composition root's adapter for external packages. It is the
/// only place `SharedPreferences`, `FlutterSecureStorage`, `Dio`, and
/// `ApiService` are instantiated; every consumer above depends on an
/// abstraction instead.
///
/// ## Strangler step
///
/// [dio] and [apiService] moved here *out of* the legacy `setupGetIt()`. They
/// are registered on the same [GetIt] instance and with the same lifetimes
/// (`lazySingleton`), so the ~20 legacy repositories that resolve
/// `getIt<ApiService>()` keep working untouched. The difference is that
/// injectable now *owns* them, which is what lets annotated data sources take
/// `ApiService` as a constructor dependency.
///
/// [dio] still comes from `DioFactory` for now — replacing that (it holds a
/// global mutable `static Dio?` and a 401 refresh pointing at a foreign host)
/// is a separate, deliberate change, not a side effect of wiring DI.
@module
abstract class RegisterModule {
  /// `preResolve` makes injectable await this during `configureDependencies()`,
  /// so consumers receive a ready instance rather than a `Future`.
  @preResolve
  @lazySingleton
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();

  /// ⚠️ Must use the **default** Android options — do not add
  /// `encryptedSharedPreferences: true`.
  ///
  /// `AndroidOptions(encryptedSharedPreferences: true)` selects a *different
  /// storage backend* (AndroidX `EncryptedSharedPreferences`) from the default
  /// one. The legacy `SharedPrefHelper` — which `DioFactory`'s auth interceptor
  /// calls on **every request** to fetch the bearer token — constructs a plain
  /// `const FlutterSecureStorage()`, i.e. the default backend.
  ///
  /// Configuring this differently means the session layer writes the token to
  /// one store while `DioFactory` reads from another: login "succeeds", nothing
  /// is found on the next request, and every authenticated call 401s. The keys
  /// matching (see [StorageKeys]) is not enough — the *backend* has to match too.
  ///
  /// Both move to the hardened backend together, once nothing outside the
  /// session layer touches storage.
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  @lazySingleton
  Dio get dio => DioFactory.getDio();

  @lazySingleton
  ApiService apiService(Dio dio) => ApiService(dio);
}
