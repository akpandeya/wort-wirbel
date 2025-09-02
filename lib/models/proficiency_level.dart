/// Common European Framework of Reference for Languages (CEFR) proficiency levels
/// Used to categorize vocabulary difficulty for German language learning
enum ProficiencyLevel {
  a1,
  a2,
  b1,
  b2,
  c1,
  c2;

  /// Convert from string representation
  static ProficiencyLevel? fromString(String? value) {
    if (value == null) return null;
    
    switch (value.toUpperCase()) {
      case 'A1':
        return ProficiencyLevel.a1;
      case 'A2':
        return ProficiencyLevel.a2;
      case 'B1':
        return ProficiencyLevel.b1;
      case 'B2':
        return ProficiencyLevel.b2;
      case 'C1':
        return ProficiencyLevel.c1;
      case 'C2':
        return ProficiencyLevel.c2;
      default:
        return null;
    }
  }

  /// Convert to string representation
  String toDisplayString() {
    switch (this) {
      case ProficiencyLevel.a1:
        return 'A1';
      case ProficiencyLevel.a2:
        return 'A2';
      case ProficiencyLevel.b1:
        return 'B1';
      case ProficiencyLevel.b2:
        return 'B2';
      case ProficiencyLevel.c1:
        return 'C1';
      case ProficiencyLevel.c2:
        return 'C2';
    }
  }
}