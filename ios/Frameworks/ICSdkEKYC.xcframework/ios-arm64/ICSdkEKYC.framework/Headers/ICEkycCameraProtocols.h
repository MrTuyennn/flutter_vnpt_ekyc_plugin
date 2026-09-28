//
//  ICEkycCameraProtocols.h
//  ICSdkEKYC
//
//  Created by MinhMinh on 08/12/2022.
//  Copyright © 2022 iOS Team IC - Innovation Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


// Xác định phiên bản khi sử dụng Máy ảnh tại bước chụp ảnh chân dung
// Mặc định là Normal
typedef enum : NSUInteger {
    Normal,     // chụp ảnh chân dung 01 hướng
    ProOval,    // chụp ảnh chân dung Oval xa gần
} VersionSdk;


// Xác định việc sử dụng máy ảnh phía trước hoặc phía sau khi chụp ảnh chân dung
// Mặc định PositionFront
typedef enum : NSUInteger {
    PositionFront,      // Máy ảnh phía trước tại bước chụp chân dung
    PositionBack,       // Máy ảnh phía sau tại bước chụp chân dung
} CameraPosition;


// Xác định kiểu giấy tờ để sử dụng
// Mặc định là IdentityCard
typedef enum : NSUInteger {
    IdentityCard,       // Chứng minh thư nhân dân, Căn cước công dân
    IDCardChipBased,    // Căn cước công dân gắn Chip
    Passport,           // Hộ chiếu
    DriverLicense,      // Bằng lái xe
    MilitaryIdCard,     // Chứng minh thư quân đội
} TypeDocument;


// Xác định việc hình thức chụp ảnh chân dung Oval
// Mặc định là FarAndNear
typedef enum : NSUInteger {
    FarAndNear,     // thực hiện chụp ảnh Oval xa và Oval gần
    OnlyFar,        // thực hiện chụp ảnh Oval xa
    OnlyNear,       // thực hiện chụp ảnh Oval gần
} VersionFaceOval;

// Xác định luồng thực hiện eKYC
// Giá trị mặc định là ICEKYCNTB
typedef enum : NSUInteger {
    ICEKYCNTB,
    ICEKYCETB,
    ICEKYCVERIFY
} ICEKYCFlow;


// Xác định luồng thực hiện eKYC
// Giá trị mặc định là none
typedef enum : NSUInteger {
    none,       // không thực hiện luồng nào cả
    full,       // thực hiện eKYC đầy đủ các bước: chụp giấy tờ và chụp ảnh chân dung
    scanQR,     // thực hiện quét QR và trả ra kết quả
    ocrFront,   // thực hiện OCR giấy tờ một bước: chụp mặt trước giấy tờ
    ocrBack,    // thực hiện OCR giấy tờ một bước: chụp mặt sau giấy tờ
    ocr,        // thực hiện OCR giấy tờ
    face,       // thực hiện chụp ảnh Oval xa gần và thực hiện các chức năng tuỳ vào Bật/Tắt: Compare, Verify, Mask, Liveness Face
} FlowType;


// Xác định các bước khi thực hiện eKYC
// Giá trị mặc định là stepQRCode
typedef enum : NSUInteger {
    stepQRCode,     // Quét mã QR
    stepFront,      // Chụp mặt trước giấy tờ
    stepBack,       // Chụp mặt sau giấy tờ
    stepFace,       // Chụp ảnh chân dung chủ giấy tờ
} ProgessStep;


// Xác định 'bước cuối cùng' khi Người dùng đóng SDK eKYC
typedef enum : NSUInteger {
    CancelPermission,   // Đóng SDK khi không được cấp quyền truy cập máy ảnh
    HelpDocument,       // Hướng dẫn chụp ảnh giấy tờ
    ScanQRCode,         // Quét mã QR
    ScanQRCodeFailed,   // Quét mã QR lỗi
    CaptureFront,       // Chụp ảnh giấy tờ mặt trước
    CaptureBack,        // Chụp ảnh giấy tờ mặt trước
    HelpOval,           // Hướng dẫn chụp ảnh chân dung Oval
    AuthenFarFace,      // Chụp ảnh chân dung Oval xa
    AuthenNearFace,     // Chụp ảnh chân dung Oval gần
    HelpFaceBasic,      // Hướng dẫn chụp ảnh chân dung cơ bản
    CaptureFaceBasic,   // Chụp ảnh chân dung cơ bản
    Processing,         // Xử lý dữ liệu
    Done,               // Thoát SDK khi đã thực hiện xong luồng eKYC
} ScreenType;


