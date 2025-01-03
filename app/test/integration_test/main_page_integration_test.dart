///
/// @brief     Integration test file of main.dart
///
/// @author    CAZIN Némo & Adrien Paliferro
/// @date      2024 - 2025
/// 
/// Politecnico Di Milano
/// 
library DIMA;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/main.dart';

void main() {
  testWidgets('Integration test for MenuPage', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MenuPage()));
    
    /** Wait for all animations and async operations to complete */
    await tester.pumpAndSettle();

    /** Verify the initial UI */
    expect(find.text("Menu Page"), findsOneWidget);
    expect(find.text("Undefined"), findsOneWidget);
    expect(find.text("Start Workout"), findsOneWidget);
    expect(find.text("Modify Schedule"), findsOneWidget);

    /** Simulate tapping the "Start Workout" button without a workout defined */
    await tester.tap(find.text("Start Workout"));
    await tester.pumpAndSettle();

    /** Expect an alert dialog to appear */
    expect(find.text("No workout selected for today ! Please select one."), findsOneWidget);
    
    /** Tap OK on the dialog */
    await tester.tap(find.text("OK"));
    await tester.pumpAndSettle();
  });
}