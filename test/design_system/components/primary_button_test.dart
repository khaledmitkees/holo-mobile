import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holo_mobile/design_system/components/primary_button.dart';

void main() {
  group('PrimaryButton', () {
    testWidgets('should display text correctly', (WidgetTester tester) async {
      const buttonText = 'Test Button';
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: buttonText,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text(buttonText), findsOneWidget);
    });

    testWidgets('should call onPressed when tapped', (WidgetTester tester) async {
      bool pressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Test',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(PrimaryButton));
      await tester.pumpAndSettle();

      expect(pressed, isTrue);
    });

    testWidgets('should be disabled when onPressed is null', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Test',
              onPressed: null,
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('should be disabled when isEnabled is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Test',
              onPressed: () {},
              isEnabled: false,
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('should show loading indicator when isLoading is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Test',
              onPressed: () {},
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Test'), findsNothing);
    });

    testWidgets('should be disabled when loading', (WidgetTester tester) async {
      bool pressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Test',
              onPressed: () => pressed = true,
              isLoading: true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(PrimaryButton));
      await tester.pump();

      expect(pressed, isFalse);
    });

    testWidgets('should apply custom styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Test',
              onPressed: () {},
              width: 200,
              height: 60,
              backgroundColor: Colors.blue,
              textColor: Colors.yellow,
              borderRadius: 12,
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.width, equals(200));
      expect(sizedBox.height, equals(60));

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final buttonStyle = button.style!;
      expect(buttonStyle.backgroundColor?.resolve({}), equals(Colors.blue));

      final text = tester.widget<Text>(find.text('Test'));
      expect(text.style?.color, equals(Colors.yellow));
    });
  });
}
