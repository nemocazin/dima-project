///
/// @brief     Unit test file of schedule.dart
///
/// @author    CAZIN Némo & Adrien Paliferro
/// @date      2024 - 2025
/// 
/// Politecnico Di Milano
/// 
library DIMA;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/schedule.dart';

void main() {
  group('WorkoutSchedulePageState - Unit Tests', () {
    testWidgets('selectWorkoutProgram should update schedule with selected workout', (WidgetTester tester) async {
      // Créer le widget
      final widget = MaterialApp(home: WorkoutSchedulePage());
      await tester.pumpWidget(widget);

      // Obtenir l'état
      final state = tester.state<WorkoutSchedulePageState>(find.byType(WorkoutSchedulePage));

      // Ajouter des programmes
      state.workoutPrograms = ["Undefined", "Workout A", "Workout B"];

      // Simuler une sélection
      state.selectWorkoutProgram("Monday");
      await tester.pump();

      // Simuler l'interaction avec le dialogue
      await tester.tap(find.text("Workout A"));
      await tester.pump();

      // Vérifier la mise à jour du planning
      expect(state.schedule["Monday"], equals("Workout A"));
    });
  });
}
