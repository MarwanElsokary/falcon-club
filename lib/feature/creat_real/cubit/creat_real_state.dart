// import 'package:freezed_annotation/freezed_annotation.dart';
//
// part 'creat_real_state.freezed.dart';
//
// @freezed
// class CreatRealState with _$CreatRealState {
//   const factory CreatRealState.initial() = _Initial;
//
//   const factory CreatRealState.creatRealLoading() = CreatRealLoading;
//
//   // 🔥 التحسينات هنا:
//   // 1. إضافة uploadProgress بدل progress العادي
//   // 2. إضافة isCompressing عشان نفرق بين الضغط والرفع
//   // 3. إضافة uploadedBytes و totalBytes عشان نعرض الحجم بالتفصيل
//   // 4. كل المعلومات دي هتساعدك تعرض UI أفضل للمستخدم
//   const factory CreatRealState.creatRealProgress({
//     required int uploadProgress, // النسبة المئوية (0-100)
//     required bool isCompressing, // true = بيضغط، false = بيرفع
//     required int uploadedBytes, // حجم البيانات المرفوعة
//     required int totalBytes, // الحجم الكلي
//   }) = CreatRealProgress;
//
//   const factory CreatRealState.creatRealsuccess() = CreatRealSuccess;
//
//   const factory CreatRealState.creatRealerror({required String error}) =
//       CreatRealError;
// }
