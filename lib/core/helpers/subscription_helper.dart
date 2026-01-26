// subscription_helper.dart
import 'package:falcon/core/cache/cach_Helper.dart';

bool isActiveSubscription() {
  final profile = CacheHelper.getmyProfile();
  if (profile == null) return false;
  return profile.data.isSubscribed == true &&
      (profile.data.remainingSubscriptionDays ?? 0) > 0;
}