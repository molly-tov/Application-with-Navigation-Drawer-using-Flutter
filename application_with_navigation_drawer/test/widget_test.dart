// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:application_with_navigation_drawer/main.dart';

void main() {
  testWidgets('Notepad app loads and shows empty state', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(NotepadApp());

    // Verify that the app bar title is present.
    expect(find.text('Notepad'), findsOneWidget);

    // Verify that the empty state text is present.
    expect(find.text('No notes yet. Tap + to add one.'), findsOneWidget);

    // Verify that the add button is present.
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