// Xác định mức kiểm tra giấy tờ ở SDK, sử dụng Model AI Offline
// Mặc định là None
typedef enum : NSUInteger {
    None,       // Không thực hiện kiểm tra ảnh khi chụp ảnh giấy tờ
    Basic,      // Kiểm tra sau khi chụp ảnh
    Medium,     // Kiểm tra ảnh hợp lệ trước khi chụp (lật giấy tờ thành công → hiển thị nút chụp)
    Advance,    // Kiểm tra ảnh hợp lệ trước khi chụp (hiển thị nút chụp)
} TypeValidateDocument;


// Xác định việc sử dụng màn hình hướng dẫn "chụp ảnh khuôn mặt".
// Mặc định là HelpDefault
typedef enum : NSUInteger {
    HelpDefault,            // HelpDefault là giá trị cho bản hướng dẫn mặc định của SDK.
    HelpVideoFullScreen,    // HelpV1 là giá trị cho bản hướng dẫn bằng Video Full Screen
    HelpVideoAudioText,     // HelpV2 là giá trị cho bản hướng dẫn nâng Video và Nội dung đi kèm
} ModelHelp;


// Xác định cơ chế kiểm tra trạng thái chụp trực tiếp của ảnh chụp chân dung
// Mặc định NoneCheckFace
typedef enum : NSUInteger {
    NoneCheckFace,  // Không thực hiện kiểm tra ảnh chân dung chụp trực tiếp hay không
    IBeta,          // Kiểm tra ảnh chân dung chụp trực tiếp hay không iBeta (phiên bản hiện tại)
    Standard,       // Kiểm tra ảnh chân dung chụp trực tiếp hay không Standard (phiên bản mới)
} ModeCheckLivenessFace;


// Xác định việc sử dụng màn hình Nghị định 13.
// Mặc định là None
typedef enum : NSUInteger {
    RPDNone,        // RPDNone là giá trị mặc định → Không hiển thị màn hình nghị định 13.
    RPDDocument,    // RPDDocument là giá trị để Hiển thị màn hình nghị định 13 cho giấy tờ
    RPDFace,        // RPDFace là giá trị để Hiển thị màn hình nghị định 13 cho khuôn mặt
    RPDFull,        // RPDFull là giá trị để Hiển thị màn hình nghị định 13 cho giấy tờ & khuôn mặt
} ModelRequirePermissionDecree;


// Nút đóng SDK trên thanh tiêu đề
typedef enum : NSUInteger {
    LeftButton,     // nút đóng bên trái
    RightButton,    // nút đóng bên phải.
} ModeButtonHeaderBar;


// Định nghĩa type_id của các loại giấy tờ
typedef enum : NSUInteger {
    IDENTITY_CARD_9,            // Chứng minh nhân dân 9 số
    IDENTITY_CARD_12,           // Chứng minh nhân dân 12 số
    CITIZEN_ID_CARD,            // Căn cước công dân cũ
    PASSPORT,                   // Hộ chiếu
    MILITARY_CARD,              // Chứng minh quân đội
    DRIVER_LICENSE,             // Căn cước công dân trước ngày 01/07/2024
    CITIZEN_ID_CHIP,            // Chứng minh thư quân đội'
    CITIZEN_ID_CHIP_01072024    // Căn cước công dân sau ngày 01/07/2024
} BlockedDocumentType;

typedef enum : NSUInteger {
    ICEkycDefault,        // Thực hiện tải ảnh trực tiếp lên Minio
    ICEkycCreateLink,     // Thực hiện tạo link -> upload ảnh
} ModeUploadFile;


typedef enum : NSUInteger {
    ICEkycOCRFull,
    ICEkycOCRFront,     
} ModeVersionOCR;


#pragma mark - WireFrameProtocol

@protocol ICEkycCameraWireframeProtocol <NSObject>

@end

#pragma mark - ICEkycCameraPresenterProtocol

@protocol ICEkycCameraPresenterProtocol <NSObject>

@end

#pragma mark - ICEkycCameraInteractorProtocol

@protocol ICEkycCameraInteractorOutputProtocol <NSObject>

