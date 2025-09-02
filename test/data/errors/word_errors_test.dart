import 'package:flutter_test/flutter_test.dart';
import 'package:wort_wirbel/data/errors/word_errors.dart';

void main() {
  group('WordError Taxonomy', () {
    group('WordValidationError', () {
      test('should create error for required field', () {
        // Act
        final error = WordValidationError.requiredField('lemma');

        // Assert
        expect(error.field, equals('lemma'));
        expect(error.code, equals('REQUIRED_FIELD'));
        expect(error.message, contains('Required field "lemma" is missing or empty'));
      });

      test('should create error for invalid format', () {
        // Act
        final error = WordValidationError.invalidFormat('date', '2024-13-45', 'ISO 8601');

        // Assert
        expect(error.field, equals('date'));
        expect(error.value, equals('2024-13-45'));
        expect(error.code, equals('INVALID_FORMAT'));
        expect(error.message, contains('invalid format'));
        expect(error.message, contains('ISO 8601'));
      });

      test('should create error for invalid length', () {
        // Act
        final error = WordValidationError.invalidLength('synonym', 'very long text', maxLength: 64);

        // Assert
        expect(error.field, equals('synonym'));
        expect(error.value, equals('very long text'));
        expect(error.code, equals('INVALID_LENGTH'));
        expect(error.message, contains('at most 64 characters'));
      });

      test('should create error for invalid list size', () {
        // Act
        final list = ['item1', 'item2', 'item3'];
        final error = WordValidationError.invalidListSize('synonyms', list, 2);

        // Assert
        expect(error.field, equals('synonyms'));
        expect(error.value, equals(list));
        expect(error.code, equals('INVALID_LIST_SIZE'));
        expect(error.message, contains('exceeds maximum size of 2 items'));
        expect(error.message, contains('got: 3'));
      });

      test('should implement proper toString', () {
        // Arrange
        final error = WordValidationError.requiredField('lemma');

        // Act
        final string = error.toString();

        // Assert
        expect(string, contains('WordValidationError'));
        expect(string, contains('field: lemma'));
      });
    });

    group('MappingError', () {
      test('should create error for missing required data', () {
        // Act
        final error = MappingError.missingRequiredData('id', 'WordDto', 'Word');

        // Assert
        expect(error.sourceType, equals('WordDto'));
        expect(error.targetType, equals('Word'));
        expect(error.code, equals('MISSING_REQUIRED_DATA'));
        expect(error.message, contains('required field "id" is missing'));
      });

      test('should create error for invalid data format', () {
        // Act
        final error = MappingError.invalidDataFormat('date', 'invalid-date', 'DTO', 'Domain');

        // Assert
        expect(error.sourceType, equals('DTO'));
        expect(error.targetType, equals('Domain'));
        expect(error.code, equals('INVALID_DATA_FORMAT'));
        expect(error.message, contains('invalid format: invalid-date'));
      });

      test('should create error for unsupported value', () {
        // Act
        final error = MappingError.unsupportedValue('pos', 'UNKNOWN_POS', 'DTO', 'Domain');

        // Assert
        expect(error.sourceType, equals('DTO'));
        expect(error.targetType, equals('Domain'));
        expect(error.code, equals('UNSUPPORTED_VALUE'));
        expect(error.message, contains('unsupported value: UNKNOWN_POS'));
      });

      test('should implement proper toString', () {
        // Arrange
        final error = MappingError.missingRequiredData('id', 'WordDto', 'Word');

        // Act
        final string = error.toString();

        // Assert
        expect(string, contains('MappingError'));
        expect(string, contains('WordDto → Word'));
      });
    });

    group('CacheError', () {
      test('should create error for not found', () {
        // Act
        final error = CacheError.notFound('test-id');

        // Assert
        expect(error.operation, equals('get'));
        expect(error.code, equals('NOT_FOUND'));
        expect(error.message, contains('Word with id "test-id" not found'));
      });

      test('should create error for put failed', () {
        // Act
        final originalError = Exception('Storage full');
        final error = CacheError.putFailed('test-id', originalError);

        // Assert
        expect(error.operation, equals('put'));
        expect(error.code, equals('PUT_FAILED'));
        expect(error.originalError, equals(originalError));
        expect(error.message, contains('Failed to put word with id "test-id"'));
      });

      test('should create error for refresh failed', () {
        // Act
        final originalError = Exception('Network error');
        final error = CacheError.refreshFailed(originalError);

        // Assert
        expect(error.operation, equals('refresh'));
        expect(error.code, equals('REFRESH_FAILED'));
        expect(error.originalError, equals(originalError));
        expect(error.message, contains('Failed to refresh cache'));
      });

      test('should create error for capacity exceeded', () {
        // Act
        final error = CacheError.capacityExceeded(100, 50);

        // Assert
        expect(error.operation, equals('put'));
        expect(error.code, equals('CAPACITY_EXCEEDED'));
        expect(error.message, contains('100 items, maximum: 50'));
      });

      test('should implement proper toString', () {
        // Arrange
        final error = CacheError.notFound('test-id');

        // Act
        final string = error.toString();

        // Assert
        expect(string, contains('CacheError'));
        expect(string, contains('operation: get'));
      });
    });

    group('ParseError', () {
      test('should create error for JSON parsing failed', () {
        // Act
        final originalError = FormatException('Invalid JSON');
        final error = ParseError.jsonParsingFailed('API response', originalError);

        // Assert
        expect(error.source, equals('API response'));
        expect(error.code, equals('JSON_PARSE_FAILED'));
        expect(error.originalError, equals(originalError));
        expect(error.message, contains('Failed to parse JSON data'));
      });

      test('should create error for date parsing failed', () {
        // Act
        final error = ParseError.dateParsingFailed('2024-13-45', 'DTO field');

        // Assert
        expect(error.source, equals('DTO field'));
        expect(error.code, equals('DATE_PARSE_FAILED'));
        expect(error.message, contains('Failed to parse date: "2024-13-45"'));
      });

      test('should create error for URL parsing failed', () {
        // Act
        final error = ParseError.urlParsingFailed('invalid-url', 'media field');

        // Assert
        expect(error.source, equals('media field'));
        expect(error.code, equals('URL_PARSE_FAILED'));
        expect(error.message, contains('Failed to parse URL: "invalid-url"'));
      });

      test('should implement proper toString', () {
        // Arrange
        final error = ParseError.dateParsingFailed('invalid-date', 'API field');

        // Act
        final string = error.toString();

        // Assert
        expect(string, contains('ParseError'));
        expect(string, contains('source: API field'));
      });
    });

    group('WordError base class', () {
      test('should implement Exception interface', () {
        // Arrange
        final error = WordValidationError.requiredField('test');

        // Assert
        expect(error, isA<Exception>());
        expect(error, isA<WordError>());
      });

      test('should provide proper error hierarchy', () {
        // Arrange
        final error = WordValidationError('Test message', field: 'test', code: 'TEST_CODE');

        // Act & Assert
        expect(error, isA<WordError>());
        expect(error, isA<Exception>());
        expect(error.message, equals('Test message'));
        expect(error.code, equals('TEST_CODE'));
        expect(error.field, equals('test'));
      });

      test('should handle missing code in toString', () {
        // Arrange
        final error = WordValidationError('Test message', field: 'test');

        // Act
        final string = error.toString();

        // Assert
        expect(string, contains('Test message'));
        expect(string, isNot(contains('code:')));
        expect(string, contains('field: test'));
      });
    });

    group('Error taxonomy completeness', () {
      test('should cover all major error scenarios', () {
        // This test ensures our error taxonomy covers the main error categories
        
        // Validation errors
        expect(WordValidationError.requiredField('test'), isA<WordValidationError>());
        expect(WordValidationError.invalidFormat('test', 'value', 'format'), isA<WordValidationError>());
        expect(WordValidationError.invalidLength('test', 'value'), isA<WordValidationError>());
        expect(WordValidationError.invalidListSize('test', [], 0), isA<WordValidationError>());

        // Mapping errors
        expect(MappingError.missingRequiredData('test', 'source', 'target'), isA<MappingError>());
        expect(MappingError.invalidDataFormat('test', 'value', 'source', 'target'), isA<MappingError>());
        expect(MappingError.unsupportedValue('test', 'value', 'source', 'target'), isA<MappingError>());

        // Cache errors
        expect(CacheError.notFound('id'), isA<CacheError>());
        expect(CacheError.putFailed('id', null), isA<CacheError>());
        expect(CacheError.refreshFailed(null), isA<CacheError>());
        expect(CacheError.capacityExceeded(1, 0), isA<CacheError>());

        // Parse errors
        expect(ParseError.jsonParsingFailed('source', null), isA<ParseError>());
        expect(ParseError.dateParsingFailed('date', 'source'), isA<ParseError>());
        expect(ParseError.urlParsingFailed('url', 'source'), isA<ParseError>());
      });
    });
  });
}