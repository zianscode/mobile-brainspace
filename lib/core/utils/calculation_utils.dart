import 'dart:math';

class CalculationUtils {
  /// Calculates the accuracy as a percentage (0.0 to 100.0).
  static double calculateAccuracy({required int totalCorrect, required int totalAnswered}) {
    if (totalAnswered <= 0) return 0.0;
    return (totalCorrect / totalAnswered) * 100.0;
  }

  /// Calculates consistency based on standard deviation of performance per interval.
  /// Formula: 100 * (1 - (StandardDeviation / Mean))
  /// Returns a value clamped between 0.0 and 100.0.
  static double calculateConsistency(List<int> answersPerInterval) {
    if (answersPerInterval.isEmpty) return 0.0;

    final n = answersPerInterval.length;
    final double mean = answersPerInterval.reduce((a, b) => a + b) / n;

    if (mean == 0.0) return 0.0;

    // Calculate variance
    double varianceSum = 0.0;
    for (final value in answersPerInterval) {
      varianceSum += pow(value - mean, 2);
    }
    final double variance = varianceSum / n;
    final double stdDev = sqrt(variance);

    // Consistency score (higher standard deviation means lower consistency)
    final double score = 100.0 * (1.0 - (stdDev / mean));
    return score.clamp(0.0, 100.0);
  }
}
