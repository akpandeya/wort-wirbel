import 'universal_part_of_speech.dart';
import 'proficiency_level.dart';
import 'gender.dart';

/// Value object representing an example sentence with optional translation
class ExampleSentence {
  final String text;
  final String? translation;

  const ExampleSentence({
    required this.text,
    this.translation,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExampleSentence &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          translation == other.translation;

  @override
  int get hashCode => text.hashCode ^ translation.hashCode;

  @override
  String toString() => 'ExampleSentence(text: $text, translation: $translation)';
}

/// Value object containing metadata about a word
class WordMetadata {
  final int? frequencyRank;
  final ProficiencyLevel? proficiencyLevel;
  final Gender? gender;
  final String? pluralForm;
  final String? sourceAttribution;

  const WordMetadata({
    this.frequencyRank,
    this.proficiencyLevel,
    this.gender,
    this.pluralForm,
    this.sourceAttribution,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordMetadata &&
          runtimeType == other.runtimeType &&
          frequencyRank == other.frequencyRank &&
          proficiencyLevel == other.proficiencyLevel &&
          gender == other.gender &&
          pluralForm == other.pluralForm &&
          sourceAttribution == other.sourceAttribution;

  @override
  int get hashCode =>
      frequencyRank.hashCode ^
      proficiencyLevel.hashCode ^
      gender.hashCode ^
      pluralForm.hashCode ^
      sourceAttribution.hashCode;

  @override
  String toString() =>
      'WordMetadata(frequencyRank: $frequencyRank, proficiencyLevel: $proficiencyLevel, gender: $gender, pluralForm: $pluralForm, sourceAttribution: $sourceAttribution)';
}

/// Value object containing media resources for a word
class WordMedia {
  final String? audioUrl;

  const WordMedia({
    this.audioUrl,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordMedia &&
          runtimeType == other.runtimeType &&
          audioUrl == other.audioUrl;

  @override
  int get hashCode => audioUrl.hashCode;

  @override
  String toString() => 'WordMedia(audioUrl: $audioUrl)';
}

/// Aggregate root representing a German vocabulary word with its definitions and metadata
/// This is the core domain entity for the vocabulary learning system
class Word {
  // Required fields
  final String id;
  final String lemma;
  final String language;
  final UniversalPartOfSpeech universalPos;
  final String primaryDefinition;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Optional fields
  final String? languagePosTag;
  final List<String>? alternativeDefinitions;
  final List<String>? synonyms;
  final List<ExampleSentence>? examples;
  final WordMetadata? metadata;
  final WordMedia? media;

  const Word({
    required this.id,
    required this.lemma,
    required this.language,
    required this.universalPos,
    required this.primaryDefinition,
    required this.createdAt,
    required this.updatedAt,
    this.languagePosTag,
    this.alternativeDefinitions,
    this.synonyms,
    this.examples,
    this.metadata,
    this.media,
  });

  /// Create a copy of this word with updated fields
  Word copyWith({
    String? id,
    String? lemma,
    String? language,
    UniversalPartOfSpeech? universalPos,
    String? primaryDefinition,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? languagePosTag,
    List<String>? alternativeDefinitions,
    List<String>? synonyms,
    List<ExampleSentence>? examples,
    WordMetadata? metadata,
    WordMedia? media,
  }) {
    return Word(
      id: id ?? this.id,
      lemma: lemma ?? this.lemma,
      language: language ?? this.language,
      universalPos: universalPos ?? this.universalPos,
      primaryDefinition: primaryDefinition ?? this.primaryDefinition,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      languagePosTag: languagePosTag ?? this.languagePosTag,
      alternativeDefinitions: alternativeDefinitions ?? this.alternativeDefinitions,
      synonyms: synonyms ?? this.synonyms,
      examples: examples ?? this.examples,
      metadata: metadata ?? this.metadata,
      media: media ?? this.media,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Word &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          lemma == other.lemma &&
          language == other.language &&
          universalPos == other.universalPos &&
          primaryDefinition == other.primaryDefinition &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          languagePosTag == other.languagePosTag &&
          _listEquals(alternativeDefinitions, other.alternativeDefinitions) &&
          _listEquals(synonyms, other.synonyms) &&
          _listEquals(examples, other.examples) &&
          metadata == other.metadata &&
          media == other.media;

  @override
  int get hashCode =>
      id.hashCode ^
      lemma.hashCode ^
      language.hashCode ^
      universalPos.hashCode ^
      primaryDefinition.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      languagePosTag.hashCode ^
      (alternativeDefinitions?.join().hashCode ?? 0) ^
      (synonyms?.join().hashCode ?? 0) ^
      (examples?.join().hashCode ?? 0) ^
      metadata.hashCode ^
      media.hashCode;

  @override
  String toString() =>
      'Word(id: $id, lemma: $lemma, language: $language, universalPos: $universalPos, primaryDefinition: $primaryDefinition, createdAt: $createdAt, updatedAt: $updatedAt, languagePosTag: $languagePosTag, alternativeDefinitions: $alternativeDefinitions, synonyms: $synonyms, examples: $examples, metadata: $metadata, media: $media)';

  /// Helper method to compare lists for equality
  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}