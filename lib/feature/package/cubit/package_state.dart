import 'package:freezed_annotation/freezed_annotation.dart';
part 'package_state.freezed.dart';

@freezed
class PackageState with _$PackageState {
  const factory PackageState.initial() = _Initial;

  const factory PackageState.packageloading() = packageLoading;
  const factory PackageState.packagesuccess() = packageSuccess;
  const factory PackageState.packageerror({required String error}) =
      packageError;

  //
  const factory PackageState.payPackageloading() = payPackageLoading;
  const factory PackageState.payPackagesuccess() = payPackageSuccess;
  const factory PackageState.payPackageerror({required String error}) =
      payPackageError;
}
