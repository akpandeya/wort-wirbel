/// Grammatical gender for German nouns
/// Used to store gender information for vocabulary learning
enum Gender {
  masculine,
  feminine,
  neuter,
  common;

  /// Convert from string representation, normalizing to uppercase
  static Gender? fromString(String? value) {
    if (value == null) return null;
    
    switch (value.toUpperCase()) {
      case 'M':
      case 'MASCULINE':
        return Gender.masculine;
      case 'F':
      case 'FEMININE':
        return Gender.feminine;
      case 'N':
      case 'NEUTER':
        return Gender.neuter;
      case 'COMMON':
        return Gender.common;
      default:
        return null;
    }
  }

  /// Convert to canonical string representation
  String toCanonicalString() {
    switch (this) {
      case Gender.masculine:
        return 'M';
      case Gender.feminine:
        return 'F';
      case Gender.neuter:
        return 'N';
      case Gender.common:
        return 'COMMON';
    }
  }

  /// Convert to display string with article
  String toDisplayString() {
    switch (this) {
      case Gender.masculine:
        return 'der (m.)';
      case Gender.feminine:
        return 'die (f.)';
      case Gender.neuter:
        return 'das (n.)';
      case Gender.common:
        return 'common';
    }
  }
}