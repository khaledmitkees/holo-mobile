import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holo_mobile/design_system/components/common_app_bar.dart';

void main() {
  group('CommonAppBar', () {
    testWidgets('should display title correctly', (WidgetTester tester) async {
      const title = 'Test Title';
      
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: CommonAppBar(title: title),
          ),
        ),
      );

      expect(find.text(title), findsOneWidget);
    });

    testWidgets('should show back button by default', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: CommonAppBar(title: 'Test'),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
    });

    testWidgets('should hide back button when showBackButton is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: CommonAppBar(
              title: 'Test',
              showBackButton: false,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_back_ios), findsNothing);
    });

    testWidgets('should call onBackPressed when back button is tapped', (WidgetTester tester) async {
      bool backPressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: CommonAppBar(
              title: 'Test',
              onBackPressed: () => backPressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.arrow_back_ios));
      await tester.pumpAndSettle();

      expect(backPressed, isTrue);
    });

    testWidgets('should display custom actions', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: CommonAppBar(
              title: 'Test',
              actions: [
                Icon(Icons.search),
                Icon(Icons.more_vert),
              ],
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.more_vert), findsOneWidget);
    });

    testWidgets('should apply custom colors', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: CommonAppBar(
              title: 'Test',
              backgroundColor: Colors.blue,
              titleColor: Colors.red,
              iconColor: Colors.green,
            ),
          ),
        ),
      );

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      final titleWidget = tester.widget<Text>(find.text('Test'));
      final icon = tester.widget<Icon>(find.byIcon(Icons.arrow_back_ios));

      expect(appBar.backgroundColor, equals(Colors.blue));
      expect(titleWidget.style?.color, equals(Colors.red));
      expect(icon.color, equals(Colors.green));
    });
  });
}
