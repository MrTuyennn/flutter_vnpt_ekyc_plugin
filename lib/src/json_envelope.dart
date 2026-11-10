import 'dart:convert';

/// Bóc chuỗi JSON của service VNPT có dạng `{"message": ..., "object": {...}}`
/// (hoặc một object phẳng, với một số kết quả QR) thành map phẳng có key là string.
/// Trả về null nếu [json] là null hoặc không phải JSON object.
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

/// Đọc [key] từ [data] dưới dạng chuỗi đã trim và không rỗng, hoặc null.
String? stringField(Map<String, Object?> data, String key) {
  final value = data[key];
  if (value == null) return null;
  final text = '$value'.trim();
  return text.isEmpty ? null : text;
}
