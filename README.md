# flutter_vnpt_ekyc_plugin

Flutter plugin over the VNPT eKYC native SDKs (Android `ekyc_sdk` 3.7.4, iOS `ICSdkEKYC` 3.7.1).
One call opens the native SDK screens and returns a typed result.

## Install

```yaml
dependencies:
  flutter_vnpt_ekyc_plugin: ^0.0.1
```

## Usage

```dart
import 'package:flutter_vnpt_ekyc_plugin/flutter_vnpt_ekyc_plugin.dart';

final result = await VnptEkyc.start(
  VnptEkycFlow.full,
  const VnptEkycConfig(
    accessToken: 'Bearer ...', // from ekyc.vnpt.vn console
    tokenId: '...',
    tokenKey: '...',
    faceMode: VnptFaceMode.advanced,
    livenessMode: VnptLivenessMode.iBeta,
    checkMaskedFace: true,
  ),
);

if (result.status == VnptEkycStatus.completed) {
  print(result.identity?.name); // parsed OCR info
  print(result.pathImageFront); // captured images
}
```

### Result

- `result.identity` / `result.qrIdentity` — OCR/QR data parsed into typed fields (name, id,
  birth day, ...).
- `result.faceCompare`, `result.faceLiveness`, `result.cardFrontLiveness`,
  `result.cardBackLiveness`, `result.maskCheck` — parsed sub-checks (face match, liveness,
  masked-face). VNPT does not publicly document the exact pass/fail values these carry, so
  treat them as informational and confirm with a live response before branching on them.
- `result.compareQrCodeOcr` (bool) and `result.networkProblem` are the two fields VNPT *does*
  document clearly: `compareQrCodeOcr` is true when the QR and OCR data match; `networkProblem`
  is `null` on success or `"timeout"` if the SDK couldn't reach VNPT's servers.
- The final accept/reject decision for a KYC case should be made by your backend (re-verifying
  with VNPT server-to-server), not by branching on the client SDK's raw fields alone.

### Flows

`full`, `ocr`, `ocrFront`, `ocrBack`, `face`, `qrCode`. To chain them, feed
`result.hashImageFront` into the next call's `hashFrontOcr`/`hashImageCompare`, and
`result.clientSession` into `inputClientSession`.

### Testing without a token

Pass `offline: true` (with empty `accessToken`/`tokenId`/`tokenKey`) to try the capture UI
without calling VNPT's servers. You still get the images and QR data back, but no
OCR/compare/liveness results.

### Errors

Failures come back as `PlatformException` with code `no_activity`, `already_running`,
`camera_permission_denied`, `invalid_argument` or `sdk_error`. Also catch generic errors
(e.g. `MissingPluginException`, thrown if the plugin isn't linked correctly on a platform) so a
setup mistake shows up as text in your UI instead of crashing — the example app does both:

```dart
try {
  final result = await VnptEkyc.start(flow, config);
} on PlatformException catch (e) {
  // e.code, e.message
} catch (e) {
  // anything else
}
```

An error is always `e.code`/`e.message` (`String`) or a stringified generic object — never a `bool`.
A `bool` only ever appears in successful *data*, not in an error: e.g.
`result.compareQrCodeOcr`, `result.faceLiveness?.faceSwapping`,
`result.faceLiveness?.fakeLiveness`. If the flow fails outright (no camera permission, no
network, ...), you get a thrown error, not `false`.

## Platform setup

**Android**
- Keep VNPT's model files uncompressed, in `android/app/build.gradle.kts`:
  ```kotlin
  android { androidResources { noCompress += "bic" } }
  ```
- Camera permission is requested automatically before the SDK opens.

**iOS** (15+)
- Add `NSCameraUsageDescription` to `Info.plist`.
- Run on a real device — the VNPT frameworks ship no arm64 simulator slice.

## Notes

- The SDK leaves captured images on disk; delete `result.imagePaths` when you're done with them.
- Not exposed yet: theming (colors, logos, tutorial images), video recording, watermark, and
  the UI-less flows (add/verify/search face, add information).
