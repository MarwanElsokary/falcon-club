import 'package:bloc/bloc.dart';
import 'package:falcon/feature/package/cubit/package_state.dart';
import 'package:falcon/feature/package/data/model/pakcage_model.dart';
import 'package:flutter/material.dart';

import '../controller/package_controller.dart';
import '../data/repo/package_repo.dart';

class PackageCubit extends Cubit<PackageState> {
  final PackageRepo _repo;
  PackageCubit(this._repo) : super(PackageState.initial());

  PackageController controller = PackageController();
  final formKey = GlobalKey<FormState>();

  List<PackageModel> packageList = [];
  //

  // MARK: -allPackagesState
  void emitAllPackagesState() async {
    emit(const PackageState.packageloading());
    final response = await _repo.allPackages();
    response.when(
      success: (strongOfferResponse) async {
        packageList.clear();
        packageList = strongOfferResponse
            .map<PackageModel>((e) => PackageModel.fromJson(e))
            .toList();

        emit(PackageState.packagesuccess());
      },
      failure: (error) {
        emit(
          PackageState.packageerror(error: error.apiErrorModel.message ?? ''),
        );
      },
    );
  }

  // MARK: -allPackagesState
  void emitpayPackageStates({required int packageId}) async {
    emit(const PackageState.payPackageloading());
    final response = await _repo.payPackage(
      payPackageBody: {
        "packageId": packageId,
        "cardName": controller.cardName.text,
        "cardNumber": controller.cardNumber.text,
        "expiryMonth": controller.expireData.text.toString().substring(0, 2),
        "expiryYear": controller.expireData.text.toString().substring(3),
        "cvv": controller.cvv.text,
      },
    );
    response.when(
      success: (loginResponse) async {
        emit(PackageState.payPackagesuccess());
      },
      failure: (error) {
        emit(
          PackageState.payPackageerror(
            error: error.apiErrorModel.message ?? '',
          ),
        );
      },
    );
  }
}
