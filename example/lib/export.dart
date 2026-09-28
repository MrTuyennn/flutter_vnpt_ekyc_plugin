import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:flutter_vnpt_ekyc_plugin/flutter_vnpt_ekyc_plugin.dart';

/// Copies the front, back and face images from a completed `full` [result]
/// into one new folder under the app's documents directory, together with an
/// `info.json` holding the CCCD/ID data read by OCR.
///
/// Throws a [StateError] if the front, back or face image is missing — e.g.
/// the flow was not [VnptEkycFlow.full], or the user cancelled partway.
Future<Directory> exportEkycResult(VnptEkycResult result) async {
  final front = result.pathImageFront;
  final back = result.pathImageBack;
  final face =
      result.pathImageFace ??
      result.pathImageFaceNear ??
      result.pathImageFaceFar;
  if (front == null || back == null || face == null) {
    throw StateError(
      'Missing front, back or face image — run VnptEkycFlow.full to completion first.',
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
