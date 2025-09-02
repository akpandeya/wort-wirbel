import '../../models/word.dart';
import '../../models/universal_part_of_speech.dart';
import '../../models/proficiency_level.dart';
import '../../models/gender.dart';
import '../dtos/word_dto.dart';
import '../errors/word_errors.dart';

/// Mapper for converting between WordDto and Word domain entity
/// Implements validation and normalization rules as specified in issue #33
class WordMapper {
  static const int maxAlternativeDefinitions = 9; // Primary + 9 alt = 10 total
  static const int maxSynonyms = 10;
  static const int maxSynonymLength = 64;

  /// Convert WordDto to Word domain entity with validation and normalization
  static Word fromDto(WordDto dto) {
    try {
      // Validate and normalize required fields
      final id = _validateAndNormalizeId(dto.id);
      final lemma = _validateAndNormalizeLemma(dto.lemma);
      final language = _validateAndNormalizeLanguage(dto.lang);
      final universalPos = _mapUniversalPos(dto.pos);
      final primaryDefinition = _validateAndNormalizePrimaryDefinition(dto.defs);
      final updatedAt = _parseUpdatedAt(dto.updated);
      final createdAt = DateTime.now(); // Always set locally once

      // Process optional fields
      final languagePosTag = _normalizeLanguagePosTag(dto.posSpecific ?? dto.posTag);
      final alternativeDefinitions = _normalizeAlternativeDefinitions(dto.defs, primaryDefinition);
      final synonyms = _normalizeSynonyms(dto.synonyms);
      final examples = _normalizeExamples(dto.examples);
      final metadata = _createMetadata(dto, lemma);
      final media = _createMedia(dto);

      return Word(
        id: id,
        lemma: lemma,
        language: language,
        universalPos: universalPos,
        primaryDefinition: primaryDefinition,
        createdAt: createdAt,
        updatedAt: updatedAt,
        languagePosTag: languagePosTag,
        alternativeDefinitions: alternativeDefinitions,
        synonyms: synonyms,
        examples: examples,
        metadata: metadata,
        media: media,
      );
    } catch (e) {
      if (e is WordError) {
        rethrow;
      }
      throw MappingError(
        'Failed to map WordDto to Word: ${e.toString()}',
        sourceType: 'WordDto',
        targetType: 'Word',
        originalError: e,
      );
    }
  }

  /// Convert Word domain entity to WordDto for serialization
  static WordDto toDto(Word word) {
    try {
      return WordDto(
        id: word.id,
        lemma: word.lemma,
        lang: word.language,
        pos: word.universalPos.toCanonicalString(),
        posTag: word.languagePosTag,
        defs: _buildDefinitionsList(word.primaryDefinition, word.alternativeDefinitions),
        synonyms: word.synonyms,
        examples: word.examples?.map(_exampleToDto).toList(),
        freqRank: word.metadata?.frequencyRank,
        cefr: word.metadata?.proficiencyLevel?.toDisplayString(),
        gender: word.metadata?.gender?.toCanonicalString(),
        plural: word.metadata?.pluralForm,
        audio: word.media?.audioUrl,
        src: word.metadata?.sourceAttribution,
        updated: word.updatedAt,
      );
    } catch (e) {
      throw MappingError(
        'Failed to map Word to WordDto: ${e.toString()}',
        sourceType: 'Word',
        targetType: 'WordDto',
        originalError: e,
      );
    }
  }

