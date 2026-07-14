import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/thems/thems.dart';
import '../../../../core/widget/text_utils.dart';

/// The searchable dropdown used by the signup cascade.
///
/// ## This is the ORIGINAL design, not a new one
///
/// It is a faithful port of `SelectUniWidget` / `SelectCollageWidget` — the same
/// `DropdownButton2` with in-menu search, the same responsive sizing, the same
/// `fillColor` + tinted border + shadow, the same Lottie loading hint, the same
/// leading icon and menu styling.
///
/// What changed is **only the plumbing**: those two widgets each held ~250 lines
/// of identical chrome and wrote straight into `LoginCubit`'s public mutable
/// fields (`selectedUniversityId`, `selectedCollegesId`). This one is a
/// controlled widget — it takes a value and reports changes — so both dropdowns
/// share it and neither knows a cubit exists. The visual result is unchanged.
class SearchableDropdown<T extends Object> extends StatefulWidget {
  const SearchableDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.labelOf,
    required this.onChanged,
    required this.icon,
    required this.hint,
    required this.disabledHint,
    required this.searchHint,
    required this.isLoading,
    required this.isEnabled,
  });

  final T? value;
  final List<T> items;
  final String Function(T) labelOf;
  final ValueChanged<T> onChanged;
  final IconData icon;
  final String hint;

  /// Shown when the dropdown is inert — e.g. "اختر المدينة أولاً" on the club
  /// dropdown before a city is picked.
  final String disabledHint;

  final String searchHint;
  final bool isLoading;
  final bool isEnabled;

  @override
  State<SearchableDropdown<T>> createState() => _SearchableDropdownState<T>();
}

class _SearchableDropdownState<T extends Object>
    extends State<SearchableDropdown<T>> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final _Metrics metrics = _Metrics.of(MediaQuery.sizeOf(context).width);
        return Container(
          margin: EdgeInsets.symmetric(vertical: 4.h),
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(metrics.borderRadius),
            border: Border.all(color: mainColor.withValues(alpha: 0.2)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: mainColor.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: _dropdown(metrics),
          ),
        );
      },
    );
  }

  DropdownButton2<T> _dropdown(_Metrics metrics) => DropdownButton2<T>(
    value: widget.items.contains(widget.value) ? widget.value : null,
    hint: widget.isLoading ? _loadingHint(metrics) : _idleHint(metrics),
    isExpanded: true,
    items: widget.items
        .map(
          (T item) => DropdownMenuItem<T>(
            value: item,
            child: TextUtils(
              fontSize: metrics.fontSize,
              fontWeight: FontWeight.w500,
              color: blackclr,
              text: widget.labelOf(item),
              maxlines: 1,
            ),
          ),
        )
        .toList(growable: false),
    onChanged: widget.isEnabled && widget.items.isNotEmpty
        ? (T? selected) {
            if (selected != null) widget.onChanged(selected);
          }
        : null,
    iconStyleData: IconStyleData(
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: widget.isEnabled ? mainColor : greyClr.withValues(alpha: 0.5),
        size: metrics.iconSize * 1.2,
      ),
    ),
    buttonStyleData: ButtonStyleData(
      height: metrics.buttonHeight,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(metrics.borderRadius),
        color: fillColor,
      ),
    ),
    dropdownStyleData: _menuStyle(metrics),
    menuItemStyleData: MenuItemStyleData(
      height: metrics.buttonHeight,
      padding: EdgeInsets.symmetric(horizontal: metrics.horizontalPadding),
    ),
    dropdownSearchData: _searchData(metrics),
  );

  DropdownStyleData _menuStyle(_Metrics metrics) => DropdownStyleData(
    maxHeight: 0.4.sh,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(metrics.borderRadius),
      color: Colors.white,
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.15),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    offset: Offset(0, -8.h),
  );

  DropdownSearchData<T> _searchData(_Metrics metrics) => DropdownSearchData<T>(
    searchController: _searchController,
    searchInnerWidgetHeight: 50,
    searchInnerWidget: Container(
      height: 50.h,
      padding: EdgeInsets.symmetric(
        horizontal: metrics.horizontalPadding,
        vertical: 4.h,
      ),
      child: TextFormField(
        controller: _searchController,
        decoration: InputDecoration(
          isDense: true,
          hintText: widget.searchHint,
          hintStyle: TextStyle(color: greyClr, fontSize: metrics.fontSize),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(metrics.borderRadius),
          ),
        ),
      ),
    ),
    searchMatchFn: (DropdownMenuItem<T> item, String query) {
      final T? candidate = item.value;
      if (candidate == null) return false;
      return widget
          .labelOf(candidate)
          .toLowerCase()
          .contains(query.toLowerCase());
    },
  );

  Widget _loadingHint(_Metrics metrics) => Padding(
    padding: EdgeInsets.symmetric(horizontal: metrics.horizontalPadding),
    child: Row(
      children: <Widget>[
        Lottie.asset('assets/lottie/load.json', width: metrics.iconSize),
        horizontalSpace(8),
        Expanded(
          child: TextUtils(
            fontSize: metrics.fontSize,
            fontWeight: FontWeight.w500,
            color: greyClr,
            text: 'جاري التحميل...'.tr(),
            maxlines: 1,
          ),
        ),
      ],
    ),
  );

  Widget _idleHint(_Metrics metrics) => Padding(
    padding: EdgeInsets.symmetric(horizontal: metrics.horizontalPadding),
    child: Row(
      children: <Widget>[
        Icon(
          widget.icon,
          color: widget.isEnabled ? mainColor : greyClr.withValues(alpha: 0.5),
          size: metrics.iconSize,
        ),
        horizontalSpace(10),
        Expanded(
          child: TextUtils(
            fontSize: metrics.fontSize,
            fontWeight: FontWeight.w500,
            color: widget.isEnabled
                ? mainColor.withValues(alpha: 0.7)
                : greyClr.withValues(alpha: 0.5),
            text: widget.isEnabled ? widget.hint : widget.disabledHint,
            maxlines: 1,
          ),
        ),
      ],
    ),
  );
}

/// The original's responsive sizing, extracted so both dropdowns share one copy
/// instead of each declaring the same six ternaries.
final class _Metrics {
  const _Metrics({
    required this.buttonHeight,
    required this.iconSize,
    required this.fontSize,
    required this.borderRadius,
    required this.horizontalPadding,
  });

  factory _Metrics.of(double screenWidth) {
    if (screenWidth < _smallBreakpoint) {
      return _Metrics(
        buttonHeight: 44.h,
        iconSize: 18.w,
        fontSize: 12.sp,
        borderRadius: 12.r,
        horizontalPadding: 10.w,
      );
    }
    if (screenWidth < _largeBreakpoint) {
      return _Metrics(
        buttonHeight: 48.h,
        iconSize: 20.w,
        fontSize: 13.sp,
        borderRadius: 14.r,
        horizontalPadding: 12.w,
      );
    }
    return _Metrics(
      buttonHeight: 52.h,
      iconSize: 22.w,
      fontSize: 14.sp,
      borderRadius: 16.r,
      horizontalPadding: 14.w,
    );
  }

  static const double _smallBreakpoint = 360;
  static const double _largeBreakpoint = 600;

  final double buttonHeight;
  final double iconSize;
  final double fontSize;
  final double borderRadius;
  final double horizontalPadding;
}