/** Interactor -> Presenter */

// Trả ra dữ liệu tạo link upload
- (void) sendResultCreateLinkUploadImage:(UIImage *)image result:(NSDictionary *)result side:(NSString *)side;

// Trả ra dữ liệu tạo link upload
- (void) sendResultCreateLinkUploadData:(NSData *)data result:(NSDictionary *)result side:(NSString *)side;

// trả dữ liệu kết quả tải ảnh QRCode lên máy chủ
- (void) sendResultUploadSucceedQRCodeImage:(NSString *)hash;


// trả dữ liệu kết quả tải ảnh MẶT TRƯỚC lên máy chủ
- (void) sendResultUploadSucceedFrontImage:(NSDictionary *)result hash:(NSString *)hash;


// trả dữ liệu kết quả tải ảnh MẶT SAU lên máy chủ
- (void) sendResultUploadSucceedBackImage:(NSDictionary *)result hash:(NSString *)hash;


// trả dữ liệu kết quả tải ảnh CHÂN DUNG THẲNG lên máy chủ
- (void) sendResultUploadSucceedFaceImage:(NSDictionary *)result hash:(NSString *)hash;


// trả dữ liệu kết quả tải ảnh CHÂN DUNG XA lên máy chủ
- (void) sendResultUploadSucceedFarFaceImage:(NSDictionary *)result hash:(NSString *)hash;


// trả dữ liệu kết quả tải ảnh CHÂN DUNG GẦN lên máy chủ
- (void) sendResultUploadSucceedNearFaceImage:(NSDictionary *)result hash:(NSString *)hash;


// trả dữ liệu kết quả tải dữ liệu QUÉT 3 CHIỀU lên máy chủ
- (void) sendResultUploadSucceedLogDataImage:(NSDictionary *)result hash:(NSString *)hash;


// trả dữ liệu kết quả BÓC TÁCH THÔNG TIN MẶT TRƯỚC
- (void) sendResultGetInformationFrontCard:(NSDictionary *)result;



// trả dữ liệu kết quả BÓC TÁCH THÔNG TIN GIẤY TỜ
- (void) sendResultGetInformationCard:(NSDictionary *)result;


// trả dữ liệu kết quả KIỂM TRA GIẤY TỜ MẶT TRƯỚC ĐƯỢC CHỤP TRỰC TIẾP HOẶC KHÔNG
- (void) sendResultCheckLivenessFrontCard:(NSDictionary *)result;


// trả dữ liệu kết quả KIỂM TRA GIẤY TỜ MẶT SAU ĐƯỢC CHỤP TRỰC TIẾP HOẶC KHÔNG
- (void) sendResultCheckLivenessBackCard:(NSDictionary *)result;


// trả dữ liệu kết quả SO SÁNH ẢNH CHÂN DUNG (đã có) với ẢNH CHÂN DUNG vừa chụp
- (void) sendResultCompareFrontFace:(NSDictionary *)result;


// trả dữ liệu kết quả SO SÁNH ẢNH CHÂN DUNG đầy đủ (có thể lấy từ ảnh thẻ NFC) với ẢNH CHÂN DUNG vừa chụp (compare-general)
- (void) sendResultCompareFaces:(NSDictionary *)result;


// trả dữ liệu kết quả KIỂM TRA KHUÔN MẶT ĐƯỢC CHỤP TRỰC TIẾP HOẶC KHÔNG
- (void) sendResultCheckLivenessFace:(NSDictionary *)result;


// trả dữ liệu kết quả KIỂM TRA KHUÔN MẶT ĐƯỢC CHỤP TRỰC TIẾP HOẶC KHÔNG (3 CHIỀU)
- (void) sendResultCheckLivenessFace3D:(NSDictionary *)result;


// trả dữ liệu kết quả KIỂM TRA KHUÔN MẶT CÓ BỊ CHE HAY KHÔNG
- (void) sendResultCheckMaskFace:(NSDictionary *)result;


// Lưu log toàn bộ giao dịch ngay cả khi KH bị thao tác lỗi. Chỉ gửi khi bị lỗi
- (void) sendResultUploadSdkLog:(NSDictionary *)result;



@end

@protocol ICEkycCameraInteractorInputProtocol <NSObject>

- (void)setOutput:(id<ICEkycCameraInteractorOutputProtocol>)output;
- (id<ICEkycCameraInteractorOutputProtocol>)getOutputProtocol;

