import 'package:flutter_test/flutter_test.dart';
import 'package:moneymanager/common/date_time_utils.dart';

// Unit tests here were partially or fully written by ChatGPT-3.5.
void main() {
  group('subtractDay', () {
    test('Should subtract one day from a given DateTime', () {
      // Arrange
      final inputDateTime = DateTime(2023, 9, 6, 12, 0); // September 6, 2023
      final expectedDateTime = DateTime(2023, 9, 5, 12, 0); // September 5, 2023

      // Act
      final result = subtractDay(inputDateTime);

      // Assert
      expect(result, equals(expectedDateTime));
    });

    test('Should handle DateTime at the beginning of a month', () {
      // Arrange
      final inputDateTime = DateTime(2023, 9, 1, 0, 0); // September 1, 2023
      final expectedDateTime = DateTime(2023, 8, 31, 0, 0); // August 31, 2023

      // Act
      final result = subtractDay(inputDateTime);

      // Assert
      expect(result, equals(expectedDateTime));
    });

    test('Should handle DateTime at the beginning of a year', () {
      // Arrange
      final inputDateTime = DateTime(2023, 1, 1, 0, 0); // January 1, 2023
      final expectedDateTime = DateTime(2022, 12, 31, 0, 0); // December 31, 2022

      // Act
      final result = subtractDay(inputDateTime);

      // Assert
      expect(result, equals(expectedDateTime));
    });
  });

  group('subtractWeek', () {
    test('Should subtract one week from a given DateTime', () {
      // Arrange
      final inputDateTime = DateTime(2023, 9, 6, 12, 0); // September 6, 2023
      final expectedDateTime = DateTime(2023, 8, 30, 12, 0); // August 30, 2023

      // Act
      final result = subtractWeek(inputDateTime);

      // Assert
      expect(result, equals(expectedDateTime));
    });

    test('Should handle DateTime at the beginning of a month', () {
      // Arrange
      final inputDateTime = DateTime(2023, 9, 1, 0, 0); // September 1, 2023
      final expectedDateTime = DateTime(2023, 8, 25, 0, 0); // August 25, 2023

      // Act
      final result = subtractWeek(inputDateTime);

      // Assert
      expect(result, equals(expectedDateTime));
    });

    test('Should handle DateTime at the beginning of a year', () {
      // Arrange
      final inputDateTime = DateTime(2023, 1, 1, 0, 0); // January 1, 2023
      final expectedDateTime = DateTime(2022, 12, 25, 0, 0); // December 25, 2022

      // Act
      final result = subtractWeek(inputDateTime);

      // Assert
      expect(result, equals(expectedDateTime));
    });
  });

  group('subtractMonth', () {
    test('Should subtract one month from a given DateTime', () {
      // Arrange
      final inputDateTime = DateTime(2023, 9, 6, 12, 0); // September 6, 2023
      final expectedDateTime = DateTime(2023, 8, 6, 12, 0); // August 6, 2023

      // Act
      final result = subtractMonth(inputDateTime);

      // Assert
      expect(result, equals(expectedDateTime));
    });

    test('Should handle DateTime at the beginning of a year', () {
      // Arrange
      final inputDateTime = DateTime(2023, 1, 1, 0, 0); // January 1, 2023
      final expectedDateTime = DateTime(2022, 12, 1, 0, 0); // December 1, 2022

      // Act
      final result = subtractMonth(inputDateTime);

      // Assert
      expect(result, equals(expectedDateTime));
    });

    test('Should handle DateTime at the end of a month', () {
      // Arrange
      final inputDateTime = DateTime(2023, 9, 30, 0, 0); // September 30, 2023
      final expectedDateTime = DateTime(2023, 8, 30, 0, 0); // August 30, 2023

      // Act
      final result = subtractMonth(inputDateTime);

      // Assert
      expect(result, equals(expectedDateTime));
    });
  });

  group('subtractYear', () {
    test('Should subtract one year from a given DateTime', () {
      // Arrange
      final inputDateTime = DateTime(2023, 9, 6, 12, 0); // September 6, 2023
      final expectedDateTime = DateTime(2022, 9, 6, 12, 0); // September 6, 2022

      // Act
      final result = subtractYear(inputDateTime);

      // Assert
      expect(result, equals(expectedDateTime));
    });

    test('Should handle DateTime at the beginning of a year', () {
      // Arrange
      final inputDateTime = DateTime(2023, 1, 1, 0, 0); // January 1, 2023
      final expectedDateTime = DateTime(2022, 1, 1, 0, 0); // January 1, 2022

      // Act
      final result = subtractYear(inputDateTime);

      // Assert
      expect(result, equals(expectedDateTime));
    });

    test('Should handle leap years', () {
      // Arrange
      final inputDateTime = DateTime(2024, 2, 29, 0, 0); // February 29, 2024 (leap year)
      final expectedDateTime = DateTime(2023, 2, 28, 0, 0); // February 28, 2023 (non-leap year)

      // Act
      final result = subtractYear(inputDateTime);

      // Assert
      expect(result, equals(expectedDateTime));
    });
  });
}
