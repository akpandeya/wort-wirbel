import '../../models/word.dart';
import '../errors/word_errors.dart';

/// Interface for word caching operations
/// Provides fast lookups without reparsing DTOs and centralizes normalization
abstract class WordCache {
  /// Store a word in the cache
  void put(Word word);

  /// Retrieve a word by its ID
  Word? getById(String id);

  /// Get all words in the cache as a snapshot copy
  List<Word> listAll();

  /// Refresh cache with new data using provided load function
  Future<void> refresh(Future<List<Word>> Function() loadFn);

  /// Get current cache size
  int get size;

  /// Check if cache contains a word with given ID
  bool contains(String id);

  /// Clear all cached words
  void clear();
}

/// In-memory implementation of WordCache
/// Provides O(1) lookups with controlled memory footprint
class InMemoryWordCache implements WordCache {
  final Map<String, Word> _cache = {};
  final int? _maxCapacity;

  /// Create cache with optional capacity limit
  InMemoryWordCache({int? maxCapacity}) : _maxCapacity = maxCapacity;

  @override
  void put(Word word) {
    try {
      // Check capacity limit before adding new entries
      if (_maxCapacity != null && 
          !_cache.containsKey(word.id) && 
          _cache.length >= _maxCapacity!) {
        throw CacheError.capacityExceeded(_cache.length, _maxCapacity!);
      }

      _cache[word.id] = word;
    } catch (e) {
      if (e is CacheError) {
        rethrow;
      }
      throw CacheError.putFailed(word.id, e);
    }
  }

  @override
  Word? getById(String id) {
    return _cache[id];
  }

  @override
  List<Word> listAll() {
    // Return snapshot copy to prevent external modification
    return List.unmodifiable(_cache.values);
  }

  @override
  Future<void> refresh(Future<List<Word>> Function() loadFn) async {
    try {
      final words = await loadFn();
      
      // Clear existing cache
      _cache.clear();
      
      // Add all new words
      for (final word in words) {
        _cache[word.id] = word;
      }
    } catch (e) {
      throw CacheError.refreshFailed(e);
    }
  }

  @override
  int get size => _cache.length;

  @override
  bool contains(String id) {
    return _cache.containsKey(id);
  }

  @override
  void clear() {
    _cache.clear();
  }

  /// Get cache statistics for monitoring
  CacheStatistics getStatistics() {
    return CacheStatistics(
      size: _cache.length,
      maxCapacity: _maxCapacity,
      hitRate: null, // Could be implemented with hit/miss counters
    );
  }

  /// Update an existing word in the cache
  /// Returns true if word was updated, false if not found
  bool update(Word word) {
    if (_cache.containsKey(word.id)) {
      _cache[word.id] = word;
      return true;
    }
    return false;
  }

  /// Remove a word from the cache
  /// Returns the removed word or null if not found
  Word? remove(String id) {
    return _cache.remove(id);
  }

  /// Get multiple words by their IDs
  /// Returns map of found words (missing IDs will not be in result)
  Map<String, Word> getByIds(List<String> ids) {
    final result = <String, Word>{};
    for (final id in ids) {
      final word = _cache[id];
      if (word != null) {
        result[id] = word;
      }
    }
    return result;
  }

  /// Find words matching a predicate
  /// Useful for filtering by language, POS, level, etc.
  List<Word> findWhere(bool Function(Word) predicate) {
    return _cache.values.where(predicate).toList();
  }
}

/// Statistics about cache performance and state
class CacheStatistics {
  final int size;
  final int? maxCapacity;
  final double? hitRate;

  const CacheStatistics({
    required this.size,
    this.maxCapacity,
    this.hitRate,
  });

  /// Get capacity utilization percentage
  double? get capacityUtilization {
    if (maxCapacity == null || maxCapacity == 0) return null;
    return (size / maxCapacity!) * 100;
  }

  @override
  String toString() => 'CacheStatistics(size: $size, maxCapacity: $maxCapacity, hitRate: $hitRate)';
}