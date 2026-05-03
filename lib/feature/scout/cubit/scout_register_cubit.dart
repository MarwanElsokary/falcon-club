import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../data/repo/scout_repo.dart';

// ── State ─────────────────────────────────────────────────────────────────────
abstract class ScoutRegisterState {}

class ScoutRegisterInitial extends ScoutRegisterState {}

class ScoutRegisterLoading extends ScoutRegisterState {}

class ScoutRegisterSuccess extends ScoutRegisterState {}

class ScoutRegisterError extends ScoutRegisterState {
  final String error;
  ScoutRegisterError(this.error);
}

// ── Cubit ─────────────────────────────────────────────────────────────────────
class ScoutRegisterCubit extends Cubit<ScoutRegisterState> {
  final ScoutRepo _repo;

  ScoutRegisterCubit(this._repo) : super(ScoutRegisterInitial());

  // Form key + controllers
  final formKey = GlobalKey<FormState>();
  final firstNameCtrl  = TextEditingController();
  final lastNameCtrl   = TextEditingController();
  final emailCtrl      = TextEditingController();
  final phoneCtrl      = TextEditingController();
  final passwordCtrl   = TextEditingController();
  final confirmCtrl    = TextEditingController();

  int gender = 0; // 0 = ذكر, 1 = أنثى
  String imagePath = '';

  final showPassword = ValueNotifier<bool>(true);

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;

    emit(ScoutRegisterLoading());

    final result = await _repo.registerScout(
      firstName:   firstNameCtrl.text.trim(),
      lastName:    lastNameCtrl.text.trim(),
      email:       emailCtrl.text.trim(),
      phoneNumber: phoneCtrl.text.trim(),
      password:    passwordCtrl.text,
      gender:      gender,
      imagePath:   imagePath.isNotEmpty ? imagePath : null,
    );

    result.when(
      success: (_) => emit(ScoutRegisterSuccess()),
      failure: (err) =>
          emit(ScoutRegisterError(err.apiErrorModel.message ?? 'حدث خطأ')),
    );
  }

  @override
  Future<void> close() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    passwordCtrl.dispose();
    confirmCtrl.dispose();
    showPassword.dispose();
    return super.close();
  }
}