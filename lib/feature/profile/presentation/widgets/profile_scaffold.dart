import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:flutter/material.dart';

/// The full-bleed background + safe area all self-profile screens sit on.
///
/// Extracted verbatim from the Coach and MainClub screens, which each declared
/// this identical `Container … Frame 1011 1.png … SafeArea` scaffold; the Scout
/// screen shares it too. Also hosts the shared back affordance so all three
/// self-profile screens get an identical in-screen back button (they're pushed
/// from a drawer and otherwise had none).
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
        child: SafeArea(
          child: Stack(
            children: [
              child,
              // Only when this screen was pushed (i.e. never as a tab root, and
              // absent in widget-tests that pump it as `home`).
              if (Navigator.of(context).canPop())
                const PositionedDirectional(
                  top: 0,
                  start: 0,
                  child: BackButton(color: Colors.white),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
