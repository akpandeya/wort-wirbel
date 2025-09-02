import 'package:flutter_test/flutter_test.dart';
import 'package:wort_wirbel/data/cache/word_cache.dart';
import 'package:wort_wirbel/data/errors/word_errors.dart';
import 'package:wort_wirbel/models/word.dart';
import 'package:wort_wirbel/models/universal_part_of_speech.dart';

void main() {
  group('InMemoryWordCache', () {
    late InMemoryWordCache cache;
    late Word sampleWord;

    setUp(() {
      cache = InMemoryWordCache();
      sampleWord = Word(
        id: 'test-id',
        lemma: 'Haus',
        language: 'de',
        universalPos: UniversalPartOfSpeech.noun,
        primaryDefinition: 'house',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    });

    group('put and getById', () {
      test('should store and retrieve word correctly', () {
        // Act
        cache.put(sampleWord);
        final retrieved = cache.getById('test-id');

        // Assert
        expect(retrieved, equals(sampleWord));
        expect(cache.size, equals(1));
        expect(cache.contains('test-id'), isTrue);
      });

      test('should overwrite existing word with same ID', () {
        // Arrange
        final updatedWord = sampleWord.copyWith(
          primaryDefinition: 'updated house',
        );

        // Act
        cache.put(sampleWord);
        cache.put(updatedWord);
        final retrieved = cache.getById('test-id');

        // Assert
        expect(retrieved?.primaryDefinition, equals('updated house'));
        expect(cache.size, equals(1)); // Still only one entry
      });

      test('should return null for non-existent word', () {
        // Act
        final retrieved = cache.getById('non-existent');

        // Assert
        expect(retrieved, isNull);
      });

      test('should handle multiple words correctly', () {
        // Arrange
        final word2 = Word(
          id: 'test-id-2',
          lemma: 'Auto',
          language: 'de',
          universalPos: UniversalPartOfSpeech.noun,
          primaryDefinition: 'car',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Act
        cache.put(sampleWord);
        cache.put(word2);

        // Assert
        expect(cache.getById('test-id'), equals(sampleWord));
        expect(cache.getById('test-id-2'), equals(word2));
        expect(cache.size, equals(2));
      });
    });

    group('capacity constraints', () {
      test('should respect maxCapacity when provided', () {
        // Arrange
        final limitedCache = InMemoryWordCache(maxCapacity: 2);
        final word1 = sampleWord;
        final word2 = sampleWord.copyWith(id: 'test-id-2');
        final word3 = sampleWord.copyWith(id: 'test-id-3');

        // Act & Assert
        limitedCache.put(word1);
        limitedCache.put(word2);
        expect(limitedCache.size, equals(2));

        // Should throw when capacity exceeded
        expect(
          () => limitedCache.put(word3),
          throwsA(isA<CacheError>().having((e) => e.code, 'code', 'CAPACITY_EXCEEDED')),
        );
      });

      test('should allow updates when at capacity', () {
        // Arrange
        final limitedCache = InMemoryWordCache(maxCapacity: 1);
        final updatedWord = sampleWord.copyWith(primaryDefinition: 'updated');

        // Act
        limitedCache.put(sampleWord);
        limitedCache.put(updatedWord); // Should not throw (same ID)

        // Assert
        expect(limitedCache.size, equals(1));
        expect(limitedCache.getById('test-id')?.primaryDefinition, equals('updated'));
      });
    });

    group('listAll', () {
      test('should return empty list when cache is empty', () {
        // Act
        final allWords = cache.listAll();

        // Assert
        expect(allWords, isEmpty);
      });

      test('should return all cached words', () {
        // Arrange
        final word2 = sampleWord.copyWith(id: 'test-id-2', lemma: 'Auto');
        cache.put(sampleWord);
        cache.put(word2);

        // Act
        final allWords = cache.listAll();

        // Assert
        expect(allWords, hasLength(2));
        expect(allWords, containsAll([sampleWord, word2]));
      });

      test('should return immutable list', () {
        // Arrange
        cache.put(sampleWord);

        // Act
        final allWords = cache.listAll();

        // Assert
        expect(allWords, isA<List<Word>>());
        // The returned list should be unmodifiable
        expect(() => allWords.clear(), throwsUnsupportedError);
      });
    });

    group('refresh', () {
      test('should replace cache contents with loaded words', () async {
        // Arrange
        cache.put(sampleWord);
        final newWord1 = Word(
          id: 'new-1',
          lemma: 'Auto',
          language: 'de',
          universalPos: UniversalPartOfSpeech.noun,
          primaryDefinition: 'car',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        final newWord2 = Word(
          id: 'new-2',
          lemma: 'Buch',
          language: 'de',
          universalPos: UniversalPartOfSpeech.noun,
          primaryDefinition: 'book',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Act
        await cache.refresh(() async => [newWord1, newWord2]);

        // Assert
        expect(cache.size, equals(2));
        expect(cache.getById('test-id'), isNull); // Old word removed
        expect(cache.getById('new-1'), equals(newWord1));
        expect(cache.getById('new-2'), equals(newWord2));
      });

      test('should handle empty refresh correctly', () async {
        // Arrange
        cache.put(sampleWord);

        // Act
        await cache.refresh(() async => []);

        // Assert
        expect(cache.size, equals(0));
        expect(cache.getById('test-id'), isNull);
      });

      test('should throw CacheError when load function fails', () async {
        // Arrange
        Future<List<Word>> failingLoadFn() async {
          throw Exception('Load failed');
        }

        // Act & Assert
        expect(
          () => cache.refresh(failingLoadFn),
          throwsA(isA<CacheError>().having((e) => e.operation, 'operation', 'refresh')),
        );
      });
    });

    group('contains', () {
      test('should return true for existing word', () {
        // Arrange
        cache.put(sampleWord);

        // Act & Assert
        expect(cache.contains('test-id'), isTrue);
      });

      test('should return false for non-existent word', () {
        // Act & Assert
        expect(cache.contains('non-existent'), isFalse);
      });
    });

    group('clear', () {
      test('should remove all words from cache', () {
        // Arrange
        cache.put(sampleWord);
        cache.put(sampleWord.copyWith(id: 'test-id-2'));
        expect(cache.size, equals(2));

        // Act
        cache.clear();

        // Assert
        expect(cache.size, equals(0));
        expect(cache.getById('test-id'), isNull);
        expect(cache.getById('test-id-2'), isNull);
      });
    });

    group('additional operations', () {
      test('update should modify existing word', () {
        // Arrange
        cache.put(sampleWord);
        final updatedWord = sampleWord.copyWith(primaryDefinition: 'updated house');

        // Act
        final result = cache.update(updatedWord);

        // Assert
        expect(result, isTrue);
        expect(cache.getById('test-id')?.primaryDefinition, equals('updated house'));
      });

      test('update should return false for non-existent word', () {
        // Act
        final result = cache.update(sampleWord);

        // Assert
        expect(result, isFalse);
        expect(cache.size, equals(0));
      });

      test('remove should remove and return word', () {
        // Arrange
        cache.put(sampleWord);

        // Act
        final removed = cache.remove('test-id');

        // Assert
        expect(removed, equals(sampleWord));
        expect(cache.contains('test-id'), isFalse);
        expect(cache.size, equals(0));
      });

      test('remove should return null for non-existent word', () {
        // Act
        final removed = cache.remove('non-existent');

        // Assert
        expect(removed, isNull);
      });

      test('getByIds should return map of found words', () {
        // Arrange
        final word2 = sampleWord.copyWith(id: 'test-id-2', lemma: 'Auto');
        cache.put(sampleWord);
        cache.put(word2);

        // Act
        final result = cache.getByIds(['test-id', 'test-id-2', 'non-existent']);

        // Assert
        expect(result, hasLength(2));
        expect(result['test-id'], equals(sampleWord));
        expect(result['test-id-2'], equals(word2));
        expect(result.containsKey('non-existent'), isFalse);
      });

      test('findWhere should filter words correctly', () {
        // Arrange
        final nounWord = sampleWord;
        final verbWord = Word(
          id: 'verb-id',
          lemma: 'laufen',
          language: 'de',
          universalPos: UniversalPartOfSpeech.verb,
          primaryDefinition: 'to run',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        cache.put(nounWord);
        cache.put(verbWord);

        // Act
        final nouns = cache.findWhere((word) => word.universalPos == UniversalPartOfSpeech.noun);

        // Assert
        expect(nouns, hasLength(1));
        expect(nouns.first, equals(nounWord));
      });
    });

    group('getStatistics', () {
      test('should return correct statistics', () {
        // Arrange
        final limitedCache = InMemoryWordCache(maxCapacity: 10);
        limitedCache.put(sampleWord);
        limitedCache.put(sampleWord.copyWith(id: 'test-id-2'));

        // Act
        final stats = limitedCache.getStatistics();

        // Assert
        expect(stats.size, equals(2));
        expect(stats.maxCapacity, equals(10));
        expect(stats.capacityUtilization, equals(20.0));
      });

      test('should handle unlimited capacity correctly', () {
        // Arrange
        cache.put(sampleWord);

        // Act
        final stats = cache.getStatistics();

        // Assert
        expect(stats.size, equals(1));
        expect(stats.maxCapacity, isNull);
        expect(stats.capacityUtilization, isNull);
      });
    });
  });
}