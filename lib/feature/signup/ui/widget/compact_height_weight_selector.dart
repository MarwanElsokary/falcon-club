// file name: wheel_slider_selector.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:falconclubapp/core/thems/thems.dart';

class WheelSliderSelector extends StatefulWidget {
  final String label;
  final int initialValue;
  final ValueChanged<int> onValueChanged;
  final String buttonText;
  final Color buttonColor;
  final VoidCallback onButtonPressed;

  const WheelSliderSelector({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onValueChanged,
    required this.buttonText,
    required this.buttonColor,
    required this.onButtonPressed,
  });

  @override
  State<WheelSliderSelector> createState() => _WheelSliderSelectorState();
}

class _WheelSliderSelectorState extends State<WheelSliderSelector> {
  late FixedExtentScrollController _scrollController;
  late int _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
    _scrollController = FixedExtentScrollController(
      initialItem: _selectedValue - _getMinValue(),
    );
  }

  int _getMinValue() {
    if (widget.label.toLowerCase() == 'سم' || widget.label.toLowerCase() == 'cm') {
      return 100; // الحد الأدنى للطول
    } else if (widget.label.toLowerCase() == 'كجم' || widget.label.toLowerCase() == 'kg') {
      return 40; // الحد الأدنى للوزن
    }
    return 0;
  }

  int _getMaxValue() {
    if (widget.label.toLowerCase() == 'سم' || widget.label.toLowerCase() == 'cm') {
      return 250; // الحد الأقصى للطول
    } else if (widget.label.toLowerCase() == 'كجم' || widget.label.toLowerCase() == 'kg') {
      return 200; // الحد الأقصى للوزن
    }
    return 100;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // البكرة (Wheel)
        _buildWheelPicker(),

        SizedBox(height: 40.h),

        // زر التالي
        _buildNextButton(),
      ],
    );
  }

  Widget _buildWheelPicker() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // المؤشر المركزي
        Container(
          width: 220.w,
          height: 60.h,
          decoration: BoxDecoration(
            color: mainColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: mainColor.withOpacity(0.3),
              width: 1.5,
            ),
          ),
        ),

        // العجلة
        Container(
          height: 180.h,
          child: Row(
            children: [
              Expanded(
                child: ListWheelScrollView(
                  controller: _scrollController,
                  itemExtent: 60.h,
                  perspective: 0.005,
                  diameterRatio: 1.8,
                  physics: const BouncingScrollPhysics(),
                  onSelectedItemChanged: (index) {
                    final value = index + _getMinValue();
                    setState(() {
                      _selectedValue = value;
                    });
                    widget.onValueChanged(value);
                  },
                  children: List.generate(
                    _getMaxValue() - _getMinValue() + 1,
                        (index) {
                      final value = index + _getMinValue();
                      final isSelected = value == _selectedValue;

                      return Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 16.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            color: isSelected ? mainColor.withOpacity(0.2) : Colors.transparent,
                          ),
                          child: Text(
                            '$value',
                            style: TextStyle(
                              fontSize: isSelected ? 32.sp : 26.sp,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // التسمية
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ),
            ],
          ),
        ),

        // الخطوط الجانبية
        Positioned(
          left: 30.w,
          child: Icon(
            Icons.chevron_left,
            size: 28.sp,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
        Positioned(
          right: 70.w,
          child: Icon(
            Icons.chevron_right,
            size: 28.sp,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildNextButton() {
    return ElevatedButton(
      onPressed: widget.onButtonPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.buttonColor,
        foregroundColor: widget.buttonColor == Colors.white ? Colors.black : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.r),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 60.w,
          vertical: 18.h,
        ),
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.3),
      ),
      child: Text(
        widget.buttonText,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}