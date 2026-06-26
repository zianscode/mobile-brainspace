import 'package:flutter_test/flutter_test.dart';
import 'package:brainpace/core/utils/calculation_utils.dart';

void main() {
  group('CalculationUtils Tests', () {
    test('calculateAccuracy returns correct percentage', () {
      expect(CalculationUtils.calculateAccuracy(totalCorrect: 8, totalAnswered: 10), 80.0);
      expect(CalculationUtils.calculateAccuracy(totalCorrect: 0, totalAnswered: 10), 0.0);
      expect(CalculationUtils.calculateAccuracy(totalCorrect: 5, totalAnswered: 0), 0.0);
    });

    test('calculateConsistency returns correct consistency score', () {
      // Perfectly consistent
      expect(CalculationUtils.calculateConsistency([10, 10, 10, 10]), 100.0);

      // Varying pace: mean = 10, stdDev = sqrt(2) ~ 1.414
      // Consistency = 100 * (1 - 1.414 / 10) = 85.857...
      expect(CalculationUtils.calculateConsistency([8, 12, 10, 10]), closeTo(85.85, 0.01));

      // All zero inputs
      expect(CalculationUtils.calculateConsistency([0, 0, 0]), 0.0);
    });
  });
}
