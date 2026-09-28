//
//  ICEKYCSavedData.h
//  ICSdkEKYC
//
//  Created by Minh Nguyễn on 9/1/20.
//  Copyright © 2020 Minh Nguyễn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface ICEKYCSavedData : NSObject

+ (ICEKYCSavedData *)shared;


// Thuộc tính dùng để Bật/Tắt việc hiển thị LOG khi thực hiện eKYC
@property (nonatomic) BOOL isPrintLogRequest;



// Phương thức thực hiện khởi tạo hoặc Cài đặt lại giá trị cho các thuộc tính
- (void) resetOrInitAllData;



// Dữ liệu bóc tách thông tin giấy tờ OCR - Optical character recognition (Nhận dạng ký tự quang học)
@property (nonatomic) NSString *ocrResult;


// Giá trị các ngưỡng cắt ảnh giấy tờ. Giá trị dạng (x,y) trong đó x là tỉ lệ từ TOP đến điểm cắt, y là tỉ lệ từ BOTTOM đến điểm cắt
@property (nonatomic) NSString *cropParam;


// Dữ liệu kiểm tra ảnh giấy tờ MẶT TRƯỚC chụp trực tiếp hay không
@property (nonatomic) NSString *livenessCardFrontResult;


// Dữ liệu kiểm tra ảnh giấy tờ MẶT SAU chụp trực tiếp hay không
@property (nonatomic) NSString *livenessCardBackResult;

// Dữ liệu lỗi khi thực hiện retry scan QR ( JSON ARRAY )
@property (nonatomic) NSString *retryQRCodeResult;

// Dữ liệu việc QUÉT mã QR
@property (nonatomic) NSString *qrCodeResult;

// Dữ liệu đầy đủ việc QUÉT mã QR ( JSON OBJECT )
@property (nonatomic) NSString *qrCodeResultDetail;


// Dữ liệu thực hiện SO SÁNH khuôn mặt (lấy từ mặt trước ảnh giấy tờ hoặc ảnh thẻ)
@property (nonatomic) NSString *compareFaceResult;


// Dữ liệu kiểm tra ảnh CHÂN DUNG chụp trực tiếp hay không
@property (nonatomic) NSString *livenessFaceResult;


// Dữ liệu XÁC THỰC ảnh CHÂN DUNG và SỐ GIẤY TỜ
@property (nonatomic) NSString *verifyFaceResult;


// Dữ liệu kiểm tra ảnh CHÂN DUNG có bị che mặt hay không
@property (nonatomic) NSString *maskedFaceResult;


// Dữ liệu kết quả đăng ký thông tin KHUÔN MẶT
@property (nonatomic) NSString *addFaceResult;


// Dữ liệu kết quả đăng ký thông tin THẺ
@property (nonatomic) NSString *addCardIDResult;


// Dữ liệu thực hiện TÌM KIẾM khuôn mặt
@property (nonatomic) NSString *searchFaceResult;


// Dữ liệu đoạn mã khi ứng dụng bật chức năng WaterMark
@property (nonatomic) NSString *tokenWaterMarkResult;


// Dữ liệu để xác định cách giao dịch (yêu cầu) cùng nằm trong cùng một phiên
@property (nonatomic) NSString *clientSessionResult;


// Trả ra kết quả khi kết nối mạng gặp Vấn đề phát sinh khi thực hiện eKYC
@property (nonatomic) NSString *networkProblem;

// Trả kết quả so sánh giá trị OCR và QRcode
@property (nonatomic, readonly) BOOL compareQRCodeOCRResult;

// [Thông tin ảnh ở bước quét mã QR]
// Ảnh đầy đủ khi quét thành công mã QR
@property (nonatomic) UIImage *imageQRCodeFull;
// Đường dẫn Ảnh đầy đủ khi quét thành công mã QR
@property (nonatomic) NSURL *pathImageQRCodeFull;
// Ảnh [mã QR đã được cắt] khi quét thành công
@property (nonatomic) UIImage *imageQRCodeCropped;
// Đường dẫn Ảnh [mã QR đã được cắt] khi quét thành công
@property (nonatomic) NSURL *pathImageQRCodeCropped;
// Mã ảnh đầy đủ khi quét thành công mã QR sau khi tải lên máy chủ
@property (nonatomic) NSString *hashImageQRCode;


// [Thông tin ảnh mặt trước]
// Ảnh đầy đủ khi chụp giấy tờ mặt trước
@property (nonatomic) UIImage *imageFrontFull;
// Đường dẫn Ảnh đầy đủ khi chụp giấy tờ mặt trước
@property (nonatomic) NSURL *pathImageFrontFull;
// Ảnh [chụp giấy tờ mặt trước] đã cắt được trả ra để ứng dụng hiển thị
@property (nonatomic) UIImage *imageFrontCropped;
// Đường dẫn Ảnh [chụp giấy tờ mặt trước] đã cắt được trả ra để ứng dụng hiển thị
@property (nonatomic) NSURL *pathImageFrontCropped;
// Mã ảnh giấy tờ mặt trước sau khi tải lên máy chủ
@property (nonatomic) NSString *hashImageFront;


