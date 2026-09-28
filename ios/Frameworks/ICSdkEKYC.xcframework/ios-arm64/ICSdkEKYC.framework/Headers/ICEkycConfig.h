//
//  ICEKYCConfig.h
//  ICSdkEKYC
//
//  Created by MinhMinh on 08/12/2022.
//  Copyright © 2022 Minh Nguyễn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ICEkycCameraProtocols.h"

NS_ASSUME_NONNULL_BEGIN

@interface ICEkycConfig : NSObject

+ (ICEkycConfig *)shared;

// Thuộc tính dùng để Bật/Tắt việc hiển thị LOG khi thực hiện eKYC
@property (nonatomic) BOOL isPrintLogRequest;

@property (nonatomic) NSString *languageSdk;

@property (nonatomic) NSString *challengeCode;

// @property (nonatomic) NSString *unitCustomer;

@property (nonatomic) NSString *resourceCustomer;

@property (nonatomic) NSString *clientSession;

@property (nonatomic) NSInteger expiresTime;

@property (nonatomic) BOOL isEnableWaterMark;
@property (nonatomic) NSString *tokenWaterMark;

@property (nonatomic) BOOL isAddMetadataImage;

@property (nonatomic) NSInteger timeoutCallApi;

//
@property (nonatomic) NSString *accessToken;
@property (nonatomic) NSString *tokenId;
@property (nonatomic) NSString *tokenKey;
//
@property (nonatomic) NSString *baseUrl;
@property (nonatomic) NSString *urlUploadImage;
@property (nonatomic) NSString *urlOcr;
@property (nonatomic) NSString *urlOcrFront;
@property (nonatomic) NSString *urlCompare;
@property (nonatomic) NSString *urlCompareGeneral;
@property (nonatomic) NSString *urlVerifyFace;
@property (nonatomic) NSString *urlAddFace;
@property (nonatomic) NSString *urlAddCardId;
@property (nonatomic) NSString *urlLivenessCard;
@property (nonatomic) NSString *urlCheckMaskedFace;
@property (nonatomic) NSString *urlSearchFace;
@property (nonatomic) NSString *urlLivenessFace;
@property (nonatomic) NSString *urlLivenessFace3D;
@property (nonatomic) NSString *urlLogSdk;

@property (nonatomic) NSMutableDictionary *headersRequest;
// Ưu tiên TransactionID trong headersRequest
@property (nonatomic) NSString *transactionId;

// Ưu tiên TransactionPartnerID trong headersRequest
@property (nonatomic) NSString *transactionPartnerId;

@property (nonatomic) NSString *transactionPartnerIdOCR;
@property (nonatomic) NSString *transactionPartnerIdOCRFront;
@property (nonatomic) NSString *transactionPartnerIdLivenessFront;
@property (nonatomic) NSString *transactionPartnerIdLivenessBack;
@property (nonatomic) NSString *transactionPartnerIdCompareFace;
@property (nonatomic) NSString *transactionPartnerIdLivenessFace;
@property (nonatomic) NSString *transactionPartnerIdMaskedFace;


// Loại so sánh. Mặc định 0
// 1: So sánh khuôn mặt với mặt trước giấy tờ
// 2: So sánh khuôn mặt với thông tin mặt NFC trên CCCD gắn chíp dùng compare general.
@property (nonatomic) NSInteger compareType;

// Bật chức năng kiểm tra "ảnh giấy tờ" chụp trực tiếp hay không. Mặc định false
@property (nonatomic) BOOL isCheckLivenessCard;


// Bật chức năng so sánh ảnh chụp chân dung với ảnh chân dung (dạng ảnh thẻ hoặc ảnh khuôn mặt). Mặc định false
// SDK sẽ thực hiện chức năng này khi đã bật chức năng so sánh (isEnableCompare = YES)
@property (nonatomic) BOOL isCompareGeneral;


// Bật chức năng kiểm tra "ảnh chân dung" có bị che mặt hay không. Mặc định là false
@property (nonatomic) BOOL isCheckMaskedFace;


// Bật chức năng tự động đặt crop_param = "0.0,0.0". Mặc định là false
@property (nonatomic) BOOL isAutoCropParam;


// Giá trị xác định cơ chế kiểm tra ảnh chụp chân dung. Mặc định là NoneCheckFace
// - NoneCheckFace: Không thực hiện kiểm tra ảnh chân dung chụp trực tiếp hay không
// - IBeta: Kiểm tra ảnh chân dung chụp trực tiếp hay không iBeta (phiên bản hiện tại)
// - Standard: Kiểm tra ảnh chân dung chụp trực tiếp hay không Standard (phiên bản mới)
@property (nonatomic) ModeCheckLivenessFace checkLivenessFace;