/** Presenter -> Interactor */

// Thực hiện tạo link upload
- (void)handleCreateLinkUploadImage:(UIImage *)image fileName:(NSString *)fileName contentType:(NSString *)contentType side:(NSString *)side flow:(NSString *)flow;

// Thực hiện tạo link upload
- (void)handleCreateLinkUploadData:(NSData *)data fileName:(NSString *)fileName contentType:(NSString *)contentType side:(NSString *)side flow:(NSString *)flow;

// Thực hiện Upload ảnh lên link
- (void) handleUploadImage:(UIImage *)image toUrl:(NSString *)toUrl hash:(NSString *)hash encrypt:(NSString *)encrypt contentType:(NSString *)contentType date:(NSString *)date signature:(NSString *)signature algorithm:(NSString *)algorithm credential:(NSString *)credential policy:(NSString *)policy side:(NSString *)side;

// Thực hiện Upload data lên link
- (void) handleUploadData:(NSData *)data toUrl:(NSString *)toUrl hash:(NSString *)hash encrypt:(NSString *)encrypt contentType:(NSString *)contentType date:(NSString *)date signature:(NSString *)signature algorithm:(NSString *)algorithm credential:(NSString *)credential policy:(NSString *)policy side:(NSString *)side;

// thực hiện tải ảnh QRCode lên máy chủ
- (void) handleUploadQRCodeImage:(UIImage *)image cropedImage:(UIImage *)cropedImage path:(NSURL *)path title:(NSString *)title description:(NSString *)description flow:(NSString *)flow;


// thực hiện tải ảnh MẶT TRƯỚC (Chụp giấy tờ) lên máy chủ
- (void) handleUploadFrontImage:(UIImage *)image cropedImage:(UIImage *)cropedImage path:(NSURL *)path title:(NSString *)title description:(NSString *)description flow:(NSString *)flow;


// thực hiện tải ảnh MẶT SAU (Chụp giấy tờ) lên máy chủ
- (void) handleUploadBackImage:(UIImage *)image cropedImage:(UIImage *)cropedImage path:(NSURL *)path title:(NSString *)title description:(NSString *)description flow:(NSString *)flow;


// thực hiện tải ảnh CHÂN DUNG THẲNG (Chụp chân dung 1 hướng hoặc xoay mặt) lên máy chủ
- (void) handleUploadFaceImage:(UIImage *)image cropedImage:(UIImage *)cropedImage path:(NSURL *)path title:(NSString *)title description:(NSString *)description flow:(NSString *)flow;


// thực hiện tải ảnh CHÂN DUNG XA (Chụp chân dung Oval) lên máy chủ
- (void) handleUploadFarFaceImage:(UIImage *)image cropedImage:(UIImage *)cropedImage path:(NSURL *)path title:(NSString *)title description:(NSString *)description flow:(NSString *)flow;


// thực hiện tải ảnh CHÂN DUNG GẦN (Chụp chân dung Oval) lên máy chủ
- (void) handleUploadNearFaceImage:(UIImage *)image cropedImage:(UIImage *)cropedImage path:(NSURL *)path title:(NSString *)title description:(NSString *)description flow:(NSString *)flow;


// thực hiện tải dữ liệu QUÉT 3 CHIỀU (Chụp chân dung Oval) lên máy chủ
- (void) handleUploadLogData:(NSData *)logData path:(NSURL *)path title:(NSString *)title description:(NSString *)description flow:(NSString *)flow;


// thực hiện BÓC TÁCH THÔNG TIN GIẤY TỜ MẶT TRƯỚC (Chụp giấy tờ)
- (void) handleGetInfoFrontCard:(NSString *)front cropParam:(NSString *)cropParam type:(NSString *)type validate:(BOOL)validate flow:(NSString *)flow;


// thực hiện BÓC TÁCH THÔNG TIN GIẤY TỜ MẶT TRƯỚC VÀ MẶT SAU (Chụp giấy tờ)
- (void) handleGetInformationCard:(NSString *)front back:(NSString *)back cropParam:(NSString *)cropParam type:(NSString *)type validate:(BOOL)validate flow:(NSString *)flow;


