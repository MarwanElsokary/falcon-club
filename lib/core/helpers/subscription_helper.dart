// subscription_helper.dart
import 'package:falconclubapp/core/cache/cach_Helper.dart';

// مش هتتغير — بس دلوقتي هتقرأ داتا fresh دايماً
bool isActiveSubscription() {
  final profile = CacheHelper.getmyProfile();
  if (profile == null) return false;

  // 🔥 لو remainingSubscriptionDays مش موجودة (Club)، نعتمد على isSubscribed بس
  final isSubscribed = profile.data.isSubscribed == true;
  final days = profile.data.remainingSubscriptionDays;

  // لو days موجودة نتحقق منها، لو null نعتمد على isSubscribed بس
  if (days == null) return isSubscribed;
  return isSubscribed && (days as num) > 0;
}