  /// Validate and normalize ID field
  static String _validateAndNormalizeId(String? id) {
    final trimmed = id?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      throw WordValidationError.requiredField('id');
    }
    return trimmed;
  }

  /// Validate and normalize lemma field
  static String _validateAndNormalizeLemma(String? lemma) {
    final trimmed = lemma?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      throw WordValidationError.requiredField('lemma');
    }
    return trimmed;
  }

  /// Validate and normalize language field
  static String _validateAndNormalizeLanguage(String? language) {
    final trimmed = language?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return 'de'; // Default to German for MVP
    }
    return trimmed.toLowerCase();
  }

  /// Map part-of-speech to universal POS, defaulting to OTHER for unknown values
  static UniversalPartOfSpeech _mapUniversalPos(String? pos) {
    return UniversalPartOfSpeech.fromString(pos);
  }

  /// Validate and normalize primary definition from definitions list
  static String _validateAndNormalizePrimaryDefinition(List<String>? defs) {
    if (defs == null || defs.isEmpty) {
      throw WordValidationError.requiredField('primaryDefinition');
    }
    
    final trimmed = defs.first.trim();
    if (trimmed.isEmpty) {
      throw WordValidationError.requiredField('primaryDefinition');
    }
    
    return trimmed;
  }

  /// Parse updated timestamp, fallback to now if invalid
  static DateTime _parseUpdatedAt(DateTime? updated) {
    return updated ?? DateTime.now();
  }

  /// Normalize language-specific POS tag
  static String? _normalizeLanguagePosTag(String? posTag) {
    final trimmed = posTag?.trim();
    return (trimmed?.isEmpty ?? true) ? null : trimmed;
  }

  /// Normalize alternative definitions by removing duplicates and limiting count
  static List<String>? _normalizeAlternativeDefinitions(List<String>? defs, String primaryDefinition) {
    if (defs == null || defs.length <= 1) {
      return null;
    }

    final alternatives = <String>[];
    final primaryLower = primaryDefinition.toLowerCase();
    
    // Skip first element (primary definition) and process remaining
    for (int i = 1; i < defs.length && alternatives.length < maxAlternativeDefinitions; i++) {
      final trimmed = defs[i].trim();
      if (trimmed.isNotEmpty && trimmed.toLowerCase() != primaryLower) {
        // Check for case-insensitive duplicates within alternatives
        final trimmedLower = trimmed.toLowerCase();
        if (!alternatives.any((alt) => alt.toLowerCase() == trimmedLower)) {
          alternatives.add(trimmed);
        }
      }
    }

    return alternatives.isEmpty ? null : alternatives;
  }

  /// Normalize synonyms according to specification
  static List<String>? _normalizeSynonyms(List<String>? synonyms) {
    if (synonyms == null || synonyms.isEmpty) {
      return null;
    }

    final normalized = <String>[];
    final seen = <String>{};

    for (final synonym in synonyms) {
      final trimmed = synonym.trim();
      
      // Skip empty synonyms
      if (trimmed.isEmpty) continue;
      
      // Skip synonyms longer than max length
      if (trimmed.length > maxSynonymLength) continue;
      
      // Case-insensitive deduplication (first wins preserving original casing)
      final lowerCase = trimmed.toLowerCase();
      if (!seen.contains(lowerCase)) {
        seen.add(lowerCase);
        normalized.add(trimmed);
        
        // Limit to max synonyms
        if (normalized.length >= maxSynonyms) break;
      }
    }

    return normalized.isEmpty ? null : normalized;
  }

  /// Normalize examples by removing empty text entries
  static List<ExampleSentence>? _normalizeExamples(List<ExampleDto>? examples) {
    if (examples == null || examples.isEmpty) {
      return null;
    }

    final normalized = <ExampleSentence>[];
    
    for (final example in examples) {
      final text = example.text?.trim();
      if (text != null && text.isNotEmpty) {
        final translation = example.tr?.trim();
        normalized.add(ExampleSentence(
          text: text,
          translation: (translation?.isEmpty ?? true) ? null : translation,
        ));
      }
    }

    return normalized.isEmpty ? null : normalized;
  }

  /// Create metadata from DTO fields
  static WordMetadata? _createMetadata(WordDto dto, String normalizedLemma) {
    final frequencyRank = _normalizeFrequencyRank(dto.freqRank);
    final proficiencyLevel = ProficiencyLevel.fromString(dto.cefr);
    final gender = Gender.fromString(dto.gender);
    final pluralForm = _normalizePluralForm(dto.plural, normalizedLemma);
    final sourceAttribution = _normalizeSourceAttribution(dto.src);

    // Return null if all metadata fields are null
    if (frequencyRank == null && 
        proficiencyLevel == null && 
        gender == null && 
        pluralForm == null && 
        sourceAttribution == null) {
      return null;
    }

    return WordMetadata(
      frequencyRank: frequencyRank,
      proficiencyLevel: proficiencyLevel,
      gender: gender,
      pluralForm: pluralForm,
      sourceAttribution: sourceAttribution,
    );
  }

  /// Create media from DTO fields
  static WordMedia? _createMedia(WordDto dto) {
    final audioUrl = _normalizeAudioUrl(dto.audio);
    
    if (audioUrl == null) {
      return null;
    }

    return WordMedia(audioUrl: audioUrl);
  }

  /// Normalize frequency rank (must be positive integer)
  static int? _normalizeFrequencyRank(int? rank) {
    return (rank != null && rank > 0) ? rank : null;
  }

  /// Normalize plural form (omit if empty or equals lemma case-insensitive)
  static String? _normalizePluralForm(String? plural, String lemma) {
    final trimmed = plural?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    
    if (trimmed.toLowerCase() == lemma.toLowerCase()) {
      return null;
    }
    
    return trimmed;
  }

  /// Normalize source attribution
  static String? _normalizeSourceAttribution(String? src) {
    final trimmed = src?.trim();
    return (trimmed?.isEmpty ?? true) ? null : trimmed;
  }

  /// Normalize audio URL (must start with https://)
  static String? _normalizeAudioUrl(String? url) {
    final trimmed = url?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    
    if (!trimmed.startsWith('https://')) {
      return null; // Omit invalid URLs
    }
    
    return trimmed;
  }

  /// Build definitions list for DTO output
  static List<String> _buildDefinitionsList(String primary, List<String>? alternatives) {
    final defs = [primary];
    if (alternatives != null) {
      defs.addAll(alternatives);
    }
    return defs;
  }

  /// Convert ExampleSentence to ExampleDto
  static ExampleDto _exampleToDto(ExampleSentence example) {
    return ExampleDto(
      text: example.text,
      tr: example.translation,
    );
  }
}