import 'package:flutter_test/flutter_test.dart';
import 'package:moneymanager/utils.dart';

void main() {
  group('generateUniqueInt', () {
    test('Should generate unique IDs when called in rapid succession', () {
      // Arrange
      const count = 100;
      final generatedIds = <int>{};

      // Act
      for (int i = 0; i < count; i++) {
        final id = generateUniqueInt();
        generatedIds.add(id);
      }

      // Assert
      // All IDs should be unique
      expect(generatedIds.length, equals(count),
          reason: 'All generated IDs should be unique');
    });

    test('Should generate strictly increasing IDs', () {
      // Arrange
      const count = 50;
      final generatedIds = <int>[];

      // Act
      for (int i = 0; i < count; i++) {
        final id = generateUniqueInt();
        generatedIds.add(id);
      }

      // Assert
      for (int i = 1; i < generatedIds.length; i++) {
        expect(generatedIds[i], greaterThan(generatedIds[i - 1]),
            reason: 'Each ID should be greater than the previous one');
      }
    });

    test('Should not generate duplicate IDs for default categories', () {
      // This test simulates the scenario described in the issue
      // where categories are created in a tight loop

      // Arrange
      const incomeCount = 5;
      const expenseCount = 17;
      final allIds = <int>{};

      // Act - Simulate creating income categories
      for (int i = 0; i < incomeCount; i++) {
        final id = generateUniqueInt();
        allIds.add(id);
      }

      // Act - Simulate creating expense categories
      for (int i = 0; i < expenseCount; i++) {
        final id = generateUniqueInt();
        allIds.add(id);
      }

      // Assert
      expect(allIds.length, equals(incomeCount + expenseCount),
          reason: 'Should generate ${incomeCount + expenseCount} unique IDs');
    });
  });
}