// [Thông tin ảnh mặt sau]
// Ảnh đầy đủ khi chụp giấy tờ mặt sau
@property (nonatomic) UIImage *imageBackFull;
// Đường dẫn Ảnh đầy đủ khi chụp giấy tờ mặt trước
@property (nonatomic) NSURL *pathImageBackFull;
// Ảnh [chụp giấy tờ mặt sau] đã cắt được trả ra để ứng dụng hiển thị
@property (nonatomic) UIImage *imageBackCropped;
// Đường dẫn Ảnh [chụp giấy tờ mặt trước] đã cắt được trả ra để ứng dụng hiển thị
@property (nonatomic) NSURL *pathImageBackCropped;
// Mã ảnh giấy tờ mặt sau sau khi tải lên máy chủ
@property (nonatomic) NSString *hashImageBack;


// [Thông tin ảnh chân dung chụp thẳng 01 hướng]
// Ảnh đầy đủ khi chụp ảnh chân dung thẳng
@property (nonatomic) UIImage *imageFaceFull;
// Đường dẫn Ảnh đầy đủ khi chụp ảnh chân dung thẳng
@property (nonatomic) NSURL *pathImageFaceFull;
// Ảnh chân dung thẳng đã cắt được trả ra để ứng dụng hiển thị
@property (nonatomic) UIImage *imageFaceCropped;
// Đường dẫn Ảnh chân dung thẳng đã cắt được trả ra để ứng dụng hiển thị
@property (nonatomic) NSURL *pathImageFaceCropped;
// Mã ảnh chân dung chụp thẳng sau khi tải lên máy chủ
@property (nonatomic) NSString *hashImageFace;


// [Thông tin ảnh chân dung xa]
// Ảnh đầy đủ khi chụp ảnh chân dung xa
@property (nonatomic) UIImage *imageFaceFarFull;
// Đường dẫn Ảnh đầy đủ khi chụp ảnh chân dung xa
@property (nonatomic) NSURL *pathImageFaceFarFull;
// Ảnh đầy đủ khi chụp ảnh chân dung xa đã cắt được trả ra để ứng dụng hiển thị
@property (nonatomic) UIImage *imageFaceFarCropped;
// Đường dẫn Ảnh đầy đủ khi chụp ảnh chân dung xa đã cắt được trả ra để ứng dụng hiển thị
@property (nonatomic) NSURL *pathImageFaceFarCropped;
// Mã ảnh chân dung chụp xa sau khi tải lên máy chủ
@property (nonatomic) NSString *hashImageFaceFar;


// [Thông tin ảnh chân dung gần]
// Ảnh đầy đủ khi chụp ảnh chân dung gần
@property (nonatomic) UIImage *imageFaceNearFull;
// Đường dẫn Ảnh đầy đủ khi chụp ảnh chân dung gần
@property (nonatomic) NSURL *pathImageFaceNearFull;
// Ảnh đầy đủ khi chụp ảnh chân dung gần đã cắt được trả ra để ứng dụng hiển thị
@property (nonatomic) UIImage *imageFaceNearCropped;
// Đường dẫn Ảnh đầy đủ khi chụp ảnh chân dung gần đã cắt được trả ra để ứng dụng hiển thị
@property (nonatomic) NSURL *pathImageFaceNearCropped;
// Mã ảnh chân dung chụp gần sau khi tải lên máy chủ
@property (nonatomic) NSString *hashImageFaceNear;


// [Thông tin Dữ liệu quét khuôn mặt]
// Dữ liệu quét khuôn mặt
@property (nonatomic) NSData *dataScan3D;
// Mã ảnh dữ liệu quét khuôn mặt sau khi tải lên máy chủ
@property (nonatomic) NSString *hashDataScan3D;


// [Đường dẫn VIDEO sau khi quay lại quá trình thao tác]
// Đường dẫn VIDEO quay lại quá trình chụp ảnh giấy tờ
@property (nonatomic) NSURL *pathVideoRecordDocument;
// Đường dẫn VIDEO quay lại quá trình chụp ảnh chân dung xa gần
@property (nonatomic) NSURL *pathVideoRecordFace;


//
@property (nonatomic) NSString *transactionId;
//
@property (nonatomic) NSString *transactionPartnerId;

// Lưu lại các giá trị lỗi trong quá trình chạy để gửi log khi tắt sdk
@property (nonatomic) NSString *hashQrError;
@property (nonatomic) NSString *hashFrontError;
@property (nonatomic) NSString *hashBackError;
@property (nonatomic) NSString *hashFaceFarError;
@property (nonatomic) NSString *hashFaceNearError;
@property (nonatomic) NSString *hashFaceScan3dError;
@property (nonatomic) NSString *hashFaceError;
@property (nonatomic) NSString *ocrError;
@property (nonatomic) NSString *livenessFrontError;
@property (nonatomic) NSString *livenessBackError;
@property (nonatomic) NSString *livenessFaceError;
@property (nonatomic) NSString *maskFaceError;
@property (nonatomic) NSString *compareFaceError;

@end

NS_ASSUME_NONNULL_END
