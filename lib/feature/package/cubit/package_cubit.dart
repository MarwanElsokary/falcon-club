import 'package:bloc/bloc.dart';
import 'package:falconclubapp/feature/package/cubit/package_state.dart';
import 'package:falconclubapp/feature/package/data/model/pakcage_model.dart';
import 'package:flutter/material.dart';

import '../controller/package_controller.dart';
import '../data/repo/package_repo.dart';

class PackageCubit extends Cubit<PackageState> {
  final PackageRepo _repo;
  PackageCubit(this._repo) : super(PackageState.initial());

  PackageController controller = PackageController();
  final formKey = GlobalKey<FormState>();

  List<PackageModel> packageList = [];
  List<String> termsAndPolicies = []; // أضف هذا المتغير الجديد

  //



  // دالة جديدة لجلب الشروط والخصوصية
  Future<void> getTermsAndPolicies() async {
    final result = await _repo.getTermsAndPolicies();
    result.when(
      success: (data) {
        if (data is List) {
          termsAndPolicies = List<String>.from(data);
        } else if (data is String) {
          termsAndPolicies = [data];
        }
        // لا نحتاج لإرسال state لأننا نستخدمها فقط للعرض
      },
      failure: (error) {
        // يمكن تجاهل الخطأ أو التعامل معه حسب الحاجة
        print('Failed to load terms and policies: $error');
      },
    );
  }
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

  Future<void> emitpayPackageStates({required int packageId}) async {
    emit(const PackageState.payPackageloading());

    // `MM/YY` — indexing [1] blind threw RangeError on any expiry without a
    // slash, which only the form's validator was preventing.
    final List<String> expiry = controller.expireData.text.split('/');
    final String expiryMonth = expiry.isNotEmpty ? expiry[0].trim() : '';
    final String expiryYear = expiry.length > 1 ? expiry[1].trim() : '';

    final result = await _repo.payPackage(
      payPackageBody: {
        'packageId': packageId,
        'cardName': controller.cardName.text,
        'cardNumber': controller.cardNumber.text,
        'expiryMonth': expiryMonth,
        'expiryYear': expiryYear,
        'cvv': controller.cvv.text,
      },
    );

    result.when(
      success: (data) {
        // أرسل الـ response كامل
        emit(PackageState.payPackagesuccess(response: data));
      },
      failure: (error) {
        emit(PackageState.payPackageerror(error: error.apiErrorModel.message ?? 'حدث خطأ'));
      },
    );
  }

// دالة جديدة للتحقق من الدفع بعد الـ verification
  Future<void> verifyPayment({required int packageId}) async {
    // اعمل API call للتحقق من نجاح الدفع
    final result = await _repo.verifyPaymentStatus(packageId: packageId);

    result.when(
      success: (data) {
        if (data['success'] == true) {
          // الدفع نجح
          return;
        } else {
          throw Exception('Payment verification failed');
        }
      },
      failure: (error) {
        throw Exception(error.apiErrorModel.message ?? 'فشل التحقق من الدفع');
      },
    );
  }


}
