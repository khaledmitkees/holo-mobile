import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holo_mobile/design_system/components/error_widget.dart' as custom;
import 'package:holo_mobile/design_system/components/primary_button.dart';

void main() {
  group('ErrorWidget', () {
    testWidgets('should display title and message correctly', (WidgetTester tester) async {
      const title = 'Something went wrong';
      const message = 'Please try again later';
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: custom.ErrorWidget(
              title: title,
              message: message,
              onRetry: () {},
            ),
          ),
        ),
      );

      expect(find.text(title), findsOneWidget);
      expect(find.text(message), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('should call onRetry when retry button is pressed', (WidgetTester tester) async {
      bool retryPressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: custom.ErrorWidget(
              title: 'Error',
              message: 'Something went wrong',
              onRetry: () => retryPressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(PrimaryButton));
      await tester.pump();

      expect(retryPressed, isTrue);
    });

    testWidgets('should display custom retry button text', (WidgetTester tester) async {
      const customRetryText = 'Try Again';
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: custom.ErrorWidget(
              title: 'Error',
              message: 'Something went wrong',
              onRetry: () {},
              retryButtonText: customRetryText,
            ),
          ),
        ),
      );

      expect(find.text(customRetryText), findsOneWidget);
      expect(find.text('Retry'), findsNothing);
    });

    testWidgets('should display icon when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: custom.ErrorWidget(
              title: 'Error',
              message: 'Something went wrong',
              onRetry: () {},
              icon: Icons.error,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.error), findsOneWidget);
    });

    testWidgets('should not display icon when not provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: custom.ErrorWidget(
              title: 'Error',
              message: 'Something went wrong',
              onRetry: () {},
            ),
          ),
        ),
      );

      expect(find.byType(Icon), findsNothing);
    });

    testWidgets('should apply custom title style', (WidgetTester tester) async {
      const customTitleStyle = TextStyle(
        color: Colors.blue,
        fontSize: 30,
        fontWeight: FontWeight.w300,
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: custom.ErrorWidget(
              title: 'Custom Title',
              message: 'Message',
              onRetry: () {},
              titleStyle: customTitleStyle,
            ),
          ),
        ),
      );

      final titleWidget = tester.widget<Text>(find.text('Custom Title'));
      expect(titleWidget.style?.color, equals(Colors.blue));
      expect(titleWidget.style?.fontSize, equals(30));
      expect(titleWidget.style?.fontWeight, equals(FontWeight.w300));
    });

    testWidgets('should apply custom message style', (WidgetTester tester) async {
      const customMessageStyle = TextStyle(
        color: Colors.green,
        fontSize: 18,
        fontStyle: FontStyle.italic,
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: custom.ErrorWidget(
              title: 'Title',
              message: 'Custom Message',
              onRetry: () {},
              messageStyle: customMessageStyle,
            ),
          ),
        ),
      );

      final messageWidget = tester.widget<Text>(find.text('Custom Message'));
      expect(messageWidget.style?.color, equals(Colors.green));
      expect(messageWidget.style?.fontSize, equals(18));
      expect(messageWidget.style?.fontStyle, equals(FontStyle.italic));
    });

    testWidgets('should apply custom background color', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: custom.ErrorWidget(
              title: 'Title',
              message: 'Message',
              onRetry: () {},
              backgroundColor: Colors.yellow,
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.byWidgetPredicate((widget) =>
          widget is Container && widget.color == Colors.yellow
        ),
      );
      expect(container.color, equals(Colors.yellow));
    });

    testWidgets('should have proper layout structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: custom.ErrorWidget(
              title: 'Error Title',
              message: 'Error message here',
              onRetry: () {},
              icon: Icons.warning,
            ),
          ),
        ),
      );

      // Check that all elements are present in the widget tree
      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Icon), findsOneWidget);
      expect(find.byType(Text), findsNWidgets(3)); // Title, message, and button text
      expect(find.byType(PrimaryButton), findsOneWidget);
      expect(find.byType(SizedBox), findsWidgets); // Multiple SizedBox widgets for spacing
    });

    testWidgets('should center align all content', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: custom.ErrorWidget(
              title: 'Centered Title',
              message: 'Centered message',
              onRetry: () {},
            ),
          ),
        ),
      );

      final column = tester.widget<Column>(find.byType(Column));
      expect(column.mainAxisAlignment, equals(MainAxisAlignment.center));
      expect(column.crossAxisAlignment, equals(CrossAxisAlignment.center));

      final titleText = tester.widget<Text>(find.text('Centered Title'));
      expect(titleText.textAlign, equals(TextAlign.center));

      final messageText = tester.widget<Text>(find.text('Centered message'));
      expect(messageText.textAlign, equals(TextAlign.center));
    });
  });
}
