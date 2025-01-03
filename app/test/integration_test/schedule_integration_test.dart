import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/schedule.dart'; 

void main() {
  testWidgets('Testing the display of WorkoutSchedulePage elements', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: WorkoutSchedulePage(),
    ));

    await tester.pumpAndSettle();

    /** Check that the days of the week are correctly displayed (except Saturday and Sunday) */
    expect(find.text('Monday'), findsOneWidget);
    expect(find.text('Tuesday'), findsOneWidget);
    expect(find.text('Wednesday'), findsOneWidget);
    expect(find.text('Thursday'), findsOneWidget);
    expect(find.text('Friday'), findsOneWidget);
    expect(find.text('Saturday'), findsNothing); // Not visible
    expect(find.text('Sunday'), findsNothing); // Not visible

    /** Check that the training programmes are displayed as ‘Undefined’ at the start */
    expect(find.text('Undefined'), findsNWidgets(5)); // 5 Visible

    /**  Check that the ‘Manage Workouts’ button is present */
    expect(find.text('Manage Workouts'), findsOneWidget);

    /** Check that the refresh button is present */
    expect(find.byIcon(Icons.refresh), findsOneWidget);

    /** Check that the ‘Back’ button is present */
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
  });
}
