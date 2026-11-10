# flutter_vnpt_ekyc_plugin

Plugin Flutter bọc trên native SDK VNPT eKYC (Android `ekyc_sdk` 3.7.4, iOS `ICSdkEKYC` 3.7.1).
Chỉ cần một lệnh gọi để mở màn hình native SDK và nhận về kết quả đã được định kiểu (typed).

## Yêu cầu

- Flutter >= 3.3.0, Dart >= 3.13.1.
- Tài khoản/credentials VNPT eKYC (`accessToken`, `tokenId`, `tokenKey`) lấy từ console
  [ekyc.vnpt.vn](https://ekyc.vnpt.vn) — không có thì chỉ chạy được ở [chế độ
  offline](#test-không-cần-token) (test UI, không có kết quả OCR/so khớp/liveness).
- **Android**: `minSdk >= 24`, `compileSdk >= 36` (SDK gốc của VNPT yêu cầu, không phải do plugin
  đặt ra). Nếu app của bạn đang để `minSdk`/`compileSdk` mặc định của Flutter (thường thấp hơn),
  phải tự nâng lên trong `android/app/build.gradle.kts` của app, nếu không Gradle sẽ báo lỗi merge
  manifest ngay khi build. Project dùng Kotlin 2.4.0 / AGP 9.1.0 / Java 17 — nên căn chỉnh version
  tương ứng trong app nếu gặp lỗi resolve dependency.
- **iOS**: 15.0+, phải chạy trên **thiết bị thật** — framework của VNPT không có bản dành cho giả
  lập arm64 (Apple Silicon). Build ra simulator Intel vẫn chạy được nhưng không mở được camera
  thật nên không test được luồng chụp.

## Cài đặt

Package này **không** publish lên pub.dev (`publish_to: none`, do SDK gốc của VNPT là mã nguồn
đóng/proprietary, phải phân phối riêng). Thêm trực tiếp từ Git:

```yaml
dependencies:
  flutter_vnpt_ekyc_plugin:
    git:
      url: https://github.com/MrTuyennn/flutter_vnpt_ekyc_plugin.git
      ref: main # nên ghim 1 tag hoặc commit SHA cụ thể cho bản release, tránh main đổi bất ngờ
```

Sau đó:

```bash
flutter pub get
```

Không cần thêm bước cấu hình Gradle/CocoaPods thủ công nào khác để lấy được SDK — các file `.aar`
(Android) và `.xcframework` (iOS) đã được vendor sẵn trong chính package này, và repo Maven cần
thiết (`jitpack.io`) được plugin tự khai báo cho toàn bộ project khi build. Phần cấu hình còn lại
app phải tự thêm (quyền camera, `noCompress`, ...) nằm ở mục [Cấu hình theo nền
tảng](#cấu-hình-theo-nền-tảng) bên dưới — bắt buộc phải làm, nếu không app sẽ crash hoặc không mở
được camera khi chạy thật.

## Cách dùng

```dart
import 'package:flutter_vnpt_ekyc_plugin/flutter_vnpt_ekyc_plugin.dart';

final result = await VnptEkyc.start(
  VnptEkycFlow.full,
  const VnptEkycConfig(
    accessToken: 'Bearer ...', // lấy từ console ekyc.vnpt.vn
    tokenId: '...',
    tokenKey: '...',
    faceMode: VnptFaceMode.advanced,
    livenessMode: VnptLivenessMode.iBeta,
    checkMaskedFace: true,
    validateDocument: VnptValidateDocument.advance,
    checkLivenessCard: true,
  ),
);

if (result.status == VnptEkycStatus.completed) {
  print(result.identity?.name); // thông tin OCR đã parse
  print(result.pathImageFront); // ảnh đã chụp
}
```

### Kết quả trả về

- `result.identity` / `result.qrIdentity` — dữ liệu OCR/QR đã parse thành các field có kiểu rõ
  ràng (tên, số giấy tờ, ngày sinh, cờ `isLegal` cảnh báo làm giả, cảnh báo hết hạn/sai định
  dạng, ...).
- `result.faceCompare`, `result.faceLiveness`, `result.cardFrontLiveness`,
  `result.cardBackLiveness`, `result.maskCheck` — các check con đã parse (so khớp khuôn mặt,
  liveness, che mặt). VNPT không công bố công khai ý nghĩa chính xác của các giá trị đậu/rớt
  trong này, nên chỉ coi là thông tin tham khảo, xác nhận lại bằng response thật trước khi dùng
  để quyết định nghiệp vụ.
- `result.compareQrCodeOcr` (`bool?`) và `result.networkProblem` là 2 field được VNPT công bố rõ
  ràng: `true`/`false` khi số giấy tờ, tên, giới tính, ngày sinh giữa QR và OCR khớp hoặc không
  khớp; `null` khi bước QR không chạy trong lần gọi đó (xem [Luồng](#luồng)).
  `networkProblem` là `null` khi thành công hoặc `"timeout"` nếu SDK không kết nối được tới
  server VNPT.
- Quyết định đậu/rớt cuối cùng cho một hồ sơ eKYC nên để backend của bạn tự verify lại với VNPT
  (server-to-server), không nên chỉ dựa vào các field thô từ SDK client.

### Luồng

`full`, `ocr`, `ocrFront`, `ocrBack`, `face`, `qrCode`. `full`/`ocr` thực hiện toàn bộ quy trình
trong một phiên màn hình native duy nhất; các flow còn lại cho phép tách việc chụp giấy tờ và
chụp chân dung thành nhiều lần gọi `VnptEkyc.start` riêng biệt — mỗi lần gọi độc lập hoàn toàn,
không có gì tự động kế thừa giữa các bước:

- Truyền `result.clientSession` của lần gọi trước vào `inputClientSession` của lần gọi sau để
  VNPT coi đó là cùng một giao dịch.
- `ocrBack` bắt buộc có `hashFrontOcr` = `result.hashImageFront` lấy từ lần gọi `ocrFront` trước
  đó.
- `face` chỉ thực hiện so khớp khuôn mặt với giấy tờ nếu bạn chủ động bật `enableCompare: true`
  **và** truyền `hashImageCompare` = `result.hashImageFront` lấy từ lần gọi `ocrFront` — SDK
  không tự nối 2 cái này lại cho bạn, kể cả khi dùng chung một lần gọi `full`.
- `validateDocument`, `checkLivenessCard` và các option khác theo từng bước phải khai báo lại ở
  **mỗi** lần gọi cần dùng (ví dụ cả `ocrFront` lẫn `ocrBack`); chúng không được SDK ghi nhớ giữa
  các lần gọi.
- `compareQrCodeOcr` chỉ có giá trị khi `enableScanQrCode: true` được bật ngay trong chính lần
  gọi đó (QR được quét ngay trước bước chụp mặt trước). Gọi flow `qrCode` riêng rồi mới gọi
  `ocrFront` riêng sẽ không bao giờ cho ra giá trị `compareQrCodeOcr`.

### Kiểm tra chất lượng ảnh giấy tờ

`validateDocument` chạy một model AI ngay trên thiết bị (không gọi server) để loại các ảnh giấy
tờ bị mờ, loá sáng, nghiêng/lệch góc, mất góc hoặc sai định dạng:

- `none` — không kiểm tra.
- `basic` — kiểm tra sau khi chụp; báo chụp lại nếu lỗi.
- `medium` — kiểm tra ngay trên preview; nút chụp chỉ xuất hiện khi giấy tờ đã được đặt đúng
  khung.
- `advance` — như `medium`, nhưng ngưỡng chặt hơn.

Với eKYC dùng cho production, nên dùng `advance` kèm `checkLivenessCard: true` (phát hiện giấy
tờ bị chụp lại từ màn hình hoặc bản in). Đây là lớp kiểm tra tách biệt với các check phía server
của VNPT (`result.identity?.isLegal`, kiểm tra làm giả qua OCR — xem [Kết quả trả về](#kết-quả-trả-về)).

### Test không cần token

Truyền `offline: true` (với `accessToken`/`tokenId`/`tokenKey` để rỗng) để thử giao diện chụp mà
không gọi server VNPT. Vẫn nhận được ảnh và dữ liệu QR, nhưng không có kết quả OCR/so
khớp/liveness.

### Lỗi

Khi thất bại, lỗi trả về dạng `PlatformException` với code `no_activity`, `already_running`,
`camera_permission_denied`, `invalid_argument`, `sdk_error` hoặc `activity_detached` (chỉ Android
— Activity bị huỷ trong lúc flow đang chạy dở, ví dụ app bị kill khi đang chạy nền). Nên bắt thêm
các lỗi chung khác (ví dụ `MissingPluginException`, ném ra khi plugin chưa được link đúng trên
một nền tảng) để lỗi cấu hình hiện ra dưới dạng text trên UI thay vì crash — example app đã làm
cả hai:

```dart
try {
  final result = await VnptEkyc.start(flow, config);
} on PlatformException catch (e) {
  // e.code, e.message
} catch (e) {
  // các lỗi khác
}
```

Lỗi luôn là `e.code`/`e.message` (`String`) hoặc một object chung được stringify — không bao giờ
là `bool`. `bool` chỉ xuất hiện trong *dữ liệu* thành công, không nằm trong lỗi: ví dụ
`result.compareQrCodeOcr`, `result.faceLiveness?.faceSwapping`,
`result.faceLiveness?.fakeLiveness`. Nếu flow thất bại hẳn (không có quyền camera, mất mạng,
...), bạn sẽ nhận một lỗi được throw ra, không phải giá trị `false`.

### Tuỳ biến giao diện

Truyền `theme: VnptEkycTheme(...)` trong `VnptEkycConfig` để đổi màu, logo và ảnh hướng dẫn của
màn hình native SDK ngay lúc chạy — không cần build lại SDK. Field nào không set giữ nguyên mặc
định của SDK.

Ví dụ đầy đủ toàn bộ field của `VnptEkycTheme`:

```dart
VnptEkycConfig(
  // ...
  theme: VnptEkycTheme(
    // Thanh tiêu đề
    headerBackgroundColor: 0xFF00A96F,
    headerContentColor: 0xFFFFFFFF,
    headerButtonPosition: VnptHeaderButtonPosition.left,
    headerBarCornerRadius: 32, // chỉ Android

    // Màn hình chính (tiêu đề, nội dung, nền, đường kẻ)
    mainTitleColor: 0xFF1A1A1A,
    mainContentColor: 0xFF595959,
    mainBackgroundColor: 0xFFFFFFFF,
    lineColor: 0xFFE0E0E0,

    // Nút bấm
    activeButtonBackgroundColor: 0xFF00A96F,
    activeButtonTitleColor: 0xFFFFFFFF,
    inactiveButtonBackgroundColor: 0xFFE0E0E0,
    inactiveButtonTitleColor: 0xFF9E9E9E,
    buttonCornerRadius: 6, // chỉ Android

    // Màn hình chụp giấy tờ / chân dung
    documentCaptureBackgroundColor: 0xFF000000,
    faceCaptureBackgroundColor: 0xFF000000,
    captureButtonTintColor: 0xFF00A96F,
    faceBorderColor: 0xFF00A96F,

    // Cảnh báo khi chụp khuôn mặt / giấy tờ
    faceNoticeEffectColor: 0xFFFFC107,
    faceNoticeTextColor: 0xFFFFFFFF,
    validDocumentEffectColor: 0xFF00A96F,
    validDocumentTextColor: 0xFFFFFFFF,
    invalidDocumentEffectColor: 0xFFE53935,
    invalidDocumentTextColor: 0xFFFFFFFF,

    // Popup
    popupBackgroundColor: 0xFFFFFFFF,
    popupTextColor: 0xFF1A1A1A,

    // Màn hình loading — chỉ Android
    loadingEffectColor: 0xFF00A96F,
    loadingBackgroundColor: 0xFFFFFFFF,

    // Màn hình flash — chỉ iOS
    flashBackgroundColor: 0xFF000000,
    flashTitleColor: 0xFFFFFFFF,

    // Logo
    showLogo: true, // chỉ Android
    logo: VnptEkycImage(
      bytes: logoBytes, // ví dụ đọc từ asset bằng rootBundle.load()
      androidDrawableName: 'ic_my_logo',
    ),
    logoWidth: 133,
    logoHeight: 18,
    logoFaceOval: VnptEkycImage(
      bytes: logoFaceOvalBytes,
      androidDrawableName: 'ic_my_logo_face_oval',
    ),
    logoFaceOvalWidth: 109, // chỉ Android
    logoFaceOvalHeight: 28, // chỉ Android

    // Ảnh hướng dẫn chụp
    tutorialQrCodeImage: VnptEkycImage(
      bytes: tutorialQrCodeBytes,
      androidDrawableName: 'ic_tutorial_qrcode',
    ),
    tutorialFrontImage: VnptEkycImage(
      bytes: tutorialFrontBytes,
      androidDrawableName: 'ic_tutorial_front',
    ),
    tutorialBackImage: VnptEkycImage(
      bytes: tutorialBackBytes,
      androidDrawableName: 'ic_tutorial_back',
    ),
    tutorialBlurImage: VnptEkycImage(
      bytes: tutorialBlurBytes,
      androidDrawableName: 'ic_tutorial_blur',
    ),
    tutorialGlareImage: VnptEkycImage(
      bytes: tutorialGlareBytes,
      androidDrawableName: 'ic_tutorial_glare',
    ),
    tutorialLostAngleImage: VnptEkycImage(
      bytes: tutorialLostAngleBytes,
      androidDrawableName: 'ic_tutorial_lost_angle',
    ),
  ),
)
```

Màu truyền vào là số nguyên ARGB (ví dụ `0xFF00A96F`), đúng định dạng cả `ColorInt` của Android
lẫn `UIColor` của iOS (plugin tự chuyển đổi).

Ảnh (logo, ảnh hướng dẫn) dùng cơ chế khác nhau giữa 2 nền tảng — do chính SDK VNPT quy định,
không phải giới hạn của plugin:

- **iOS** nhận ảnh trực tiếp qua `VnptEkycImage.bytes` — dựng `UIImage` ngay lúc chạy, không cần
  đổi gì trong Xcode project.
- **Android** chỉ nhận resource ID có sẵn trong APK lúc build, nên phải khai báo
  `VnptEkycImage.androidDrawableName` trỏ tới một file đã đặt sẵn trong
  `android/app/src/main/res/drawable/` của app host (không có đuôi file, ví dụ `"ic_my_logo"` cho
  `ic_my_logo.png`); `bytes` bị bỏ qua trên Android. Nếu tên không khớp file nào, plugin ném
  `invalid_argument` lúc gọi `VnptEkyc.start`, không phải lỗi build.

Có thể truyền cả `bytes` lẫn `androidDrawableName` trong cùng một `VnptEkycImage` để mỗi nền tảng
tự dùng đúng cơ chế của mình.

Một vài field chỉ có hiệu lực trên 1 nền tảng do khác biệt giữa 2 SDK gốc — xem doc comment của
từng field trong `VnptEkycTheme` (ví dụ `loadingEffectColor`/`loadingBackgroundColor` chỉ Android,
`flashBackgroundColor`/`flashTitleColor` chỉ iOS, `showLogo`/`logoFaceOvalWidth`/
`logoFaceOvalHeight`/`headerBarCornerRadius`/`buttonCornerRadius` chỉ Android).

#### Hướng dẫn thêm logo riêng (từng bước)

1. Chuẩn bị file ảnh logo (PNG, nền trong suốt). Tỉ lệ nên gần với mặc định của SDK để không bị
   méo: logo thường ~133×18, logo màn chụp Oval ~109×28 (đơn vị logical pixel/dp).
2. **Thêm asset vào app Flutter** (app dùng plugin, không phải vào plugin): khai báo trong
   `pubspec.yaml` của app:
   ```yaml
   flutter:
     assets:
       - assets/ic_my_logo.png
   ```
3. **Copy thêm file đó vào Android** tại
   `android/app/src/main/res/drawable/ic_my_logo.png` (tên file chỉ gồm chữ thường, số, `_`,
   không dấu, không khoảng trắng — đây là quy tắc đặt tên resource của Android, không phải của
   plugin). File này dùng cho `androidDrawableName`, tách biệt với asset Flutter ở bước 2 vì
   Android SDK của VNPT chỉ đọc được resource có sẵn trong APK lúc build, không đọc được asset
   Flutter lúc runtime.
4. **Đọc bytes cho iOS** từ asset Flutter đã khai báo ở bước 2:
   ```dart
   import 'package:flutter/services.dart' show rootBundle;

   final logoBytes = (await rootBundle.load('assets/ic_my_logo.png'))
       .buffer
       .asUint8List();
   ```
5. **Truyền vào `theme`**:
   ```dart
   theme: VnptEkycTheme(
     logo: VnptEkycImage(
       bytes: logoBytes, // iOS dùng cái này
       androidDrawableName: 'ic_my_logo', // Android dùng cái này, không có đuôi file
     ),
     logoWidth: 133,
     logoHeight: 18,
   ),
   ```
6. Build lại app (`flutter run`/`flutter build ...`) — vì file ở bước 3 nằm trong APK nên phải
   build lại mới có hiệu lực; riêng bytes ở bước 4 có hiệu lực ngay cả khi hot reload vì được
   load lúc runtime.

Làm tương tự cho `logoFaceOval` và 6 ảnh `tutorial*Image` (`tutorialQrCodeImage`,
`tutorialFrontImage`, `tutorialBackImage`, `tutorialBlurImage`, `tutorialGlareImage`,
`tutorialLostAngleImage`) — chỉ khác tên file và tên field.

## Cấu hình theo nền tảng

**Android**
- Trong `android/app/build.gradle.kts` của app:
  - Nâng `minSdk`/`compileSdk` nếu đang thấp hơn yêu cầu ở mục [Yêu cầu](#yêu-cầu) (ví dụ
    `minSdk = 24`, hoặc dùng thẳng `flutter.compileSdkVersion` nếu bản Flutter bạn dùng đã mặc
    định >= 36).
  - Giữ nguyên (không nén) các file model của VNPT — thiếu dòng này app vẫn build được nhưng SDK
    sẽ lỗi lúc chạy vì không đọc được model:
    ```kotlin
    android { androidResources { noCompress += "bic" } }
    ```
- Quyền camera (`android.permission.CAMERA`) được plugin tự khai báo và tự xin trước khi SDK mở
  lên — app không cần khai báo thêm trong `AndroidManifest.xml`, nhưng vẫn cần xử lý trường hợp
  người dùng từ chối quyền (xem code `camera_permission_denied` ở mục [Lỗi](#lỗi)).
- Lần build đầu tiên sau khi thêm dependency sẽ tải thêm vài thư viện từ `jitpack.io` — máy build
  (CI hoặc máy dev) cần có mạng truy cập được domain này.

**iOS** (15+)
- Thêm `NSCameraUsageDescription` vào `Info.plist` (bắt buộc — thiếu thì app crash ngay khi mở
  camera, không có cảnh báo lúc build):
  ```xml
  <key>NSCameraUsageDescription</key>
  <string>Ứng dụng cần quyền camera để chụp giấy tờ và khuôn mặt khi xác thực eKYC</string>
  ```
- Phải chạy trên thiết bị thật (`flutter run -d <device-id>` hoặc build rồi cài qua TestFlight/Ad
  Hoc) — framework của VNPT không có slice arm64 cho giả lập, nên trên máy Apple Silicon chỉ build
  ra simulator Intel mới chạy được, và lúc đó vẫn không mở được camera thật. Target `Runner` được
  plugin tự loại trừ kiến trúc arm64 khi build cho simulator (qua CocoaPods
  `user_target_xcconfig`) — không cần tự sửa `Podfile`.
- Lần đầu sau khi thêm dependency, chạy `cd ios && pod install` (hoặc để `flutter run` tự gọi) để
  CocoaPods tải và link `ICSdkEKYC.xcframework`/`eKYCLib.xcframework` đã vendor sẵn trong plugin.

## Ghi chú

- SDK để lại ảnh đã chụp trên bộ nhớ máy; nhớ xoá `result.imagePaths` sau khi dùng xong.
- Chưa hỗ trợ: quay video, watermark, so khớp khuôn mặt với NFC chip (`compareType`), và các flow
  không giao diện (add/verify/search face, add information).

## License

Mã nguồn wrapper (`lib/`, `android/src/`, `ios/Classes/`) phát hành theo giấy phép
[MIT](LICENSE). Giấy phép này **không** áp dụng cho SDK native của VNPT được vendor kèm theo
(`android/libs/*.aar`, `ios/Frameworks/*.xcframework`) — các file đó vẫn là phần mềm proprietary
của VNPT AI, dùng theo điều khoản license riêng của VNPT
([ekyc.vnpt.vn](https://ekyc.vnpt.vn)). Phải tự có hợp đồng/giấy phép sử dụng hợp lệ với VNPT AI
mới được dùng các SDK đó trong production.
