import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:send_money_app/widgets/primary_button.dart';

void main() {
  group('PrimaryButton Widget Test', () {
    testWidgets('displays text when not loading', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(text: 'Click Me', onPressed: () {}),
          ),
        ),
      );

      // Verify the text is displayed
      expect(find.text('Click Me'), findsOneWidget);
      // Verify CircularProgressIndicator is NOT displayed
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('displays CircularProgressIndicator when loading', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Click Me',
              loading: true,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Verify CircularProgressIndicator is displayed
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Verify the text is NOT displayed
      expect(find.text('Click Me'), findsNothing);
    });

    testWidgets('calls onPressed when tapped', (WidgetTester tester) async {
      bool pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Tap Me',
              onPressed: () {
                pressed = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump(); // Rebuild after tap

      expect(pressed, isTrue);
    });

    testWidgets('does not call onPressed when loading', (
      WidgetTester tester,
    ) async {
      bool pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Tap Me',
              loading: true,
              onPressed: () {
                pressed = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(pressed, isFalse);
    });
  });
}
