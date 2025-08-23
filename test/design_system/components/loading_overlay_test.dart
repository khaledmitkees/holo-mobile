import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holo_mobile/design_system/components/loading_overlay.dart';

void main() {
  group('LoadingOverlay', () {
    testWidgets('should display child widget', (WidgetTester tester) async {
      const childText = 'Child Widget';
      
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingOverlay(
              isLoading: false,
              child: Text(childText),
            ),
          ),
        ),
      );

      expect(find.text(childText), findsOneWidget);
    });

    testWidgets('should not show loading overlay when isLoading is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingOverlay(
              isLoading: false,
              child: Text('Child'),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should show loading overlay when isLoading is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 200,
              height: 200,
              child: LoadingOverlay(
                isLoading: true,
                progressIndicatorSize: 20,
                child: Text('Child'),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Child'), findsOneWidget); // Child should still be visible
    });

    testWidgets('should display loading text when provided', (WidgetTester tester) async {
      const loadingText = 'Loading...';
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 200,
              height: 200,
              child: LoadingOverlay(
                isLoading: true,
                loadingText: loadingText,
                progressIndicatorSize: 20,
                child: Text('Child'),
              ),
            ),
          ),
        ),
      );

      expect(find.text(loadingText), findsOneWidget);
    });

    testWidgets('should apply custom overlay color', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 200,
              height: 200,
              child: LoadingOverlay(
                isLoading: true,
                overlayColor: Colors.red,
                progressIndicatorSize: 20,
                child: Text('Child'),
              ),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.byWidgetPredicate((widget) =>
          widget is Container && widget.color == Colors.red
        ),
      );
      expect(container.color, equals(Colors.red));
    });

    testWidgets('should apply custom progress indicator color', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 200,
              height: 200,
              child: LoadingOverlay(
                isLoading: true,
                progressIndicatorColor: Colors.green,
                progressIndicatorSize: 20,
                child: Text('Child'),
              ),
            ),
          ),
        ),
      );

      final progressIndicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      final valueColor = progressIndicator.valueColor as AlwaysStoppedAnimation<Color>;
      expect(valueColor.value, equals(Colors.green));
    });

    testWidgets('should apply custom progress indicator size', (WidgetTester tester) async {
      const customSize = 30.0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 200,
              height: 200,
              child: LoadingOverlay(
                isLoading: true,
                progressIndicatorSize: customSize,
                child: Text('Child'),
              ),
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.byWidgetPredicate((widget) =>
          widget is SizedBox && 
          widget.width == customSize && 
          widget.height == customSize
        ),
      );
      expect(sizedBox.width, equals(customSize));
      expect(sizedBox.height, equals(customSize));
    });

    testWidgets('should apply custom loading text style', (WidgetTester tester) async {
      const loadingText = 'Loading...';
      const customTextStyle = TextStyle(
        color: Colors.blue,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 200,
              height: 200,
              child: LoadingOverlay(
                isLoading: true,
                loadingText: loadingText,
                loadingTextStyle: customTextStyle,
                progressIndicatorSize: 20,
                child: Text('Child'),
              ),
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text(loadingText));
      expect(text.style?.color, equals(Colors.blue));
      expect(text.style?.fontSize, equals(14));
      expect(text.style?.fontWeight, equals(FontWeight.bold));
    });
  });
}
