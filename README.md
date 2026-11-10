# flutter_vnpt_ekyc_plugin

Plugin Flutter bọc trên native SDK VNPT eKYC (Android `ekyc_sdk` 3.7.4, iOS `ICSdkEKYC` 3.7.1).
Chỉ cần một lệnh gọi để mở màn hình native SDK và nhận về kết quả đã được định kiểu (typed).

## Cài đặt

```yaml
dependencies:
  flutter_vnpt_ekyc_plugin: ^0.0.1
```

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

## Cấu hình theo nền tảng

**Android**
- Giữ nguyên (không nén) các file model của VNPT, thêm vào `android/app/build.gradle.kts`:
  ```kotlin
  android { androidResources { noCompress += "bic" } }
  ```
- Quyền camera được tự động xin trước khi SDK mở lên.

**iOS** (15+)
- Thêm `NSCameraUsageDescription` vào `Info.plist`.
- Phải chạy trên thiết bị thật — framework của VNPT không có bản dành cho giả lập arm64.

## Ghi chú

- SDK để lại ảnh đã chụp trên bộ nhớ máy; nhớ xoá `result.imagePaths` sau khi dùng xong.
- Chưa hỗ trợ: tuỳ biến giao diện (màu sắc, logo, ảnh hướng dẫn), quay video, watermark, so khớp
  khuôn mặt với NFC chip (`compareType`), và các flow không giao diện (add/verify/search face,
  add information).
