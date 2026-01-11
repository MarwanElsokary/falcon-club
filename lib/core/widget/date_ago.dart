import 'dart:developer';

/// دالة لتحويل التاريخ إلى صيغة "منذ..." بالعربية
String getTimeAgo(String dateString) {
  try {
    // تحويل النص إلى DateTime
    DateTime dateTime = DateTime.parse(dateString);

    // الحصول على الوقت الحالي
    DateTime now = DateTime.now();

    // حساب الفرق
    Duration difference = now.difference(dateTime);

    // تحويل الفرق إلى نص عربي
    if (difference.inSeconds < 60) {
      return 'الآن';
    } else if (difference.inMinutes < 60) {
      int minutes = difference.inMinutes;
      if (minutes == 1) {
        return 'منذ دقيقة';
      } else if (minutes == 2) {
        return 'منذ دقيقتين';
      } else if (minutes <= 10) {
        return 'منذ $minutes دقائق';
      } else {
        return 'منذ $minutes دقيقة';
      }
    } else if (difference.inHours < 24) {
      int hours = difference.inHours;
      if (hours == 1) {
        return 'منذ ساعة';
      } else if (hours == 2) {
        return 'منذ ساعتين';
      } else if (hours <= 10) {
        return 'منذ $hours ساعات';
      } else {
        return 'منذ $hours ساعة';
      }
    } else if (difference.inDays < 7) {
      int days = difference.inDays;
      if (days == 1) {
        return 'منذ يوم';
      } else if (days == 2) {
        return 'منذ يومين';
      } else if (days <= 10) {
        return 'منذ $days أيام';
      } else {
        return 'منذ $days يوم';
      }
    } else if (difference.inDays < 30) {
      int weeks = (difference.inDays / 7).floor();
      if (weeks == 1) {
        return 'منذ أسبوع';
      } else if (weeks == 2) {
        return 'منذ أسبوعين';
      } else if (weeks <= 10) {
        return 'منذ $weeks أسابيع';
      } else {
        return 'منذ $weeks أسبوع';
      }
    } else if (difference.inDays < 365) {
      int months = (difference.inDays / 30).floor();
      if (months == 1) {
        return 'منذ شهر';
      } else if (months == 2) {
        return 'منذ شهرين';
      } else if (months <= 10) {
        return 'منذ $months أشهر';
      } else {
        return 'منذ $months شهر';
      }
    } else {
      int years = (difference.inDays / 365).floor();
      if (years == 1) {
        return 'منذ سنة';
      } else if (years == 2) {
        return 'منذ سنتين';
      } else if (years <= 10) {
        return 'منذ $years سنوات';
      } else {
        return 'منذ $years سنة';
      }
    }
  } catch (e) {
    log('خطأ في تحويل التاريخ: $e');
    return 'غير محدد';
  }
}

/// نسخة مبسطة أكثر
String getTimeAgoSimple(String dateString) {
  try {
    DateTime dateTime = DateTime.parse(dateString);
    DateTime now = DateTime.now();
    Duration difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'الآن';
    } else if (difference.inMinutes < 60) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inHours < 24) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} يوم';
    } else if (difference.inDays < 30) {
      return 'منذ ${(difference.inDays / 7).floor()} أسبوع';
    } else if (difference.inDays < 365) {
      return 'منذ ${(difference.inDays / 30).floor()} شهر';
    } else {
      return 'منذ ${(difference.inDays / 365).floor()} سنة';
    }
  } catch (e) {
    return 'غير محدد';
  }
}
