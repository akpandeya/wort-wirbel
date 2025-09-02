/// Universal part-of-speech tags following the Universal Dependencies standard
/// Maps to different language-specific POS tags for normalization
enum UniversalPartOfSpeech {
  noun,
  verb,
  adjective,
  adverb,
  pronoun,
  determiner,
  preposition,
  conjunction,
  interjection,
  numeral,
  abbreviation,
  other;

  /// Convert from string representation, defaulting to 'other' for unknown values
  static UniversalPartOfSpeech fromString(String? value) {
    if (value == null) return UniversalPartOfSpeech.other;
    
    switch (value.toUpperCase()) {
      case 'NOUN':
        return UniversalPartOfSpeech.noun;
      case 'VERB':
        return UniversalPartOfSpeech.verb;
      case 'ADJ':
      case 'ADJECTIVE':
        return UniversalPartOfSpeech.adjective;
      case 'ADV':
      case 'ADVERB':
        return UniversalPartOfSpeech.adverb;
      case 'PRON':
      case 'PRONOUN':
        return UniversalPartOfSpeech.pronoun;
      case 'DET':
      case 'DETERMINER':
        return UniversalPartOfSpeech.determiner;
      case 'PREP':
      case 'PREPOSITION':
        return UniversalPartOfSpeech.preposition;
      case 'CONJ':
      case 'CONJUNCTION':
        return UniversalPartOfSpeech.conjunction;
      case 'INTJ':
      case 'INTERJECTION':
        return UniversalPartOfSpeech.interjection;
      case 'NUM':
      case 'NUMERAL':
        return UniversalPartOfSpeech.numeral;
      case 'ABBR':
      case 'ABBREVIATION':
        return UniversalPartOfSpeech.abbreviation;
      default:
        return UniversalPartOfSpeech.other;
    }
  }

  /// Convert to canonical string representation
  String toCanonicalString() {
    switch (this) {
      case UniversalPartOfSpeech.noun:
        return 'NOUN';
      case UniversalPartOfSpeech.verb:
        return 'VERB';
      case UniversalPartOfSpeech.adjective:
        return 'ADJ';
      case UniversalPartOfSpeech.adverb:
        return 'ADV';
      case UniversalPartOfSpeech.pronoun:
        return 'PRON';
      case UniversalPartOfSpeech.determiner:
        return 'DET';
      case UniversalPartOfSpeech.preposition:
        return 'PREP';
      case UniversalPartOfSpeech.conjunction:
        return 'CONJ';
      case UniversalPartOfSpeech.interjection:
        return 'INTJ';
      case UniversalPartOfSpeech.numeral:
        return 'NUM';
      case UniversalPartOfSpeech.abbreviation:
        return 'ABBR';
      case UniversalPartOfSpeech.other:
        return 'OTHER';
    }
  }
}