// Giá trị quy định có thực hiện mã hoá hay không. Mặc định FALSE
// - Nếu FALSE: Không thực hiện mã hoá
// - Nếu TRUE: Thực hiện mã hoá
@property (nonatomic) BOOL isEnableEncrypt;

// Giá trị quy định có chuyển về luồng không mã hoá không
// - Nếu FALSE: không
// - Nếu TRUE: sử dụng luồng không mã hoá
@property (nonatomic) BOOL isForceV1;

// Giá trị xác định public key rsa mã hóa dùng để tạo secret key (mã hóa/giải mã request/response)
@property (nonatomic) NSString *encryptPublicKey;

// Nút đóng SDK trên thanh tiêu đề, mặc định là LeftButton:
// LeftButton - nút đóng bên trái
// RightButton - nút đóng bên phải.
@property (nonatomic) ModeButtonHeaderBar modeButtonHeaderBar;

// Màu nội dung thanh tiêu đề: bao gồm màu chữ và màu nút đóng. mặc định là 0x142730
@property (nonatomic) UIColor *contentColorHeaderBar;

// Màu nền thanh tiêu đề. mặc định là trong suốt
// Áp dụng cho các màn hình: Các màn hướng dẫn, các màn chụp giấy tờ, màn quét mã QR, màn chụp ảnh chân dung
@property (nonatomic) UIColor *backgroundColorHeaderBar;

// Màu nội dung chính. Mặc định là 142730
// Áp dụng cho toàn bộ các màn hình
@property (nonatomic) UIColor *textColorContentMain;

// Màu tiêu đề chính. Mặc định 00A96F
// Áp dụng cho Tiêu đề: CHỤP MẶT TRƯỚC, ẢNH MẶT TRƯỚC, Chấm tròn nhỏ ở màn hình Hướng dẫn, màn hình Preview ✓
@property (nonatomic) UIColor *titleColorMain;

// Màu nền chính. Mặc định là FFFFFF
// Áp dụng cho màn Hướng dẫn (Help), màn xem trước (Preview)
@property (nonatomic) UIColor *backgroundColorMainScreen;

// Đường kẻ ngang ngăn cách các nội dung, mặc định 0x142730
// Áp dụng trên các màn hình Hướng dẫn, các màn hình Cảnh báo
@property (nonatomic) UIColor *backgroundColorLine;

// Màu nền nút bấm ở trạng thái hoạt động, mặc định 0x00A96F
@property (nonatomic) UIColor *backgroundColorActiveButton;

// Màu nền nút bấm ở trạng thái không hoạt động, mặc định B8C1C6
@property (nonatomic) UIColor *backgroundColorDeactiveButton;

// Màu tiêu đề nút bấm ở trạng thái hoạt động, mặc định FFFFFF
@property (nonatomic) UIColor *titleColorActiveButton;

// Màu tiêu đề nút bấm ở trạng thái hoạt động, mặc định FFFFFF
@property (nonatomic) UIColor *titleColorDeactiveButton;

// Màu nền chụp ảnh giấy tờ, quét mã QR, mặc định FFFFFF
@property (nonatomic) UIColor *backgroundColorCaptureDocumentScreen;

// Màu nền chụp ảnh chân dung, mặc định FFFFFF alpha = 0.75
@property (nonatomic) UIColor *backgroundColorCaptureFaceScreen;

// Màu hiệu ứng cảnh báo ở màn chụp khuôn mặt Oval, mặc định 00A96F
@property (nonatomic) UIColor *effectColorNoticeFace;

// Màu chữ nội dung trong ô cảnh báo ở màn chụp khuôn mặt Oval, mặc định FFFFFF
@property (nonatomic) UIColor *textColorNoticeFace;

// Màu hiệu ứng cảnh báo giấy tờ không hợp lệ, mặc định CA2A2A
@property (nonatomic) UIColor *effectColorNoticeInvalidFace;

// Màu hiệu ứng cảnh báo giấy tờ hợp lệ, mặc định là không màu ✓
@property (nonatomic) UIColor *effectColorNoticeValidDocument;

// Màu hiệu ứng cảnh báo giấy tờ không hợp lệ, mặc định là không màu ✓
@property (nonatomic) UIColor *effectColorNoticeInvalidDocument;

// Màu nội dung trong ô cảnh báo giấy tờ hợp lệ. mặc định 00A96F ✓
@property (nonatomic) UIColor *textColorNoticeValidDocument;

