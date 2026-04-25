import 'package:awkwardsky_home/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the project index and first live project', (tester) async {
    tester.view.physicalSize = const Size(1400, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const AwkwardSkyHomeApp());

    expect(find.text('awkwardsky.github.io'), findsOneWidget);
    expect(find.text('語言切換'), findsOneWidget);
    expect(find.byIcon(Icons.light_mode_rounded), findsOneWidget);
    expect(find.text('ReactionSpeedLab'), findsOneWidget);
    expect(find.text('更多專案'), findsOneWidget);
  });
}
