import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:flutter/material.dart';

/// The full-bleed background + safe area both self-profile screens sit on.
///
/// Extracted verbatim from the Coach and MainClub screens, which each declared
/// this identical `Container … Frame 1011 1.png … SafeArea` scaffold.
class ProfileScaffold extends StatelessWidget {
  const ProfileScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: context.displayWidth,
        height: context.displayHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Frame 1011 1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(child: child),
      ),
    );
  }
}
