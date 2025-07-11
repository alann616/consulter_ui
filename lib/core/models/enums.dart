import 'package:json_annotation/json_annotation.dart';

// Basado en tu backend: alann616/consulter/consulter-19c7a0e2a6fe07f587f1b3d77b1135851fc4e673/src/main/java/com/alann616/consulter/enums/Gender.java
enum Gender {
  @JsonValue("M")
  MALE,
  @JsonValue("F")
  FEMALE,
}

// Basado en tu backend: alann616/consulter/consulter-19c7a0e2a6fe07f587f1b3d77b1135851fc4e673/src/main/java/com/alann616/consulter/enums/DocumentType.java
enum DocumentType {
  @JsonValue("PRESCRIPTION")
  PRESCRIPTION,
  @JsonValue("CLINICAL_HISTORY")
  CLINICAL_HISTORY,
  @JsonValue("EVOLUTION_NOTE")
  EVOLUTION_NOTE,
}