// thực hiện KIỂM TRA GIẤY TỜ MẶT TRƯỚC ĐƯỢC CHỤP TRỰC TIẾP HOẶC KHÔNG
- (void) handleCheckLivenessFrontCard:(NSString *)card cropParam:(NSString *)cropParam flow:(NSString *)flow;


// thực hiện KIỂM TRA GIẤY TỜ MẶT SAU ĐƯỢC CHỤP TRỰC TIẾP HOẶC KHÔNG
- (void) handleCheckLivenessBackCard:(NSString *)card cropParam:(NSString *)cropParam flow:(NSString *)flow;


// thực hiện SO SÁNH ẢNH CHÂN DUNG ở GIẤY TỜ MẶT TRƯỚC với ẢNH CHÂN DUNG vừa chụp
- (void) handleCompareImageCard:(NSString *)front face:(NSString *)face flow:(NSString *)flow;


// thực hiện SO SÁNH ẢNH CHÂN DUNG đầy đủ (có thể lấy từ ảnh thẻ NFC) với ẢNH CHÂN DUNG vừa chụp (compare-general)
- (void) handleCompareFaceOne:(NSString *)faceOne faceTwo:(NSString *)faceTwo thresLevel:(NSString *)thresLevel flow:(NSString *)flow;


// thực hiện KIỂM TRA KHUÔN MẶT ĐƯỢC CHỤP TRỰC TIẾP HOẶC KHÔNG
- (void) handleCheckLivenessFace:(NSString *)face logData:(NSString *)logData modeLiveness:(ModeCheckLivenessFace)modeLiveness flow:(NSString *)flow;


// thực hiện KIỂM TRA KHUÔN MẶT ĐƯỢC CHỤP TRỰC TIẾP HOẶC KHÔNG KIỂU 3 CHIỀU
- (void) handleCheckLiveness3DScanImageNear:(NSString *)imageNear imageFar:(NSString *)imageFar logData:(NSString *)logData modeLiveness:(ModeCheckLivenessFace)modeLiveness flow:(NSString *)flow;


// thực hiện KIỂM TRA KHUÔN MẶT CÓ BỊ CHE HAY KHÔNG
- (void) handleCheckMaskFace:(NSString *)face flow:(NSString *)flow;


// Lưu log toàn bộ giao dịch ngay cả khi KH bị thao tác lỗi. Chỉ gửi khi bị lỗi
- (void) handleUploadSdkLog:(NSString *)sdkLog flow:(NSString *)flow path:(NSString *)path flowEkyc:(NSString *)flowEkyc;




/* THỰC HIỆN CÀI ĐẶT & LƯU DỮ LIỆU */

// thực hiện CÀI ĐẶT LẠI thông tin ICEKYCSavedData
- (void) handleResetICEKYCSavedData;


// thực hiện LƯU thông tin Client Session
- (void) handleSaveClientSession:(NSString *)clientSession;


// thực hiện CÀI ĐẶT CÁC THÔNG TIN ẢNH cho ICEKYCSavedData sau khi chụp ảnh
- (void) handleSaveQRCode:(NSString *)qrCode qrCodeDetail:(NSString *)qrCodeDetail image:(UIImage *)image cropedImage:(UIImage *)cropedImage path:(NSURL *)path;


// thực hiện CÀI ĐẶT CÁC THÔNG TIN ẢNH cho ICEKYCSavedData sau khi chụp ảnh
- (void) handleSaveFrontImage:(UIImage *)image cropedImage:(UIImage *)cropedImage path:(NSURL *)path cropParam:(NSString *)cropParam;


// thực hiện CÀI ĐẶT CÁC THÔNG TIN ẢNH cho ICEKYCSavedData sau khi chụp ảnh
- (void) handleSaveBackImage:(UIImage *)image cropedImage:(UIImage *)cropedImage path:(NSURL *)path cropParam:(NSString *)cropParam;


// thực hiện CÀI ĐẶT CÁC THÔNG TIN ẢNH cho ICEKYCSavedData sau khi chụp ảnh
- (void) handleSaveStraightFaceImage:(UIImage *)image cropedImage:(UIImage *)cropedImage path:(NSURL *)path;


// thực hiện CÀI ĐẶT CÁC THÔNG TIN ẢNH cho ICEKYCSavedData sau khi chụp ảnh
- (void) handleSaveFarImage:(UIImage *)farImage cropedFar:(UIImage *)cropedFar nearImage:(UIImage *)nearImage cropedNear:(UIImage *)cropedNear dataScan3D:(NSData *)dataScan3D path:(NSURL *)path;




