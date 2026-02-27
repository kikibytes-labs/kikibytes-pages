// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kikibytes_pages/app.dart';
import 'package:kikibytes_pages/strings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app within ScreenUtilInit (like main) and trigger a frame.
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => child!,
        child: KikiBytesApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify that the home welcome text appears.
    expect(find.text(Strings.homeWelcome), findsOneWidget);
  });
}
