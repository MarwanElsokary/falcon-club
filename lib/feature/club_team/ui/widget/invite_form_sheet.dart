import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/feature/club_team/ui/screen/invite_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shows the invite form as a draggable bottom sheet.
void showInviteFormSheet(BuildContext context, {required String playerName}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => InviteFormSheet(playerName: playerName),
  );
}

class InviteFormSheet extends StatefulWidget {
  final String playerName;

  const InviteFormSheet({super.key, required this.playerName});

  @override
  State<InviteFormSheet> createState() => _InviteFormSheetState();
}

class _InviteFormSheetState extends State<InviteFormSheet> {
  final _formKey = GlobalKey<FormState>();

  final _locationController = TextEditingController();
  final _coachNameController = TextEditingController();
  final _notesController = TextEditingController();
  final _extraNotesController = TextEditingController();

  DateTime? _selectedDate;

  @override
  void dispose() {
    _locationController.dispose();
    _coachNameController.dispose();
    _notesController.dispose();
    _extraNotesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(
          context,
        ).copyWith(colorScheme: ColorScheme.light(primary: mainColor)),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('يرجى اختيار تاريخ الدعوة'.tr()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    Navigator.of(context).pop(); // Close sheet
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => const InviteSuccessScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Drag indicator ───────────────────────────────────────
                SizedBox(height: 12.h),
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(height: 20.h),

                // ── Title ────────────────────────────────────────────────
                Text(
                  'ارسال دعوة'.tr(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  widget.playerName,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 24.h),

                // ── موقع النادي ──────────────────────────────────────────
                _buildField(
                  controller: _locationController,
                  label: 'موقع النادي'.tr(),
                  hint: 'أدخل موقع النادي'.tr(),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'مطلوب'.tr() : null,
                ),
                SizedBox(height: 14.h),

                // ── التاريخ ──────────────────────────────────────────────
                GestureDetector(
                  onTap: _pickDate,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.white70,
                          size: 18.w,
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          _selectedDate != null
                              ? DateFormat('yyyy/MM/dd').format(_selectedDate!)
                              : 'التاريخ'.tr(),
                          style: TextStyle(
                            color: _selectedDate != null
                                ? Colors.white
                                : Colors.white54,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 14.h),

                // ── ملاحظات ──────────────────────────────────────────────
                _buildField(
                  controller: _notesController,
                  label: 'ملاحظات'.tr(),
                  hint: 'أضف ملاحظاتك هنا'.tr(),
                  maxLines: 3,
                ),
                SizedBox(height: 14.h),

                // ── اسم المدرب ───────────────────────────────────────────
                _buildField(
                  controller: _coachNameController,
                  label: 'اسم المدرب'.tr(),
                  hint: 'أدخل اسم المدرب'.tr(),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'مطلوب'.tr() : null,
                ),
                SizedBox(height: 14.h),

                // ── ملاحظات إضافية ────────────────────────────────────────
                _buildField(
                  controller: _extraNotesController,
                  label: 'ملاحظات إضافية'.tr(),
                  hint: 'أي معلومات إضافية'.tr(),
                  maxLines: 2,
                ),
                SizedBox(height: 28.h),

                // ── Submit button ────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: mainColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    child: Text(
                      'تأكيد و ارسال'.tr(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: mainColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          style: TextStyle(color: Colors.white, fontSize: 14.sp),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white54, fontSize: 13.sp),
            filled: true,
            fillColor: Colors.white.withOpacity(0.12),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 12.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: Colors.white.withOpacity(0.6),
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
            errorStyle: const TextStyle(color: Colors.yellowAccent),
          ),
        ),
      ],
    );
  }
}