@end

#pragma mark - ICEkycCameraViewProtocol

@protocol ICEkycCameraViewProtocol <NSObject>

/** Presenter -> ViewController */

// Trả ra dữ liệu tạo link upload
- (void) showResultCreateLinkUploadImage:(UIImage *)image result:(NSDictionary *)result side:(NSString *)side;

// Trả ra dữ liệu tạo link upload
- (void) showResultCreateLinkUploadData:(NSData *)data result:(NSDictionary *)result side:(NSString *)side;

// trả dữ liệu kết quả tải ảnh QRCode lên máy chủ
- (void) showResultUploadSucceedQRCodeImage:(NSString *)hash;


// trả dữ liệu kết quả tải ảnh MẶT TRƯỚC lên máy chủ
- (void) showResultUploadSucceedFrontImage:(NSDictionary *)result hash:(NSString *)hash;


// trả dữ liệu kết quả tải ảnh MẶT SAU lên máy chủ
- (void) showResultUploadSucceedBackImage:(NSDictionary *)result hash:(NSString *)hash;


// trả dữ liệu kết quả tải ảnh CHÂN DUNG THẲNG lên máy chủ
- (void) showResultUploadSucceedFaceImage:(NSDictionary *)result hash:(NSString *)hash;


// trả dữ liệu kết quả tải ảnh CHÂN DUNG XA lên máy chủ
- (void) showResultUploadSucceedFarFaceImage:(NSDictionary *)result hash:(NSString *)hash;


// trả dữ liệu kết quả tải ảnh CHÂN DUNG GẦN lên máy chủ
- (void) showResultUploadSucceedNearFaceImage:(NSDictionary *)result hash:(NSString *)hash;


// trả dữ liệu kết quả tải dữ liệu QUÉT 3 CHIỀU lên máy chủ
- (void) showResultUploadSucceedLogDataImage:(NSDictionary *)result hash:(NSString *)hash;


// trả dữ liệu kết quả BÓC TÁCH THÔNG TIN MẶT TRƯỚC
- (void) showResultGetInformationFrontCard:(NSDictionary *)result;



// trả dữ liệu kết quả BÓC TÁCH THÔNG TIN GIẤY TỜ
- (void) showResultGetInformationCard:(NSDictionary *)result;


// trả dữ liệu kết quả KIỂM TRA GIẤY TỜ MẶT TRƯỚC ĐƯỢC CHỤP TRỰC TIẾP HOẶC KHÔNG
- (void) showResultCheckLivenessFrontCard:(NSDictionary *)result;


// trả dữ liệu kết quả KIỂM TRA GIẤY TỜ MẶT SAU ĐƯỢC CHỤP TRỰC TIẾP HOẶC KHÔNG
- (void) showResultCheckLivenessBackCard:(NSDictionary *)result;


// trả dữ liệu kết quả SO SÁNH ẢNH CHÂN DUNG (đã có) với ẢNH CHÂN DUNG vừa chụp
- (void) showResultCompareFrontFace:(NSDictionary *)result;


// trả dữ liệu kết quả SO SÁNH ẢNH CHÂN DUNG đầy đủ (có thể lấy từ ảnh thẻ NFC) với ẢNH CHÂN DUNG vừa chụp (compare-general)
- (void) showResultCompareFaces:(NSDictionary *)result;


// trả dữ liệu kết quả KIỂM TRA KHUÔN MẶT ĐƯỢC CHỤP TRỰC TIẾP HOẶC KHÔNG
- (void) showResultCheckLivenessFace:(NSDictionary *)result;


// trả dữ liệu kết quả KIỂM TRA KHUÔN MẶT ĐƯỢC CHỤP TRỰC TIẾP HOẶC KHÔNG (3 CHIỀU)
- (void) showResultCheckLivenessFace3D:(NSDictionary *)result;


// trả dữ liệu kết quả KIỂM TRA KHUÔN MẶT CÓ BỊ CHE HAY KHÔNG
- (void) showResultCheckMaskFace:(NSDictionary *)result;


// Lưu log toàn bộ giao dịch ngay cả khi KH bị thao tác lỗi. Chỉ gửi khi bị lỗi
- (void) showResultUploadSdkLog:(NSDictionary *)result;

@end
