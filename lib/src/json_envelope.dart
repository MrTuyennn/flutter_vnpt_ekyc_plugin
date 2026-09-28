import 'dart:convert';

/// Unwraps a VNPT service JSON string of the shape `{"message": ..., "object":
/// {...}}` (or a flat object, for some QR results) into a flat string-keyed map.
/// Returns null if [json] is null or not a JSON object.
Map<String, Object?>? unwrapVnptJson(String? json) {
  if (json == null) return null;
  final Object? decoded;
  try {
    decoded = jsonDecode(json);
  } on FormatException {
    return null;
  }
  if (decoded is! Map) return null;

  final inner = decoded['object'];
  return <String, Object?>{
    for (final e in (inner is Map ? inner : decoded).entries)
      '${e.key}': e.value,
  };
}

/// Reads [key] from [data] as a trimmed, non-empty string, or null.
String? stringField(Map<String, Object?> data, String key) {
  final value = data[key];
  if (value == null) return null;
  final text = '$value'.trim();
  return text.isEmpty ? null : text;
}
