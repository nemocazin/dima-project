///
/// @brief     Unit test file of main.dart
///
/// @author    CAZIN Némo & Adrien Paliferro
/// @date      2024 - 2025
/// 
/// Politecnico Di Milano
/// 
library DIMA;

import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/main.dart';

void main() {
  group('MenuPage Unit Tests', () {
    test('Calculate total duration of a workout', () {
      /** Simulated exercise data */
      const workoutName = 'test 2';
      const programData = [
        {
          "workoutName": "test 2",
          "exercises": [
            [
              5,
              "Decline Dumbbell Press",
              "Upper Body",
              "Push",
              "Pectorals (Lower)",
              "Triceps",
              6,
              "Base",
              1,
              1,
              1,
              4
            ]
          ]
        }
      ];

      final menuPageState = MenuPageState();
      final duration = menuPageState.calculateTotalDuration(workoutName, programData);
      expect(duration, 4);
    });

    test('Load JSON file correctly', () async {
      final menuPageState = MenuPageState();

      /** Mock JSON file content */
      final file = File('test/test_data/mock_schedule.json');
      await file.writeAsString(jsonEncode({"Monday": "test"}));

      final scheduleData = await menuPageState.loadJson('test/test_data/mock_schedule.json');
      expect(scheduleData['Monday'], "test");

      /** Clean up */
      file.writeAsStringSync('');
    });
  });
}
