// lib/core/util/bool_from_int_converter.dart

import 'package:json_annotation/json_annotation.dart';

/// Un convertidor de JSON para manejar los valores booleanos que el backend
/// envía como enteros (1 para true, 0 para false).
class BoolFromIntConverter implements JsonConverter<bool?, dynamic> {
  const BoolFromIntConverter();

  @override
  bool? fromJson(dynamic json) {
    if (json is bool) {
      return json;
    }
    if (json is int) {
      return json == 1;
    }
    return null;
  }

  @override
  int toJson(bool? object) {
    return object == true ? 1 : 0;
  }
}
