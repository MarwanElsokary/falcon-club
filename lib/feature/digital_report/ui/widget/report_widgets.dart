import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ══════════════════════════════════════════════════════════════════════════════
// _PageWrapper — غلاف كل صفحة من الـ 6 صفحات
// ══════════════════════════════════════════════════════════════════════════════
class PageWrapper extends StatelessWidget {
  final int sectionNumber;
  final String sectionTitle;
  final Widget child;

  const PageWrapper({
    super.key,
    required this.sectionNumber,
    required this.sectionTitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Section header ────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: mainColor,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                children: [
                  // عنوان القسم
                  Expanded(
                    child: Text(
                      sectionTitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  // رقم القسم
                  Container(
                    width: 28.w,
                    height: 28.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$sectionNumber',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            verticalSpace(12),

            // ── Column headers ────────────────────────────────────────────
            Row(
              children: ['ممتاز\n(5)', 'جيد جداً\n(4)', 'جيد\n(3)', 'عادي\n(2)', 'ضعيف\n(1)']
                  .map((t) => Expanded(
                child: Text(
                  t,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 8.sp,
                    color: greyClr,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
              ))
                  .toList(),
            ),
            verticalSpace(8),

            child,
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// RatingRow — صف تقييم واحد (1-5) مع ملاحظات اختيارية
// ══════════════════════════════════════════════════════════════════════════════
class RatingRow extends StatelessWidget {
  final String label;
  final String? labelEn;
  final String emoji;
  final int value;
  final ValueChanged<int> onChanged;
  final TextEditingController? notes;
  final bool highlight;

  const RatingRow({
    super.key,
    required this.label,
    this.labelEn,
    required this.emoji,
    required this.value,
    required this.onChanged,
    this.notes,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: highlight ? mainColor.withOpacity(0.06) : fillColor,
        borderRadius: BorderRadius.circular(12.r),
        border: highlight
            ? Border.all(color: mainColor.withOpacity(0.25), width: 1.5)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Label ──────────────────────────────────────────────────────
          Row(
            children: [
              Text(emoji, style: TextStyle(fontSize: 15.sp)),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: highlight ? mainColor : Colors.black87,
                  ),
                ),
              ),
              if (labelEn != null)
                Text(
                  labelEn!,
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: greyClr,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          verticalSpace(8),

          // ── Rating buttons 5→1 من اليمين لليسار ──────────────────────
          Directionality(
            textDirection: TextDirection.ltr, // الأزرار تبقى 5,4,3,2,1 من اليسار
            child: Row(
              children: List.generate(5, (i) {
                final v = 5 - i;
                final selected = value == v;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => onChanged(v),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      height: 38.h,
                      decoration: BoxDecoration(
                        color: selected ? mainColor : Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: selected
                              ? mainColor
                              : greyClr.withOpacity(0.25),
                        ),
                        boxShadow: selected
                            ? [
                          BoxShadow(
                            color: mainColor.withOpacity(0.25),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          )
                        ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          '$v',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: selected ? Colors.white : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          // ── Notes ──────────────────────────────────────────────────────
          if (notes != null) ...[
            verticalSpace(6),
            TextField(
              controller: notes,
              maxLines: 2,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 12.sp, color: Colors.black87),
              decoration: InputDecoration(
                hintText: 'ملاحظات...',
                hintStyle: TextStyle(fontSize: 11.sp, color: greyClr),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: greyClr.withOpacity(0.2)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: greyClr.withOpacity(0.2)),
                ),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 10.w, vertical: 8.h),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// NotesField — حقل ملاحظات عام في نهاية كل قسم
// ══════════════════════════════════════════════════════════════════════════════
class NotesField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const NotesField({
    super.key,
    required this.controller,
    this.hint = 'ملاحظات...',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 4.h, bottom: 8.h),
      child: TextField(
        controller: controller,
        maxLines: 3,
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        style: TextStyle(fontSize: 13.sp, color: Colors.black87),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: 12.sp, color: greyClr),
          filled: true,
          fillColor: fillColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Icon(
            Icons.chat_bubble_outline_rounded,
            color: greyClr,
            size: 18.w,
          ),
        ),
      ),
    );
  }
}