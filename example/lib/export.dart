import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:flutter_vnpt_ekyc_plugin/flutter_vnpt_ekyc_plugin.dart';

/// Sao chép ảnh mặt trước, mặt sau và chân dung từ [result] của flow `full` đã
/// chạy xong vào một thư mục mới trong thư mục documents của app, kèm theo file
/// `info.json` chứa dữ liệu CCCD/giấy tờ đọc được qua OCR.
///
/// Ném ra [StateError] nếu thiếu ảnh mặt trước, mặt sau hoặc chân dung — ví dụ
/// flow chạy không phải [VnptEkycFlow.full], hoặc người dùng huỷ giữa chừng.
Future<Directory> exportEkycResult(VnptEkycResult result) async {
  final front = result.pathImageFront;
  final back = result.pathImageBack;
  final face =
      result.pathImageFace ??
      result.pathImageFaceNear ??
      result.pathImageFaceFar;
  if (front == null || back == null || face == null) {
    throw StateError(
      'Thiếu ảnh mặt trước, mặt sau hoặc chân dung — hãy chạy VnptEkycFlow.full cho xong trước đã.',
    );
  }

  final documents = await getApplicationDocumentsDirectory();
  final exportDir = Directory(
    '${documents.path}/ekyc_export/${DateTime.now().millisecondsSinceEpoch}',
  );
  await exportDir.create(recursive: true);

  Future<String> copyImage(String sourcePath, String name) async {
    final extension = sourcePath.contains('.')
        ? sourcePath.split('.').last
        : 'jpg';
    final copy = await File(sourcePath)
        .copy('${exportDir.path}/$name.$extension');
    return copy.uri.pathSegments.last;
  }

  final info = <String, Object?>{
    'exportedAt': DateTime.now().toIso8601String(),
    'images': {
      'front': await copyImage(front, 'front'),
      'back': await copyImage(back, 'back'),
      'face': await copyImage(face, 'face'),
    },
    'identity': result.identity?.toJson() ?? const <String, Object?>{},
  };
  await File('${exportDir.path}/info.json')
      .writeAsString(const JsonEncoder.withIndent('  ').convert(info));

  return exportDir;
}
