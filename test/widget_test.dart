import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mus_law/main.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MusicApp());

    // Verify that our app starts
    expect(find.byType(MusicApp), findsOneWidget);

    // Verify that initial screen is loaded (either login or home)
    expect(find.byType(Scaffold), findsOneWidget);
  });

  testWidgets('Login screen contains key elements',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MusicApp());

    // Verify key elements on login screen
    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2)); // Email and password
    expect(find.text('Login'), findsOneWidget);
  });
}
