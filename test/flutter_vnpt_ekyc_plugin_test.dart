import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_vnpt_ekyc_plugin/flutter_vnpt_ekyc_plugin.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('flutter_vnpt_ekyc_plugin');
  final calls = <MethodCall>[];

  void mockResponse(Object? Function(MethodCall) handler) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          calls.add(call);
          return handler(call);
        });
  }

  setUp(calls.clear);

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  const config = VnptEkycConfig(
    accessToken: 'Bearer a',
    tokenId: 'i',
    tokenKey: 'k',
  );

  group('VnptEkycConfig.toMap', () {
    test('omits unset options', () {
      expect(config.toMap(), {
        'accessToken': 'Bearer a',
        'tokenId': 'i',
        'tokenKey': 'k',
      });
    });

    test('serialises enums by name', () {
      final map = const VnptEkycConfig(
        accessToken: 'a',
        tokenId: 'i',
        tokenKey: 'k',
        documentType: VnptDocumentType.identityCardChip,
        livenessMode: VnptLivenessMode.iBeta,
        blockedDocuments: [VnptBlockedDocument.passport],
        zoomCamera: 1.5,
      ).toMap();
      expect(map['documentType'], 'identityCardChip');
      expect(map['livenessMode'], 'iBeta');
      expect(map['blockedDocuments'], ['passport']);
      expect(map['zoomCamera'], 1.5);
    });

    test('allows empty credentials when offline', () {
      final map = const VnptEkycConfig(
        accessToken: '',
        tokenId: '',
        tokenKey: '',
        offline: true,
      ).toMap();
      expect(map, {
        'accessToken': '',
        'tokenId': '',
        'tokenKey': '',
        'offline': true,
      });
    });
  });

  group('VnptEkyc.start', () {
    test('sends flow and config and parses a completed result', () async {
      mockResponse(
        (_) => {
          'status': 'completed',
          'ocrResult': '{"id":"1"}',
          'hashImageFront': 'abc',
          'pathImageFront': '/tmp/front.jpg',
          'pathImageBack': '',
          'compareQrCodeOcr': true,
          'errorClient': ['Simulator'],
        },
      );

      final result = await VnptEkyc.start(VnptEkycFlow.ocrFront, config);

      expect(calls.single.method, 'start');
      expect(calls.single.arguments, {
        'flow': 'ocrFront',
        'config': config.toMap(),
      });
      expect(result.status, VnptEkycStatus.completed);
      expect(result.ocrResult, '{"id":"1"}');
      expect(result.hashImageFront, 'abc');
      expect(result.pathImageBack, isNull);
      expect(result.compareQrCodeOcr, isTrue);
      expect(result.errorClient, ['Simulator']);
      expect(result.imagePaths, ['/tmp/front.jpg']);
    });

    test('parses a cancelled result', () async {
      mockResponse((_) => {'status': 'cancelled', 'lastStep': 'Capture_Front'});

      final result = await VnptEkyc.start(VnptEkycFlow.full, config);

      expect(result.status, VnptEkycStatus.cancelled);
      expect(result.lastStep, 'Capture_Front');
      expect(result.ocrResult, isNull);
    });

    test('propagates native errors', () async {
      mockResponse(
        (_) => throw PlatformException(code: 'camera_permission_denied'),
      );

      expect(
        VnptEkyc.start(VnptEkycFlow.face, config),
        throwsA(
          isA<PlatformException>().having(
            (e) => e.code,
            'code',
            'camera_permission_denied',
          ),
        ),
      );
    });
  });

  group('VnptIdentity.tryParse', () {
    test('reads the wrapped OCR object', () {
      final identity = VnptIdentity.tryParse(
        '{"message":"IDG-00000000","object":{"id":"012345678901","name":"NGUYEN VAN A",'
        '"birth_day":"01/02/1990","gender":"Nam","type_id":2,"valid_date":"01/02/2030",'
        '"recent_location":"Ha Noi","warning_msg":["w"],"tampering":{"is_legal":"yes"}}}',
      );

      expect(identity?.id, '012345678901');
      expect(identity?.name, 'NGUYEN VAN A');
      expect(identity?.birthDay, '01/02/1990');
      expect(identity?.typeId, '2');
      expect(identity?.validDate, '01/02/2030');
      expect(identity?.warnings, ['w']);
      expect(identity?.isLegal, isTrue);
      expect(identity?.passportNo, isNull);
      expect(identity?.toJson(), {
        'id': '012345678901',
        'name': 'NGUYEN VAN A',
        'birthDay': '01/02/1990',
        'gender': 'Nam',
        'typeId': '2',
        'validDate': '01/02/2030',
        'recentLocation': 'Ha Noi',
        'isLegal': true,
        'warnings': ['w'],
      });
    });

    test(
      'reads tampering.is_legal as either a real bool or a "yes"/"no" string',
      () {
        for (final (raw, expected) in [
          ('true', true),
          ('false', false),
          ('"yes"', true),
          ('"no"', false),
          ('"YES"', true),
          ('"maybe"', null),
        ]) {
          final identity = VnptIdentity.tryParse(
            '{"id":"1","tampering":{"is_legal":$raw}}',
          );
          expect(identity?.isLegal, expected, reason: 'is_legal: $raw');
        }
      },
    );

    test('reads a flat QR object', () {
      final identity = VnptIdentity.tryParse(
        '{"id":"1","name":"B","expired_date":"x"}',
      );
      expect(identity?.validDate, 'x');
    });

    test('returns null for missing or invalid json', () {
      expect(VnptIdentity.tryParse(null), isNull);
      expect(VnptIdentity.tryParse('not json'), isNull);
      expect(VnptIdentity.tryParse('[1]'), isNull);
    });

    test('is exposed on the result', () {
      final result = VnptEkycResult.fromMap({
        'status': 'completed',
        'ocrResult': '{"object":{"name":"C"}}',
      });
      expect(result.identity?.name, 'C');
      expect(result.qrIdentity, isNull);
    });
  });

  group('check results', () {
    test('VnptFaceCompare.tryParse reads CompareFaceObject fields', () {
      final compare = VnptFaceCompare.tryParse(
        '{"object":{"msg":"ok","result":"match","prob":97.5,"multiple_faces":false}}',
      );
      expect(compare?.message, 'ok');
      expect(compare?.result, 'match');
      expect(compare?.probability, 97.5);
      expect(compare?.multipleFaces, isFalse);
      expect(compare?.toJson(), {
        'message': 'ok',
        'result': 'match',
        'probability': 97.5,
        'multipleFaces': false,
      });
    });

    test('VnptLiveness.tryParse reads LivenessResult fields', () {
      final liveness = VnptLiveness.tryParse(
        '{"object":{"liveness_msg":"ok","liveness":"real","is_eye_open":"yes",'
        '"face_swapping":false,"fake_liveness":false,"blur_face":"no"}}',
      );
      expect(liveness?.message, 'ok');
      expect(liveness?.liveness, 'real');
      expect(liveness?.isEyeOpen, 'yes');
      expect(liveness?.faceSwapping, isFalse);
      expect(liveness?.fakeLiveness, isFalse);
      expect(liveness?.blurFace, 'no');
      expect(liveness?.toJson(), {
        'message': 'ok',
        'liveness': 'real',
        'isEyeOpen': 'yes',
        'faceSwapping': false,
        'fakeLiveness': false,
        'blurFace': 'no',
      });
    });

    test('VnptMaskCheck.tryParse reads MaskedObject fields', () {
      final mask = VnptMaskCheck.tryParse('{"object":{"masked":"no"}}');
      expect(mask?.masked, 'no');
      expect(mask?.toJson(), {'masked': 'no'});
    });

    test('are all null when the underlying result is missing', () {
      final result = VnptEkycResult.fromMap({'status': 'completed'});
      expect(result.faceCompare, isNull);
      expect(result.faceLiveness, isNull);
      expect(result.cardFrontLiveness, isNull);
      expect(result.cardBackLiveness, isNull);
      expect(result.maskCheck, isNull);
    });

    test('are exposed on the result', () {
      final result = VnptEkycResult.fromMap({
        'status': 'completed',
        'compareFaceResult': '{"object":{"result":"match"}}',
        'livenessFaceResult': '{"object":{"liveness":"real"}}',
        'livenessCardFrontResult': '{"object":{"liveness":"real"}}',
        'livenessCardBackResult': '{"object":{"liveness":"real"}}',
        'maskedFaceResult': '{"object":{"masked":"no"}}',
      });
      expect(result.faceCompare?.result, 'match');
      expect(result.faceLiveness?.liveness, 'real');
      expect(result.cardFrontLiveness?.liveness, 'real');
      expect(result.cardBackLiveness?.liveness, 'real');
      expect(result.maskCheck?.masked, 'no');
    });
  });
}
