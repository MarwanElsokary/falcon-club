/// Centralised, user-facing failure text.
///
/// SRP: its single reason to change is a copy/wording change.
/// Clean Code: eliminates magic strings — every [Failure] message is a named
/// constant here rather than a literal scattered across repositories.
abstract final class FailureMessages {
  const FailureMessages._();

  static const String noInternetConnection = 'لا يوجد اتصال بالإنترنت';
  static const String requestTimedOut = 'انتهت مهلة الاتصال، حاول مرة أخرى';
  static const String serverUnreachable = 'تعذر الوصول إلى الخادم';
  static const String unexpectedServerResponse = 'استجابة غير متوقعة من الخادم';
  static const String sessionExpired = 'انتهت صلاحية الجلسة، سجّل الدخول مجددًا';
  static const String accessDenied = 'ليس لديك صلاحية لتنفيذ هذا الإجراء';
  static const String resourceNotFound = 'العنصر المطلوب غير موجود';
  static const String requestCancelled = 'تم إلغاء الطلب';
  static const String cacheReadFailed = 'تعذر قراءة البيانات المحفوظة';
  static const String cacheWriteFailed = 'تعذر حفظ البيانات محليًا';
  static const String unknown = 'حدث خطأ غير متوقع';
}
