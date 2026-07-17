import 'package:flutter/material.dart';

import '../../../../shared/presentation/widgets/empty_state_view.dart';

/// The empty state for the trials/experiments grid and the Home trials section.
///
/// Shown when the backend answers `GetAllTrials` with a 400 + "No Trials Found"
/// — its way of saying the collection is empty. Before this, that response fell
/// through to a loading spinner (the grid) or crashed the carousel (the Home
/// section), so an empty result was indistinguishable from a stuck/broken screen.
///
/// It is only the trials-specific copy and icon; the layout is the shared
/// [EmptyStateView], so every empty list in the app looks the same.
class TrialsEmptyState extends StatelessWidget {
  const TrialsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyStateView(
      icon: Icons.travel_explore_rounded,
      title: 'لا توجد تجارب متاحة حالياً',
      message: 'سيظهر هنا كل ما هو جديد من التجارب فور توفره',
    );
  }
}
