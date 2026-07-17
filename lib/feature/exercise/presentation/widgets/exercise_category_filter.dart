import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/thems/thems.dart';
import '../../../../core/widget/center_text_utils.dart';
import '../../../main_screen/cubit/main_cubit.dart';
import '../../../main_screen/cubit/main_state.dart';
import '../cubit/exercise_list_cubit.dart';
import '../cubit/exercise_list_state.dart';

/// The horizontal category chips above the exercise list.
///
/// A port of `traning_catogeries_widget.dart` (and its twin,
/// `scout_training_categories_widget.dart`): the same 40h strip, the same
/// `AnimatedSwitcher` size-and-fade for the selected pill, the same 500ms
/// `AnimatedContainer` chips, the same 2w divider bar, and the same 16w circular
/// category icon with its skeleton placeholder and SVG fallback.
///
/// ## It is now stateless
///
/// Both originals were `StatefulWidget`s holding `selectedFilter` and
/// `iconSelected` in `setState`, *and* calling `context.read<...Cubit>()` to
/// re-fetch — so the widget owned the filter while the cubit owned the results.
/// The two fields could disagree, and did: tapping the pill's ✕ cleared
/// `selectedFilter` but left `iconSelected` set. The selection now lives in
/// [ExerciseListState], as one object that cannot half-update.
///
/// Categories still come from [MainCubit], which owns them app-wide. That is
/// unchanged, and out of scope here.
class ExerciseCategoryFilter extends StatelessWidget {
  const ExerciseCategoryFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.displayWidth,
      height: 40.h,
      child: BlocBuilder<MainCubit, MainState>(
        buildWhen: (MainState previous, MainState current) =>
            current is categoriesLoading ||
            current is categoriesSuccess ||
            current is categoriesError,
        builder: (BuildContext context, MainState state) => state.maybeWhen(
          categoriessuccess: (dynamic categories) =>
              BlocBuilder<ExerciseListCubit, ExerciseListState>(
                builder:
                    (BuildContext context, ExerciseListState exerciseState) =>
                        _bar(context, categories, exerciseState),
              ),
          orElse: () => SizedBox(height: 40.h),
        ),
      ),
    );
  }

  Widget _bar(
    BuildContext context,
    dynamic categories,
    ExerciseListState state,
  ) {
    final SelectedCategory? selected = state.selectedCategory;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) =>
              SizeTransition(
                sizeFactor: animation,
                axis: Axis.horizontal,
                axisAlignment: -1,
                child: FadeTransition(opacity: animation, child: child),
              ),
          child: selected == null
              ? const SizedBox.shrink()
              : _selectionPill(context, selected),
        ),
        if (selected != null) _divider(),
        Expanded(child: _chips(context, categories, state)),
      ],
    );
  }

  /// The pill echoing the current selection. Tapping it — or its ✕ — clears.
  Widget _selectionPill(BuildContext context, SelectedCategory selected) =>
      GestureDetector(
        onTap: () => context.read<ExerciseListCubit>().clearCategory(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          key: ValueKey<String>(selected.id),
          margin: EdgeInsetsDirectional.only(start: 20.w),
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: mainColor,
          ),
          child: Row(
            children: <Widget>[
              CenterTextUtils(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                text: selected.name,
              ),
              horizontalSpace(5),
              _icon(selected.iconUrl),
              horizontalSpace(2),
              GestureDetector(
                onTap: () => context.read<ExerciseListCubit>().clearCategory(),
                child: Icon(Icons.close, color: Colors.white, size: 16.w),
              ),
            ],
          ),
        ),
      );

  Widget _icon(String? url) => ClipOval(
    child: SizedBox(
      width: 16.w,
      height: 16.w,
      child: CachedNetworkImage(
        imageUrl: url ?? '',
        fit: BoxFit.contain,
        placeholder: (BuildContext context, String _) => Skeletonizer(
          enabled: true,
          child: Container(
            height: 16.w,
            width: 16.w,
            decoration: const BoxDecoration(shape: BoxShape.circle),
          ),
        ),
        errorWidget: (BuildContext context, String _, Object __) => Container(
          padding: EdgeInsets.all(3.w),
          child: SvgPicture.asset(
            'assets/svgs/unavailabeImage.svg',
            width: 16.w,
          ),
        ),
      ),
    ),
  );

  Widget _divider() => Container(
    margin: EdgeInsets.symmetric(horizontal: 10.w),
    height: 25.h,
    width: 2.w,
    decoration: BoxDecoration(
      color: mainColor,
      borderRadius: BorderRadius.circular(20.r),
    ),
  );

  Widget _chips(
    BuildContext context,
    dynamic categories,
    ExerciseListState state,
  ) {
    // Tolerant: the category payload is `dynamic` (it comes from MainCubit's
    // model). A null or non-list `data`, or a row with a null `name`, must not
    // take down the whole filter bar — degrade to empty / '' instead of casting.
    final Object? rawRows = categories.data;
    final List<dynamic> rows = rawRows is List ? rawRows : const <dynamic>[];

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: state.hasSelection ? 0 : 20.w),
      scrollDirection: Axis.horizontal,
      itemCount: rows.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        final SelectedCategory category = SelectedCategory(
          id: '${rows[index].id ?? ''}',
          name: '${rows[index].name ?? ''}',
          iconUrl: rows[index].icon?.toString(),
        );
        final bool isSelected = state.isSelected(category.id);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              // Tapping the selected chip clears it — the cubit decides that,
              // not an `if (isSelected)` branch duplicated in two widgets.
              onTap: () =>
                  context.read<ExerciseListCubit>().toggleCategory(category),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: isSelected ? mainColor : Colors.transparent,
                  border: Border.all(color: mainColor),
                ),
                child: CenterTextUtils(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : mainColor,
                  text: category.name,
                ),
              ),
            ),
            horizontalSpace(5),
          ],
        );
      },
    );
  }
}
