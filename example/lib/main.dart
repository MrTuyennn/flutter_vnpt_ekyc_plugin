import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vnpt_ekyc_plugin/flutter_vnpt_ekyc_plugin.dart';

import 'export.dart';

// flutter run --dart-define=VNPT_ACCESS_TOKEN="Bearer ..." --dart-define=VNPT_TOKEN_ID=... --dart-define=VNPT_TOKEN_KEY=...
//
// Without those defines this runs in offline mode (config.offline = true): no VNPT
// credentials needed, no server calls made. You still get to test the capture UI,
// camera permission and this plugin's wiring; you only lose the OCR/compare/liveness
// results, which need a real token.
const _accessToken = String.fromEnvironment('VNPT_ACCESS_TOKEN');
const _tokenId = String.fromEnvironment('VNPT_TOKEN_ID');
const _tokenKey = String.fromEnvironment('VNPT_TOKEN_KEY');
const _offline = _accessToken == '';

void main() => runApp(const MaterialApp(home: ExamplePage()));

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  String _output = 'Pick a flow.';
  VnptEkycResult? _last;

  Future<void> _run(VnptEkycFlow flow) async {
    setState(() => _output = 'Running ${flow.name}...');
    try {
      final result = await VnptEkyc.start(
        flow,
        VnptEkycConfig(
          accessToken: _accessToken,
          tokenId: _tokenId,
          tokenKey: _tokenKey,
          faceMode: VnptFaceMode.advanced,
          showTutorial: true,
          enableGotIt: true,
          livenessMode: VnptLivenessMode.iBeta,
          checkMaskedFace: true,
          enableCompare: flow == VnptEkycFlow.full,
          hashImageCompare: flow == VnptEkycFlow.face
              ? _last?.hashImageFront
              : null,
          hashFrontOcr: flow == VnptEkycFlow.ocrBack
              ? _last?.hashImageFront
              : null,
          offline: _offline,
        ),
      );
      _last = result;
      // debugPrint still runs in release builds, so this is gated on kDebugMode:
      // once you switch to a real token for the release build, this stays off.
      if (kDebugMode) {
        debugPrint(
          'flutter_vnpt_ekyc_plugin identity (OCR): ${_describeJson(result.identity?.toJson())}',
        );
        debugPrint(
          'flutter_vnpt_ekyc_plugin identity (QR): ${_describeJson(result.qrIdentity?.toJson())}',
        );
      }
      setState(
        () => _output =
            'status: ${result.status.name}\nlastStep: ${result.lastStep}\n'
            'pathImageFront: ${result.pathImageFront}\n'
            'hashFront: ${result.hashImageFront}\nclientSession: ${result.clientSession}\n'
            'networkProblem: ${result.networkProblem}\n'
            'compareQrCodeOcr: ${result.compareQrCodeOcr}\n\n'
            'identity (OCR): ${_describeJson(result.identity?.toJson())}\n\n'
            'identity (QR): ${_describeJson(result.qrIdentity?.toJson())}\n\n'
            'faceCompare: ${_describeJson(result.faceCompare?.toJson())}\n\n'
            'faceLiveness: ${_describeJson(result.faceLiveness?.toJson())}\n\n'
            'cardFrontLiveness: ${_describeJson(result.cardFrontLiveness?.toJson())}\n\n'
            'cardBackLiveness: ${_describeJson(result.cardBackLiveness?.toJson())}\n\n'
            'maskCheck: ${_describeJson(result.maskCheck?.toJson())}',
      );
    } on PlatformException catch (e) {
      setState(() => _output = '${e.code}: ${e.message}');
    } catch (e) {
      // Anything not thrown as PlatformException — e.g. MissingPluginException if the
      // plugin isn't linked on this platform — still needs to show up as text instead
      // of crashing to a red error screen.
      setState(() => _output = 'Unexpected error: $e');
    }
  }

  Future<void> _export() async {
    final result = _last;
    if (result == null) return;
    try {
      final dir = await exportEkycResult(result);
      setState(() => _output = 'Exported to:\n${dir.path}');
    } on StateError catch (e) {
      setState(() => _output = e.message);
    } catch (e) {
      setState(() => _output = 'Unexpected error: $e');
    }
  }

  String _describeJson(Map<String, Object?>? json) {
    if (json == null || json.isEmpty) return '(none)';
    return json.entries.map((e) => '${e.key}: ${e.value}').join('\n');
  }

  Widget _buildImagePreview() {
    final result = _last;
    if (result == null) return const SizedBox.shrink();

    final images = {
      'Front': result.pathImageFront,
      'Back': result.pathImageBack,
      'Face':
          result.pathImageFace ??
          result.pathImageFaceNear ??
          result.pathImageFaceFar,
    }..removeWhere((_, path) => path == null);
    if (images.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final entry in images.entries)
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(entry.key),
              const SizedBox(height: 4),
              Image.file(
                File(entry.value!),
                width: 110,
                height: 110,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox(
                  width: 110,
                  height: 110,
                  child: Center(child: Text('(missing)')),
                ),
              ),
            ],
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('VNPT eKYC')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_offline)
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                'No VNPT_ACCESS_TOKEN set: running offline. '
                'OCR/compare/liveness results will be empty.',
              ),
            ),
          for (final flow in VnptEkycFlow.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: FilledButton(
                onPressed: () => _run(flow),
                child: Text(flow.name),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: OutlinedButton(
              onPressed: _last == null ? null : _export,
              child: const Text('Export front + back + face + info.json'),
            ),
          ),
          const SizedBox(height: 16),
          _buildImagePreview(),
          const SizedBox(height: 16),
          SelectableText(_output),
        ],
      ),
    );
  }
}
