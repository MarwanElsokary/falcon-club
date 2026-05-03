import 'package:falconclubapp/core/thems/thems.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_ruler_picker/flutter_ruler_picker.dart';
import 'package:falconclubapp/feature/login/cubit/login_cubit.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';

class CompactHeightWeightSection extends StatefulWidget {
  const CompactHeightWeightSection({super.key});

  @override
  State<CompactHeightWeightSection> createState() =>
      _CompactHeightWeightSectionState();
}

class _CompactHeightWeightSectionState
    extends State<CompactHeightWeightSection> {
  late int _weight;
  late int _height;

  late RulerPickerController _weightController;
  late RulerPickerController _heightController;

  @override
  void initState() {
    super.initState();

    final cubit = context.read<LoginCubit>();

    _weight = int.tryParse(cubit.controller.weight.text) ?? 75;
    _height = int.tryParse(cubit.controller.height.text) ?? 170;

    _weightController = RulerPickerController(value: _weight);
    _heightController = RulerPickerController(value: _height);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();

    return Column(
      children: [
        _buildRuler(
          title: 'الوزن',
          value: _weight,
          unit: 'كجم',
          min: 40,
          max: 150,
          onChanged: (v) {
            setState(() => _weight = v);
            cubit.controller.weight.text = v.toString();
          },
          secondary: '${(_weight * 2.20462).toStringAsFixed(1)} رطل',
          controller: _weightController,
          begin: 40,
          end: 150,
        ),

        verticalSpace(12),

        _buildRuler(
          title: 'الطول',
          value: _height,
          unit: 'سم',
          min: 140,
          max: 220,
          onChanged: (v) {
            setState(() => _height = v);
            cubit.controller.height.text = v.toString();
          },
          secondary: '${(_height / 2.54).toStringAsFixed(1)} إنش',
          begin: 120,
          end: 220,
          controller: _heightController,
        ),
      ],
    );
  }

  Widget _buildRuler({
    required String title,
    required int value,
    required String unit,
    required int min,
    required int max,
    required int begin,
    required int end,
    required RulerPickerController controller,
    required ValueChanged<int> onChanged,
    required String secondary,
  }) {
    final cubit = context.read<LoginCubit>(); // 👈 ده السطر المهم

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),

        verticalSpace(6),

        Center(
          child: Text(
            '$value',
            style: TextStyle(
              fontSize: 34.sp,
              fontWeight: FontWeight.w700,
              color: mainColor,
            ),
          ),
        ),

        SizedBox(
          height: 80.h,
          child: MiniRulerPicker(
            min: min,
            max: max,
            value: value,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class MiniRulerPicker extends StatefulWidget {
  final int min;
  final int max;
  final int value;
  final ValueChanged<int> onChanged;

  const MiniRulerPicker({
    super.key,
    required this.min,
    required this.max,
    required this.value,
    required this.onChanged,
  });

  @override
  State<MiniRulerPicker> createState() => _MiniRulerPickerState();
}

class _MiniRulerPickerState extends State<MiniRulerPicker> {
  late ScrollController _controller;

  static const double itemWidth = 8;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController(
      initialScrollOffset: (widget.value - widget.min) * itemWidth,
    );
  }

  @override
  Widget build(BuildContext context) {
    final halfScreen = MediaQuery.of(context).size.width / 2;

    return SizedBox(
      height: 40.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollUpdateNotification) {
                final index =
                    (_controller.offset / itemWidth).round() + widget.min;
                if (index >= widget.min && index <= widget.max) {
                  widget.onChanged(index);
                }
              }
              return true;
            },
            child: ListView.builder(
              controller: _controller,
              scrollDirection: Axis.horizontal,

              padding: EdgeInsets.symmetric(horizontal: halfScreen),

              itemCount: widget.max - widget.min + 1,
              itemBuilder: (context, index) {
                final value = widget.min + index;
                final isMajor = value % 10 == 0;

                return Center(
                  child: Container(
                    width: 1,
                    height: isMajor ? 20 : 12,
                    margin: EdgeInsets.symmetric(horizontal: itemWidth / 2),
                    color: Colors.grey.shade700,
                  ),
                );
              },
            ),
          ),

          // 👇 المؤشر الثابت
          Container(width: 2, height: 28, color: mainColor),
        ],
      ),
    );
  }
}
