/// Base class for all word-related errors in the data layer
abstract class WordError implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const WordError(this.message, {this.code, this.originalError});

  @override
  String toString() => 'WordError: $message${code != null ? ' (code: $code)' : ''}';
}

/// Errors related to word validation during domain model creation
class WordValidationError extends WordError {
  final String field;
  final dynamic value;

  const WordValidationError(
    super.message, {
    required this.field,
    this.value,
    super.code,
  });

  /// Create error for required field validation
  factory WordValidationError.requiredField(String field) {
    return WordValidationError(
      'Required field "$field" is missing or empty',
      field: field,
      code: 'REQUIRED_FIELD',
    );
  }

  /// Create error for invalid field format
  factory WordValidationError.invalidFormat(String field, dynamic value, String expectedFormat) {
    return WordValidationError(
      'Field "$field" has invalid format. Expected: $expectedFormat, got: $value',
      field: field,
      value: value,
      code: 'INVALID_FORMAT',
    );
  }

  /// Create error for field length constraints
  factory WordValidationError.invalidLength(String field, dynamic value, {int? maxLength, int? minLength}) {
    String constraint = '';
    if (maxLength != null && minLength != null) {
      constraint = 'between $minLength and $maxLength';
    } else if (maxLength != null) {
      constraint = 'at most $maxLength';
    } else if (minLength != null) {
      constraint = 'at least $minLength';
    }
    
    return WordValidationError(
      'Field "$field" length must be $constraint characters, got: ${value?.toString().length ?? 0}',
      field: field,
      value: value,
      code: 'INVALID_LENGTH',
    );
  }

  /// Create error for invalid list size
  factory WordValidationError.invalidListSize(String field, List<dynamic> list, int maxSize) {
    return WordValidationError(
      'Field "$field" exceeds maximum size of $maxSize items, got: ${list.length}',
      field: field,
      value: list,
      code: 'INVALID_LIST_SIZE',
    );
  }

  @override
  String toString() => 'WordValidationError: $message (field: $field)';
}

/// Errors related to DTO to domain mapping
class MappingError extends WordError {
  final String sourceType;
  final String targetType;

  const MappingError(
    super.message, {
    required this.sourceType,
    required this.targetType,
    super.code,
    super.originalError,
  });

  /// Create error for missing required data
  factory MappingError.missingRequiredData(String field, String sourceType, String targetType) {
    return MappingError(
      'Cannot map $sourceType to $targetType: required field "$field" is missing',
      sourceType: sourceType,
      targetType: targetType,
      code: 'MISSING_REQUIRED_DATA',
    );
  }

  /// Create error for invalid data format during mapping
  factory MappingError.invalidDataFormat(String field, dynamic value, String sourceType, String targetType) {
    return MappingError(
      'Cannot map $sourceType to $targetType: field "$field" has invalid format: $value',
      sourceType: sourceType,
      targetType: targetType,
      code: 'INVALID_DATA_FORMAT',
    );
  }

  /// Create error for unsupported data value
  factory MappingError.unsupportedValue(String field, dynamic value, String sourceType, String targetType) {
    return MappingError(
      'Cannot map $sourceType to $targetType: field "$field" has unsupported value: $value',
      sourceType: sourceType,
      targetType: targetType,
      code: 'UNSUPPORTED_VALUE',
    );
  }

  @override
  String toString() => 'MappingError: $message ($sourceType → $targetType)';
}

/// Errors related to cache operations
class CacheError extends WordError {
  final String operation;

  const CacheError(
    super.message, {
    required this.operation,
    super.code,
    super.originalError,
  });

  /// Create error for cache miss
  factory CacheError.notFound(String id) {
    return CacheError(
      'Word with id "$id" not found in cache',
      operation: 'get',
      code: 'NOT_FOUND',
    );
  }

  /// Create error for cache put operation
  factory CacheError.putFailed(String id, dynamic originalError) {
    return CacheError(
      'Failed to put word with id "$id" into cache',
      operation: 'put',
      code: 'PUT_FAILED',
      originalError: originalError,
    );
  }

  /// Create error for cache refresh operation
  factory CacheError.refreshFailed(dynamic originalError) {
    return CacheError(
      'Failed to refresh cache',
      operation: 'refresh',
      code: 'REFRESH_FAILED',
      originalError: originalError,
    );
  }

  /// Create error for cache capacity exceeded
  factory CacheError.capacityExceeded(int currentSize, int maxCapacity) {
    return CacheError(
      'Cache capacity exceeded: $currentSize items, maximum: $maxCapacity',
      operation: 'put',
      code: 'CAPACITY_EXCEEDED',
    );
  }

  @override
  String toString() => 'CacheError: $message (operation: $operation)';
}

/// Errors related to data parsing from external sources
class ParseError extends WordError {
  final String source;
  final int? position;

  const ParseError(
    super.message, {
    required this.source,
    this.position,
    super.code,
    super.originalError,
  });

  /// Create error for JSON parsing failure
  factory ParseError.jsonParsingFailed(String source, dynamic originalError) {
    return ParseError(
      'Failed to parse JSON data',
      source: source,
      code: 'JSON_PARSE_FAILED',
      originalError: originalError,
    );
  }

  /// Create error for date parsing failure
  factory ParseError.dateParsingFailed(String dateString, String source) {
    return ParseError(
      'Failed to parse date: "$dateString"',
      source: source,
      code: 'DATE_PARSE_FAILED',
    );
  }

  /// Create error for URL parsing failure
  factory ParseError.urlParsingFailed(String url, String source) {
    return ParseError(
      'Failed to parse URL: "$url"',
      source: source,
      code: 'URL_PARSE_FAILED',
    );
  }

  @override
  String toString() => 'ParseError: $message (source: $source)';
}