// Màu nội dung trong ô cảnh báo giấy tờ không hợp lệ. mặc định CA2A2A ✓
@property (nonatomic) UIColor *textColorNoticeInvalidDocument;

// Màu nút chụp ảnh giấy tờ, mặc định 142730
@property (nonatomic) UIColor *tintColorButtonCapture;

// Màu đường viền khung chụp mặt Oval, cơ bản, mặc định 00A96F
@property (nonatomic) UIColor *backgroundColorBorderCaptureFace;

// hiển thị logo
@property (nonatomic) BOOL isShowLogo;

// Logo mặc định
@property (nonatomic) UIImage *logo;

// Logo mặc định
@property (nonatomic) UIImage *logoFaceOval;

// Kích thước logo mặc định 38x12
@property (nonatomic) CGFloat widthLogo;

// Kích thước logo mặc định 38x12
@property (nonatomic) CGFloat heightLogo;

// Ảnh hướng dẫn QRCode
@property (nonatomic) UIImage *imageTutorialQRCode;

// Ảnh hướng dẫn Mặt trước
@property (nonatomic) UIImage *imageTutorialFront;

// Ảnh hướng dẫn Mặt sau
@property (nonatomic) UIImage *imageTutorialBack;

// Ảnh hướng dẫn Mờ nhoè
@property (nonatomic) UIImage *imageTutorialBlur;

// Ảnh hướng dẫn Mất góc
@property (nonatomic) UIImage *imageTutorialLostAngle;

// Ảnh hướng dẫn Loá sáng
@property (nonatomic) UIImage *imageTutorialGlare;

// Màu nền của các màn hình dạng cảnh báo, mặc định FFFFFF
@property (nonatomic) UIColor *backgroundColorPopup;

// Màu chữ của các màn hình dạng cảnh báo, mặc định 000000
@property (nonatomic) UIColor *textColorContentPopup;

// Định danh thứ tự thực hiện
@property (nonatomic) NSInteger stepIdEkyc;

// Giá trị xác định tỉ lệ nén ảnh để thực hiện giảm dung lượng ảnh. Mặc định 0.5 ✓
@property (nonatomic) CGFloat compressionQualityImage;

// Thuộc tính zoom camera có giá trị từ 1.0 đến 3.0. Mặc định 1.5
@property (nonatomic) CGFloat zoomCamera;

// Cấu hình độ sáng màn hình, giá trị nằm trong khoảng 0.0 đến 1.0. Mặc định 0.8
@property (nonatomic) CGFloat screenBrightness;

// Kiểm tra camera ảo. Mặc định là false
@property (nonatomic) BOOL isEnableCheckVirtualCamera;

// Kiểm tra máy ảo. Mặc định là false
@property (nonatomic) BOOL isEnableCheckSimulator;

// Kiểm tra máy jailbreak. Mặc định là false
@property (nonatomic) BOOL isEnableCheckJailbroken;

// Giá trị xác định khi đóng SDK có animation hay không. Mặc định là true
@property (nonatomic) BOOL isAnimatedDismissed;

// Số lần tối đa quét lại QRCode. Mặc định là vô hạn lần
@property(nonatomic) NSInteger numberTimesRetryScanQRCode;

// Thời gian giới hạn quá trình quét QR. Mặc định vô hạn
@property (nonatomic) NSNumber *timeoutQRCodeFlow;

// Giá trị xác định luồng thực hiện eKYC. Mặc định là none, sử dụng khi gọi các phương thức trong SDK
// - none: không thực hiện luồng nào cả
// - full: thực hiện eKYC đầy đủ các bước: chụp mặt trước, chụp mặt sau và chụp ảnh chân dung
// - ocrFront: thực hiện OCR giấy tờ một bước: chụp mặt trước
// - ocr: thực hiện OCR giấy tờ đầy đủ các bước: chụp mặt trước, chụp mặt sau
// - face: thực hiện so sánh khuôn mặt với mã ảnh chân dung được truyền từ bên ngoài
@property (nonatomic) FlowType flowType;

// màn hình tuỳ chỉnh cho màn hướng dẫn quét QR
@property (nonatomic, nullable) UIView *viewTutorialScanQRCode;

// Bật chức năng Flash khi chụp ảnh chân dung. Mặc định là false
@property (nonatomic) BOOL isEnableFlash;

// Màu nền của Flash. Mặc định là red
@property (nonatomic) UIColor *backgroundColorFlash;

// Màu của text Flash. Mặc định là white
@property (nonatomic) UIColor *colorTitleFlash;

// Log theo dõi khuôn mặt
@property (nonatomic) NSString *logTrackingFace;

@end

NS_ASSUME_NONNULL_END
