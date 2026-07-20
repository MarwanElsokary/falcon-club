import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pins the shared profile photo's geometry. Three screens previously carried
/// byte-identical copies of it; these defaults are what "unchanged" means for
/// all of them, and the size overrides are what card-scale reuse depends on.
void main() {
  Future<ProfileAvatar> pump(
    WidgetTester tester, {
    double? width,
    double? height,
  }) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    late ProfileAvatar avatar;
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, __) {
          avatar = ProfileAvatar(
            imageUrl: null,
            width: width,
            height: height,
          );
          return MaterialApp(home: Scaffold(body: Center(child: avatar)));
        },
      ),
    );
    await tester.pump();
    return avatar;
  }

  /// The framed box is the outermost Container the widget builds.
  Container frame(WidgetTester tester) => tester.widget<Container>(
    find.descendant(of: find.byType(ProfileAvatar), matching: find.byType(Container)).first,
  );

  testWidgets('defaults to the 98x139 portrait frame', (
    WidgetTester tester,
  ) async {
    await pump(tester);

    final Size size = tester.getSize(find.byType(ProfileAvatar));
    expect(size.width, closeTo(98, 0.5));
    expect(size.height, closeTo(139, 0.5));
  });

  testWidgets('frames the photo with the secondMainColor border', (
    WidgetTester tester,
  ) async {
    await pump(tester);

    final BoxDecoration decoration =
        frame(tester).decoration! as BoxDecoration;
    expect(decoration.border!.top.color, secondMainColor);
    // A very large radius on a non-square box is what makes it read as a
    // stadium rather than a circle — the shape depends on both.
    expect(
      (decoration.borderRadius! as BorderRadius).topLeft.x,
      greaterThan(50),
    );
  });

  testWidgets('honours size overrides, keeping the portrait ratio', (
    WidgetTester tester,
  ) async {
    await pump(tester, width: 64, height: 90);

    final Size size = tester.getSize(find.byType(ProfileAvatar));
    expect(size.width, closeTo(64, 0.5));
    expect(size.height, closeTo(90, 0.5));
    expect(size.height, greaterThan(size.width)); // still a portrait
  });
}
