## 1.0.1

* Thêm tuỳ biến giao diện native SDK lúc chạy (`VnptEkycConfig.theme`, `VnptEkycTheme`,
  `VnptEkycImage`): màu sắc (~26 field), vị trí nút header, corner radius (Android), logo và 6
  ảnh hướng dẫn chụp — không cần build lại SDK. Ảnh dùng cơ chế khác nhau theo nền tảng: `bytes`
  runtime trên iOS, resource name có sẵn trong `android/app/src/main/res/drawable/` trên Android.
* Sửa `compareQrCodeOcr` trả `false` thay vì `null` khi bước quét QR không chạy, trên cả Android
  (`VnptFrontActivity`, `VnptIdentityActivity`, `VnptOcrActivity`) và iOS — phát hiện qua decompile
  SDK Android, giờ dựa vào `qrCodeResult` rỗng/không rỗng thay vì `hasExtra`/kiểu `BOOL` không có
  trạng thái "chưa chạy".
* Sửa Android: `Activity` bị huỷ khi xoay màn hình (config change) làm lỗi luôn pending result của
  flow đang chạy dở; giờ chỉ coi là lỗi thật khi `Activity` bị huỷ vĩnh viễn
  (`activity_detached`).
* Sửa iOS: `FlutterResult` có thể được gọi từ thread không phải main thread (vi phạm yêu cầu của
  Flutter engine).
* Sửa iOS: đọc path ảnh bằng string literal cứng (dễ sai khi SDK đổi tên) — chuyển sang
  `#keyPath()` được Swift kiểm tra lúc compile.
* Sửa example app: flow `face` không thực sự bật `enableCompare` (chỉ `full` mới bật), nên so
  khớp khuôn mặt với giấy tờ không chạy khi tách luồng.
* Việt hoá toàn bộ README, comment code và message lỗi hiển thị cho người dùng.
* README: hướng dẫn cài đặt đúng theo git dependency (package không publish lên pub.dev), bổ sung
  mục Yêu cầu, hướng dẫn cấu hình nền tảng chi tiết hơn, và hướng dẫn thêm logo/ảnh hướng dẫn
  từng bước.

## 0.0.1

* Wraps VNPT eKYC Android SDK 3.7.4 and iOS SDK 3.7.1 (UI flows: full, ocr, ocrFront, ocrBack, face, qrCode).
