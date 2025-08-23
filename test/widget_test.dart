// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import 'package:holo_mobile/main.dart';

void main() {
  setUp(() async {
    // Reset GetIt before each test
    await GetIt.instance.reset();
  });

  tearDown(() async {
    // Clean up after each test
    await GetIt.instance.reset();
  });

  testWidgets('App should display Holo Mobile title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our app displays the correct title.
    expect(find.text('Holo Mobile'), findsOneWidget);
  });
}
