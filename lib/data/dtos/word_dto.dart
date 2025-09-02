/// DTO for inbound API word data following the schema from issue #33
/// Maps from external API format to internal domain model
class WordDto {
  final String id;
  final String lemma;
  final String? lang;  // Maps to language
  final String? pos;   // Maps to universalPos
  final String? posSpecific; // Maps to languagePosTag  
  final String? posTag; // Alternative mapping to languagePosTag
  final List<String>? defs; // Maps to primaryDefinition + alternativeDefinitions
  final List<String>? synonyms;
  final List<ExampleDto>? examples;
  final int? freqRank; // Maps to metadata.frequencyRank
  final String? cefr; // Maps to metadata.proficiencyLevel
  final String? gender; // Maps to metadata.gender
  final String? plural; // Maps to metadata.pluralForm
  final String? audio; // Maps to media.audioUrl
  final String? src; // Maps to metadata.sourceAttribution
  final DateTime? updated; // Maps to updatedAt

  const WordDto({
    required this.id,
    required this.lemma,
    this.lang,
    this.pos,
    this.posSpecific,
    this.posTag,
    this.defs,
    this.synonyms,
    this.examples,
    this.freqRank,
    this.cefr,
    this.gender,
    this.plural,
    this.audio,
    this.src,
    this.updated,
  });

  /// Create WordDto from JSON map
  factory WordDto.fromJson(Map<String, dynamic> json) {
    return WordDto(
      id: json['id'] as String,
      lemma: json['lemma'] as String,
      lang: json['lang'] as String?,
      pos: json['pos'] as String?,
      posSpecific: json['pos_specific'] as String?,
      posTag: json['posTag'] as String?,
      defs: (json['defs'] as List<dynamic>?)?.cast<String>(),
      synonyms: (json['synonyms'] as List<dynamic>?)?.cast<String>(),
      examples: (json['examples'] as List<dynamic>?)
          ?.map((e) => ExampleDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      freqRank: json['freq_rank'] as int?,
      cefr: json['cefr'] as String?,
      gender: json['gender'] as String?,
      plural: json['plural'] as String?,
      audio: json['audio'] as String?,
      src: json['src'] as String?,
      updated: json['updated'] != null 
          ? DateTime.tryParse(json['updated'] as String)
          : null,
    );
  }

  /// Convert WordDto to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lemma': lemma,
      if (lang != null) 'lang': lang,
      if (pos != null) 'pos': pos,
      if (posSpecific != null) 'pos_specific': posSpecific,
      if (posTag != null) 'posTag': posTag,
      if (defs != null) 'defs': defs,
      if (synonyms != null) 'synonyms': synonyms,
      if (examples != null) 'examples': examples?.map((e) => e.toJson()).toList(),
      if (freqRank != null) 'freq_rank': freqRank,
      if (cefr != null) 'cefr': cefr,
      if (gender != null) 'gender': gender,
      if (plural != null) 'plural': plural,
      if (audio != null) 'audio': audio,
      if (src != null) 'src': src,
      if (updated != null) 'updated': updated?.toIso8601String(),
    };
  }

  @override
  String toString() => 'WordDto(id: $id, lemma: $lemma, lang: $lang, pos: $pos)';
}

/// DTO for example sentences in API format
class ExampleDto {
  final String? text;
  final String? tr; // Maps to translation

  const ExampleDto({
    this.text,
    this.tr,
  });

  /// Create ExampleDto from JSON map
  factory ExampleDto.fromJson(Map<String, dynamic> json) {
    return ExampleDto(
      text: json['text'] as String?,
      tr: json['tr'] as String?,
    );
  }

  /// Convert ExampleDto to JSON map
  Map<String, dynamic> toJson() {
    return {
      if (text != null) 'text': text,
      if (tr != null) 'tr': tr,
    };
  }

  @override
  String toString() => 'ExampleDto(text: $text, tr: $tr)';
}

/// DTO for API response containing word list
class WordListResponseDto {
  final List<WordDto> words;
  final DateTime? lastUpdated;

  const WordListResponseDto({
    required this.words,
    this.lastUpdated,
  });

  /// Create WordListResponseDto from JSON map
  factory WordListResponseDto.fromJson(Map<String, dynamic> json) {
    return WordListResponseDto(
      words: (json['words'] as List<dynamic>?)
          ?.map((e) => WordDto.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      lastUpdated: json['last_updated'] != null
          ? DateTime.tryParse(json['last_updated'] as String)
          : null,
    );
  }

  /// Convert WordListResponseDto to JSON map
  Map<String, dynamic> toJson() {
    return {
      'words': words.map((w) => w.toJson()).toList(),
      if (lastUpdated != null) 'last_updated': lastUpdated?.toIso8601String(),
    };
  }

  @override
  String toString() => 'WordListResponseDto(words: ${words.length} words, lastUpdated: $lastUpdated)';
}