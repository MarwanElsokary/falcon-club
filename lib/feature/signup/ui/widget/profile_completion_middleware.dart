import 'package:falcon/feature/signup/ui/widget/profile_completion_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/constants.dart';
import '../../../../core/helpers/shared_pref_helper.dart';
import '../../../main_screen/cubit/main_cubit.dart';
import '../../../main_screen/cubit/main_state.dart';

// استخدم هذا الـ wrapper في أي صفحة تريد عرض البانر فيها
class ProfileCheckWrapper extends StatefulWidget {
  final Widget child;
  final bool showInHome; // true للـ home screen, false للـ drawer

  const ProfileCheckWrapper({
    super.key,
    required this.child,
    this.showInHome = true,
  });

  @override
  State<ProfileCheckWrapper> createState() => _ProfileCheckWrapperState();
}

class _ProfileCheckWrapperState extends State<ProfileCheckWrapper> {
  bool _isCompleted = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkProfileCompletion();
  }

  Future<void> _checkProfileCompletion() async {
    final isCompleted = await SharedPrefHelper.getBool(SharedPrefKeys.isCompleted);
    setState(() {
      _isCompleted != isCompleted ?? false;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return widget.child; // Show child while loading
    }

    if (_isCompleted) {
      return widget.child; // Profile is complete, show child only
    }

    // Profile is incomplete, show banner
    return Column(
      children: [
        if (widget.showInHome)
          const IncompleteProfileBanner()
        else
          const CompactIncompleteProfileBanner(),
        Expanded(child: widget.child),
      ],
    );
  }
}

// For home screen usage:
// return ProfileCheckWrapper(
//   child: YourHomeScreenContent(),
// );

// For drawer usage:
// return ProfileCheckWrapper(
//   showInHome: false,
//   child: YourDrawerContent(),
// );