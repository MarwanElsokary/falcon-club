// file name: height_weight_wheel_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeightWeightWheelWidget extends StatefulWidget {
  final String label;
  final String initialValue;
  final ValueChanged<String> onValueChanged;
  final bool isHeight; // true للطول, false للوزن

  const HeightWeightWheelWidget({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onValueChanged,
    required this.isHeight,
  });

  @override
  State<HeightWeightWheelWidget> createState() => _HeightWeightWheelWidgetState();
}

class _HeightWeightWheelWidgetState extends State<HeightWeightWheelWidget> {
  late FixedExtentScrollController _scrollController;
  late int _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = _getInitialValue();
    _scrollController = FixedExtentScrollController(
      initialItem: _selectedValue - _getMinValue(),
    );
  }

  int _getInitialValue() {
    if (widget.initialValue.isNotEmpty) {
      try {
        return int.parse(widget.initialValue);
      } catch (e) {
        return widget.isHeight ? 170 : 70;
      }
    }
    return widget.isHeight ? 170 : 70;
  }

  int _getMinValue() => widget.isHeight ? 100 : 40;
  int _getMaxValue() => widget.isHeight ? 250 : 200;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // العنوان
          Container(
            padding: EdgeInsets.all(12.h),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Center(
              child: Text(
                widget.label,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          // العجلة
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // الخطوط الدليلية
                Positioned(
                  left: 30.w,
                  right: 30.w,
                  child: Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey[300]!, width: 1),
                        bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                      ),
                    ),
                  ),
                ),

                // العجلة
                Row(
                  children: [
                    Expanded(
                      child: ListWheelScrollView(
                        controller: _scrollController,
                        itemExtent: 50.h,
                        perspective: 0.005,
                        diameterRatio: 2.5,
                        onSelectedItemChanged: (index) {
                          final value = index + _getMinValue();
                          setState(() {
                            _selectedValue = value;
                          });
                          widget.onValueChanged(value.toString());
                        },
                        children: List.generate(
                          _getMaxValue() - _getMinValue() + 1,
                              (index) {
                            final value = index + _getMinValue();
                            final isSelected = value == _selectedValue;

                            return Center(
                              child: Text(
                                '$value',
                                style: TextStyle(
                                  fontSize: isSelected ? 28.sp : 22.sp,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected ? const Color(0xFF248c33) : Colors.grey[600],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // الوحدة
                    Padding(
                      padding: EdgeInsets.only(right: 20.w, left: 10.w),
                      child: Text(
                        widget.isHeight ? 'سم' : 'كجم',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}