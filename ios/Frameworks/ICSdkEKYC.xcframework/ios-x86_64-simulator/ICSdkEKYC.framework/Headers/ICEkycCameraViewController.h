//
//  ICEkycCameraViewController.h
//  ICSdkEKYC
//
//  Created by MinhMinh on 08/12/2022.
//  Copyright © 2022 iOS Team IC - Innovation Center. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICEkycCameraProtocols.h"
#import "ICEkycCameraPresenter.h"
#import "ICEkycBaseViewController.h"

#import "ICEkycAddFace.h"
#import "ICEkycAddInformation.h"
#import "ICEkycSearchFace.h"
#import "ICEkycVerifyFace.h"


NS_ASSUME_NONNULL_BEGIN


@protocol ICEkycCameraDelegate <NSObject>

@required
/**
 * Phương thức DELEGATE của SDK trả dữ liệu ra phía ngoài ứng dụng
 * Dữ liệu trả ra là các thuộc tính của ICEKYCSavedData
 * Lấy thông tin dữ liệu như sau
 * Đối với Swift: ICEKYCSavedData.shared().<property>
 * Đối với ObjectiveC: [ICEKYCSavedData shared].<property>
 */
- (void) icEkycGetResult;

@optional

/**
 * Phương thức DELEGATE của SDK khi người dùng chủ động thoát SDK
 *
 * @param type - Màn hình hoặc trạng thái cuối cùng khi người dùng thoát SDK.
 * CancelPermission,   // Thoát SDK tại màn hình Yêu cầu cấp quyền truy cập máy ảnh
 * HelpDocument,       // Thoát SDK tại màn hình Hướng dẫn chụp ảnh giấy tờ
 * ScanQRCode,         // Thoát SDK tại màn hình Quét mã QR
 * CaptureFront,       // Thoát SDK tại màn hình Chụp ảnh giấy tờ mặt trước
 * CaptureBack,        // Thoát SDK tại màn hình Chụp ảnh giấy tờ mặt sau
 * HelpOval,           // Thoát SDK tại màn hình Hướng dẫn chụp ảnh chân dung Nâng cao Oval
 * AuthenFarFace,      // Thoát SDK tại màn hình Chụp ảnh chân dung Oval xa
 * AuthenNearFace,     // Thoát SDK tại màn hình Chụp ảnh chân dung Oval gần
 * HelpFaceBasic,      // Thoát SDK tại màn hình Hướng dẫn chụp ảnh chân dung cơ bản
 * CaptureFaceBasic,   // Thoát SDK tại màn hình Chụp ảnh chân dung cơ bản
 * Processing,         // Thoát SDK tại màn hình Xử lý dữ liệu
 * Done,               // Thoát SDK khi đã thực hiện xong luồng eKYC
 */
- (void) icEkycCameraClosedWithType:(ScreenType)type;

@end


@interface ICEkycCameraViewController : ICEkycBaseViewController<ICEkycCameraViewProtocol>

@property (nonatomic) ICEkycCameraPresenter *presenter;


// THUỘC TÍNH CẦN THIẾT ĐỂ ỨNG DỤNG CÓ THỂ NHẬN DỮ LIỆU SAU KHI THỰC HIỆN EKYC 
@property (weak, nonatomic) id<ICEkycCameraDelegate> cameraDelegate;


/*========== CÁC THUỘC TÍNH CƠ BẢN CÀI ĐẶT CHUNG SDK ==========*/

// Các thuộc tính bảo mật dùng để kết nối đến dịch vụ eKYC
// Có thể lấy thông tin tại địa chỉ https://ekyc.vnpt.vn/admin-dashboard/console/project-manager
// Mã bảo mật khi thực hiện sử dụng dịch vụ eKYC, có định dạng "Bearer + (Access token)". Mặc định là ""
@property (nonatomic) NSString *accessToken;

// Mã bảo mật khi thực hiện sử dụng dịch vụ eKYC. Mặc định là ""
@property (nonatomic) NSString *tokenId;

// Mã bảo mật khi thực hiện sử dụng dịch vụ eKYC. Mặc định là ""
@property (nonatomic) NSString *tokenKey;

// Giá trị này xác định phiên bản khi sử dụng Máy ảnh tại bước chụp ảnh chân dung. Mặc định là Normal
// - Normal: chụp ảnh chân dung 1 hướng
// - ProOval: chụp ảnh chân dung xa gần
@property (nonatomic) VersionSdk versionSdk;

// Giá trị xác định luồng thực hiện eKYC. Mặc định là none, sử dụng khi gọi các phương thức trong SDK
// - none: không thực hiện luồng nào cả
// - full: thực hiện eKYC đầy đủ các bước: chụp mặt trước, chụp mặt sau và chụp ảnh chân dung
// - ocrFront: thực hiện OCR giấy tờ một bước: chụp mặt trước
// - ocr: thực hiện OCR giấy tờ đầy đủ các bước: chụp mặt trước, chụp mặt sau
// - face: thực hiện so sánh khuôn mặt với mã ảnh chân dung được truyền từ bên ngoài
@property (nonatomic) FlowType flowType;

// Giá trị xác định luồng thực hiện eKYC. Mặc định là ICEKYCNTB
// - ICEKYCNTB
// - ICEKYCETB
// - ICEKYCVERIFY
@property (nonatomic) ICEKYCFlow flowEKYC;

// Giá trị này xác định ngôn ngữ được sử dụng trong SDK. Mặc định là icekyc_vi
// - icekyc_vi: Tiếng Việt
// - icekyc_en: Tiếng Anh
@property (nonatomic) NSString *languageSdk;

// Giá trị này dùng để đảm bảo mỗi yêu cầu (request) từ phía khách hàng sẽ không bị thay đổi.
// Sau mỗi request, dữ liệu trả về sẽ bao gồm giá trị challengeCode. Mặc định là "11111"
@property (nonatomic) NSString *challengeCode;

// Giá trị này được truyền vào để xác định nhiều luồng giao dịch trong cùng một phiên. Mặc định ""
// Trường hợp ClientSession rỗng, SDK sẽ tạo mới ClientSession
@property (nonatomic) NSString *inputClientSession;

// Giá trị này xác định việc có hiển thị màn hình trợ giúp hay không. Mặc định là false
@property (nonatomic) BOOL isShowTutorial;

// Giá trị bật hoặt tắt chức năng hướng dẫn, mặc định là false
@property (nonatomic) BOOL isDisableTutorial;

// Giá trị này xác định việc có hiển thị màn hình Nghị định 13 hay không. Mặc định là không
@property (nonatomic) BOOL isShowRequiredPermissionDecree;

// Giá trị xác định việc bổ sung sử dụng màn hình hướng dẫn "chụp ảnh giấy tờ" dạng Video (sau màn hình hướng dẫn bằng Ảnh). Mặc định là false
// Hướng dẫn chụp giấy tờ bằng ảnh => Hướng dẫn chụp giấy tờ bằng Video => Chụp giấy tờ
@property (nonatomic) BOOL isEnableTutorialCardAdvance;

// Giá trị xác định việc sử dụng màn hình hướng dẫn "chụp ảnh khuôn mặt" dạng mặc định hoặc chỉnh sửa nâng cao. Mặc định là HelpV1
// - HelpDefault là giá trị cho bản hướng dẫn mặc định của SDK
// - HelpVideoFullScreen là giá trị cho bản hướng dẫn bằng Video Full Screen
// - HelpVideoAudioText là giá trị cho bản hướng dẫn nâng Video và Nội dung đi kèm
// Lưu ý
// - Khi sử dụng HelpV1. YÊU CẦU truyền tên Video hướng dẫn từ phía ngoài Ứng dụng vào SDK
// - Khi sử dụng HelpV2. YÊU CẦU truyền tên Audio & Video hướng dẫn từ phía ngoài Ứng dụng vào SDK
@property (nonatomic) ModelHelp modelHelpFace;

// Bật chức năng hiển thị nút bấm "Bỏ qua hướng dẫn" tại các màn hình hướng dẫn bằng video. Mặc định false
@property (nonatomic) BOOL isEnableGotIt;

// Giá trị này xác định việc hiển thị nút bấm chức năng xoay máy ảnh trước sang máy ảnh sau ở phiên bản chụp chân dung cơ bản. Mặc định false
@property (nonatomic) BOOL isShowSwitchCamera;

// Giá trị này xác định việc sử dụng máy ảnh phía trước hoặc phía sau khi chụp ảnh mặt người. Mặc định PositionFront
// - PositionFront: Máy ảnh phía trước tại bước chụp chân dung
// - PositionBack: Máy ảnh phía sau tại bước chụp chân dung
@property (nonatomic) CameraPosition cameraPositionForPortrait;

// Thuộc tính zoom camera có giá trị từ 1.0 đến 3.0. Mặc định 1.5
@property (nonatomic) CGFloat zoomCamera;

// Giá trị quy định thời gian để đóng SDK khi thực hiện eKYC không thành công. Mặc định 60 giây
@property (nonatomic) NSInteger expiresTime;

// Tắt chức năng gửi yêu cầu (call API) thực hiện eKYC. Mặc định false
@property (nonatomic) BOOL isTurnOffCallService;

// Giá trị quy định các bước của từng luồng eKYC trong cùng 1 phiên. Mặc định 0
@property (nonatomic) NSInteger stepId;

// Giá trị xác định tỉ lệ nén ảnh để thực hiện giảm dung lượng ảnh. Mặc định 0.6
@property (nonatomic) CGFloat compressionQualityImage;

// Bật chức năng tự động tăng độ sáng màn hình chụp chân dung Oval. Mặc định false
@property (nonatomic) BOOL isEnableAutoBrightness;

// Cấu hình độ sáng màn hình, giá trị nằm trong khoảng 0.0 đến 1.0. Mặc định 0.8
@property (nonatomic) CGFloat screenBrightness;

// Khi chụp ảnh thành công (qua được bước kiểm tra tại Client)
// - Nếu FALSE => vẫn hiển thị như hiện tại
// - Nếu TRUE => thì không hiển thị màn hình Preview nữa, mà thực hiện các công việc như nhấn vào nút Tiếp theo
@property (nonatomic) BOOL isSkipPreview;

// Giá trị quy định có thực hiện mã hoá hay không. Mặc định FALSE
// - Nếu FALSE: Không thực hiện mã hoá
// - Nếu TRUE: Thực hiện mã hoá
@property (nonatomic) BOOL isEnableEncrypt;

// Giá trị xác định public key rsa mã hóa dùng để tạo secret key (mã hóa/giải mã request/response)
@property (nonatomic) NSString *encryptPublicKey;

// Giá trị xác định cách thức upload ảnh lên server
// - EkycDefault: Thực hiện tải ảnh trực tiếp lên Minio
// - EkycCreateLink: Thực hiện tạo link -> upload ảnh
@property (nonatomic) ModeUploadFile modeUploadFile;

/*========== CÁC THUỘC TÍNH VỀ GIẤY TỜ ==========*/

// Giá trị này xác định kiểu giấy tờ để sử dụng. Mặc định là IdentityCard (Chứng minh nhân dân)
// - IdentityCard: Chứng minh thư nhân dân, Căn cước công dân
// - IDCardChipBased: Căn cước công dân gắn Chip
// - Passport: Hộ chiếu
// - DriverLicense: Bằng lái xe
// - MilitaryIdCard: Chứng minh thư quân đội
@property (nonatomic) TypeDocument documentType;

// Giá trị mã ảnh giấy tờ mặt trước được truyền vào để thực hiện ocrBack. Mặc định ""
@property (nonatomic) NSString *hashFrontOCR;

// Bật chức năng kiểm tra "ảnh giấy tờ" chụp trực tiếp hay không. Mặc định false
@property (nonatomic) BOOL isCheckLivenessCard;

// Bật chức năng quét mã QR. Hiển thị màn hình quét mã trước màn hình chụp giấy tờ mặt trước. Mặc định false
@property (nonatomic) BOOL isEnableScanQRCode;

// Bật chức năng hiển thị popup kết quả quét mã QR. Mặc định false
@property (nonatomic) BOOL isShowQRCodeResult;

// Giá trị quy định mức kiểm tra giấy tờ ở SDK, sử dụng Model AI Offline. Mặc định None
// - None: Không thực hiện kiểm tra ảnh khi chụp ảnh giấy tờ
// - Basic: Kiểm tra sau khi chụp ảnh cơ bản
// - Medium: Kiểm tra sau khi chụp ảnh Nâng cao → hiển thị chi tiết lỗi chụp ảnh
// - Advance: Kiểm tra ảnh hợp lệ trước khi chụp (hiển thị nút chụp)
@property (nonatomic) TypeValidateDocument validateDocumentType;

// Giá trị này xác định việc có xác thực số ID với mã tỉnh thành, quận huyện, xã phường tương ứng hay không. Kiểm tra quy tắc của số ID. Mặc định là false
@property (nonatomic) BOOL isValidatePostcode;

// Giá trị này xác định danh sách các giấy tờ không được sử dụng
@property (nonatomic) NSMutableArray<NSNumber *> *listBlockedDocument;

// - ICEkycOCRFull
// - ICEkycOCRFront
@property (nonatomic) ModeVersionOCR modeVersionOCR;

// Bật chức năng tự động đặt crop_param = "0.0,0.0". Mặc định là false
@property (nonatomic) BOOL isAutoCropParam;

/*========== CÁC THUỘC TÍNH VỀ KHUÔN MẶT ==========*/

// Giá trị xác định việc hình thức chụp ảnh chân dung Oval. Mặc định là FarAndNear
// - FarAndNear: thực hiện chụp ảnh Oval xa và Oval gần
// - OnlyFar: thực hiện chụp ảnh Oval xa
// - OnlyNear: thực hiện chụp ảnh Oval gần
@property (nonatomic) VersionFaceOval modeVersionFaceOval;

// Bật chức năng so sánh "ảnh chân dung với ảnh chân dung" hoặc "ảnh chân dung với ảnh giấy tờ chứa chân dung". Mặc định false
@property (nonatomic) BOOL isEnableCompare;

// Loại so sánh. Mặc định 0
// 1: So sánh khuôn mặt với mặt trước giấy tờ
// 2: So sánh khuôn mặt với thông tin mặt NFC trên CCCD gắn chíp dùng compare general.
@property (nonatomic) NSInteger compareType;

// Giá trị mã ảnh (ảnh chân dung hoặc ảnh giấy tờ chứa chân dung) được truyền vào để thực hiện so sánh khuôn mặt. Mặc định ""
@property (nonatomic) NSString *hashImageCompare;

// Bật chức năng so sánh ảnh chụp chân dung với ảnh chân dung (dạng ảnh thẻ hoặc ảnh khuôn mặt). Mặc định false
// SDK sẽ thực hiện chức năng này khi đã bật chức năng so sánh (isEnableCompare = YES)
@property (nonatomic) BOOL isCompareGeneral;

// Giá trị quy định ngưỡng so sánh ảnh chụp chân dung với ảnh chân dung (dạng ảnh thẻ hoặc ảnh khuôn mặt). Mặc định "normal"
// Thuộc tính này được sử dụng khi đã bật chức năng so sánh "ảnh chụp chân dung" với "ảnh chân dung" (isEnableCompare = YES) và (isCompareGeneral = YES)
@property (nonatomic) NSString *thresLevel;

// Giá trị xác định cơ chế kiểm tra ảnh chụp chân dung. Mặc định là NoneCheckFace
// - NoneCheckFace: Không thực hiện kiểm tra ảnh chân dung chụp trực tiếp hay không
// - IBeta: Kiểm tra ảnh chân dung chụp trực tiếp hay không iBeta (phiên bản hiện tại)
// - Standard: Kiểm tra ảnh chân dung chụp trực tiếp hay không Standard (phiên bản mới)
@property (nonatomic) ModeCheckLivenessFace checkLivenessFace;

// Bật chức năng kiểm tra "ảnh chân dung" có bị che mặt hay không. Mặc định là false
@property (nonatomic) BOOL isCheckMaskedFace;



/*========== CÁC THUỘC TÍNH VỀ VIỆC QUAY VIDEO LẠI QUÁ TRÌNH THỰC HIỆN OCR VÀ FACE TRONG SDK ==========*/

// Bật chức năng quay lại video thao tác chụp ảnh chân dung Oval. Mặc định false
@property (nonatomic) BOOL isRecordVideoFace;

// Bật chức năng quay lại video thao tác chụp ảnh giấy tờ. Mặc định false
@property (nonatomic) BOOL isRecordVideoDocument;



/*========== CÁC THUỘC TÍNH VỀ MÔI TRƯỜNG PHÁT TRIỂN - URL TÁC VỤ TRONG SDK ==========*/

// Bật chức năng "WaterMark", thực hiện ký lên ảnh để đảm bảo ảnh được chụp từ SDK. Mặc định false
// Trường hợp bật chức năng này (isEnableWaterMark = true), cần cấu hình URL tương ứng với bộ TOKEN
@property (nonatomic) BOOL isEnableWaterMark;

// Bật chức năng thêm "Metadata" vào ảnh. Mặc định false
@property (nonatomic) BOOL isAddMetadataImage;

// Thời gian timeout khi gọi api, mặc định 10s
@property (nonatomic) NSInteger timeoutCallApi;

// Giá trị tên miền chính của SDK. Mặc định ""
@property (nonatomic) NSString *changeBaseUrl;

// Đường dẫn đầy đủ thực hiện tải ảnh lên phía máy chủ để nhận mã ảnh. Mặc định "" 
@property (nonatomic) NSString *urlUploadImage;

// Đường dẫn đầy đủ thực hiện bóc tách thông tin giấy tờ. Mặc định "" 
@property (nonatomic) NSString *urlOcr;

// Đường dẫn đầy đủ thực hiện bóc tách thông tin mặt trước giấy tờ. Mặc định "" 
@property (nonatomic) NSString *urlOcrFront;

// Đường dẫn đầy đủ thực hiện so sánh ảnh chụp khuôn mặt và ảnh giấy tờ chứa ảnh đại diện. Mặc định "" 
@property (nonatomic) NSString *urlCompare;

// Đường dẫn đầy đủ thực hiện so sánh ảnh chụp khuôn mặt và ảnh chân dung (dạng ảnh thẻ hoặc ảnh khuôn mặt). Mặc định "" 
@property (nonatomic) NSString *urlCompareGeneral;

// Đường dẫn đầy đủ thực hiện xác thực khuôn mặt và số giấy tờ. Mặc định "" 
@property (nonatomic) NSString *urlVerifyFace;

// Đường dẫn đầy đủ thực hiện đăng ký thông tin khuôn mặt. Mặc định "" 
@property (nonatomic) NSString *urlAddFace;

// Đường dẫn đầy đủ thực hiện đăng ký thông tin định danh thẻ. Mặc định "" 
@property (nonatomic) NSString *urlAddCardId;

// Đường dẫn đầy đủ thực hiện kiểm tra ảnh giấy tờ chụp trực tiếp. Mặc định ""
@property (nonatomic) NSString *urlLivenessCard;

// Đường dẫn đầy đủ thực hiện kiểm tra ảnh chụp khuôn mặt có bị che hay không. Mặc định ""
@property (nonatomic) NSString *urlCheckMaskedFace;

// Đường dẫn đầy đủ thực hiện tìm kiếm khuôn mặt. Mặc định "" 
@property (nonatomic) NSString *urlSearchFace;

// Đường dẫn đầy đủ thực hiện kiểm tra ảnh chân dung chụp trực tiếp (phiên bản chụp ảnh chân dung Cơ bản). Mặc định "" 
@property (nonatomic) NSString *urlLivenessFace;

// Đường dẫn đầy đủ thực hiện kiểm tra ảnh chân dung chụp trực tiếp (phiên bản chụp ảnh chân dung Nâng cao Oval). Mặc định "" 
@property (nonatomic) NSString *urlLivenessFace3D;

// Đường dẫn Lưu log toàn bộ giao dịch ngay cả khi KH bị thao tác lỗi. Chỉ gửi khi bị lỗi
@property (nonatomic) NSString *urlLogSdk;

// Thông tin KEY:VALUE truyền vào Header. Mặc định [] 
@property (nonatomic) NSMutableDictionary *headersRequest;

// Ưu tiên TransactionID trong headersRequest
@property (nonatomic) NSString *transactionId;

// Ưu tiên TransactionPartnerID trong headersRequest
@property (nonatomic) NSString *transactionPartnerId;

// Ưu tiên TransactionPartnerID trong headersRequest
// TransactionPartnerID OCR sử dụng cho khách hàng đối soát. Mặc định ""
@property (nonatomic) NSString *transactionPartnerIdOCR;

// TransactionPartnerID OCR Front sử dụng cho khách hàng đối soát. Mặc định ""
@property (nonatomic) NSString *transactionPartnerIdOCRFront;

// TransactionPartnerID Liveness Front sử dụng cho khách hàng đối soát. Mặc định ""
@property (nonatomic) NSString *transactionPartnerIdLivenessFront;

// TransactionPartnerID Liveness Back sử dụng cho khách hàng đối soát. Mặc định ""
@property (nonatomic) NSString *transactionPartnerIdLivenessBack;

// TransactionPartnerID Compare Face sử dụng cho khách hàng đối soát. Mặc định ""
@property (nonatomic) NSString *transactionPartnerIdCompareFace;

// TransactionPartnerID Liveness Face sử dụng cho khách hàng đối soát. Mặc định ""
@property (nonatomic) NSString *transactionPartnerIdLivenessFace;

// TransactionPartnerID Masked Face sử dụng cho khách hàng đối soát. Mặc định ""
@property (nonatomic) NSString *transactionPartnerIdMaskedFace;

/*========== CHỈNH SỬA TÊN CÁC TỆP TIN HIỆU ỨNG - VIDEO HƯỚNG DẪN ==========*/

// Tên hiệu ứng xoay quanh khung Oval ở màn hình chụp chân dung. Mặc định "" 
@property (nonatomic) NSString *nameOvalAnimation;

// Tên hiệu ứng nhấp nháy cảnh báo trạng thái xác định ảnh ở màn hình chụp chân dung. Mặc định "" 
@property (nonatomic) NSString *nameFeedbackAnimation;

// Tên hiệu ứng quét lên xuống ở màn hình quét mã QR. Mặc định "" 
@property (nonatomic) NSString *nameScanQRCodeAnimation;

// Tên hiệu ứng xoay quanh khung viền ở màn hình hiển thị giấy tờ đã chụp. Mặc định "" 
@property (nonatomic) NSString *namePreviewDocumentAnimation;

// Tên hiệu ứng nhấp nháy tròn ở màn hình Xử lý dũ liệu. Mặc định "" 
@property (nonatomic) NSString *nameLoadSuccessAnimation;

// Tên Audio hướng dẫn chụp ảnh khuôn mặt xa gần. Mặc định ""
@property (nonatomic) NSString *nameHelpAudioFace;

// Tên Video hướng dẫn chụp ảnh khuôn mặt Oval. Mặc định "" 
@property (nonatomic) NSString *nameHelpVideoFace;

// Tên video hướng dẫn chụp ảnh giấy tờ. Sử dụng với bản hướng dẫn nâng cao của SDK. Mặc định "" 
@property (nonatomic) NSString *nameHelpVideoDocument;



/*========== CÁC THUỘC TÍNH VỀ CÀI ĐẶT MÀU SẮC GIAO DIỆN TRONG SDK ==========*/

// Vị trí nút đóng SDK trên thanh tiêu đề. Mặc định LeftButton
// LeftButton - nút đóng bên trái
// RightButton - nút đóng bên phải.
@property (nonatomic) ModeButtonHeaderBar modeButtonHeaderBar;

// Màu nội dung thanh tiêu đề: bao gồm màu chữ và màu nút đóng. Mặc định là FFFFFF
@property (nonatomic) UIColor *contentColorHeaderBar;

// Màu nền thanh tiêu đề. Mặc định là trong suốt
@property (nonatomic) UIColor *backgroundColorHeaderBar;

// Màu nội dung chính. Áp dụng cho toàn bộ các màn hình. Mặc định là 142730
@property (nonatomic) UIColor *textColorContentMain;

// Màu tiêu đề chính. Mặc định 00A96F
// Áp dụng cho Tiêu đề: CHỤP MẶT TRƯỚC, ẢNH MẶT TRƯỚC, Chấm tròn nhỏ ở màn hình Hướng dẫn, màn hình Preview 
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

// Màu tiêu đề nút bấm ở trạng thái không hoạt động, mặc định FFFFFF
@property (nonatomic) UIColor *titleColorDeactiveButton;

// Màu nền chụp ảnh giấy tờ, quét mã QR. Mặc định FFFFFF
@property (nonatomic) UIColor *backgroundColorCaptureDocumentScreen;

// Màu nền chụp ảnh chân dung. Mặc định FFFFFF alpha = 0.75
@property (nonatomic) UIColor *backgroundColorCaptureFaceScreen;


// Màu hiệu ứng cảnh báo ở màn chụp khuôn mặt Oval, mặc định 00A96F 
@property (nonatomic) UIColor *effectColorNoticeFace;

// Màu chữ nội dung trong ô cảnh báo ở màn chụp khuôn mặt Oval, mặc định FFFFFF
@property (nonatomic) UIColor *textColorNoticeFace;

// Màu hiệu ứng cảnh báo giấy tờ không hợp lệ, mặc định CA2A2A
@property (nonatomic) UIColor *effectColorNoticeInvalidFace;

// Màu hiệu ứng Nội dung mô tả khi giấy tờ hợp lệ. mặc định 18D696 
@property (nonatomic) UIColor *colorContentFaceEffect;

// Màu hiệu ứng cảnh báo giấy tờ hợp lệ, mặc định 00A96F
@property (nonatomic) UIColor *effectColorNoticeValidDocument;

// Màu hiệu ứng cảnh báo giấy tờ không hợp lệ, mặc định CA2A2A
@property (nonatomic) UIColor *effectColorNoticeInvalidDocument;

// Màu nội dung trong ô cảnh báo giấy tờ hợp lệ. mặc định FFFFFF
@property (nonatomic) UIColor *textColorNoticeValidDocument;

// Màu nội dung trong ô cảnh báo giấy tờ không hợp lệ. mặc định FFFFFF
@property (nonatomic) UIColor *textColorNoticeInvalidDocument;


// Màu nút chụp ảnh giấy tờ, mặc định 142730 
@property (nonatomic) UIColor *tintColorButtonCapture;

// Màu đường viền khung chụp mặt Oval, cơ bản, mặc định 00A96F 
@property (nonatomic) UIColor *backgroundColorBorderCaptureFace;

// Giá trị quy định việc hiển thị LOGO thương hiệu. Mặc định false
@property (nonatomic) BOOL isShowLogo;

// LOGO thương hiệu hiển thị ở cuối mỗi màn hình. Mặc định là Powered by ✻ VNPT AI
@property (nonatomic) UIImage *logo;

// LOGO thương hiệu hiển thị ở màn hình chụp Oval. Mặc định là VNPT AI
@property (nonatomic) UIImage *logoFaceOval;

// Kích thước Ảnh thương hiệu. Mặc định 148.0 * 20.0 (chiều rộng * chiều cao)
@property (nonatomic) CGFloat widthLogo;

// Kích thước Ảnh thương hiệu. Mặc định 148.0 * 20.0 (chiều rộng * chiều cao)
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

// Màu nền của các màn hình dạng cảnh báo. Mặc định FFFFFF
@property (nonatomic) UIColor *backgroundColorPopup;

// Màu chữ của các màn hình dạng cảnh báo. Mặc định 142730
@property (nonatomic) UIColor *textColorContentPopup;

// Kiểm tra camera ảo. Mặc định là false
@property (nonatomic) BOOL isEnableCheckVirtualCamera;

// Kiểm tra máy ảo. Mặc định là false
@property (nonatomic) BOOL isEnableCheckSimulator;

// Kiểm tra máy jailbreak. Mặc định là false
@property (nonatomic) BOOL isEnableCheckJailbroken;

// Giá trị xác định khi đóng SDK có animation hay không. Mặc định là true
@property (nonatomic) BOOL isAnimatedDismissed;

// Số lần tối đa quét lại QRCode. Mặc định là vô hạn lần
@property(nonatomic, nullable) NSNumber *numberTimesRetryScanQRCode;

// Thời gian giới hạn quá trình quét QR. Mặc định vô hạn
@property (nonatomic, nullable) NSNumber *timeoutQRCodeFlow;

// màn hình tuỳ chỉnh cho màn hướng dẫn quét QR
@property (nonatomic, nullable) UIView *viewTutorialScanQRCode;

// Bật chức năng Flash khi chụp ảnh chân dung. Mặc định là false
@property (nonatomic) BOOL isEnableFlash;

// Màu nền của Flash. Mặc định là red
@property (nonatomic) UIColor *backgroundColorFlash;

// Màu của text Flash. Mặc định là white
@property (nonatomic) UIColor *colorTitleFlash;


#pragma mark - Các phương thức gọi trực tiếp từ ICEkycCameraViewController

/**
 * Phương thức trả về thông tin phiên bản của SDK
 * Phương thức được gọi từ phía ngoài ứng dụng.
 */
+ (NSString *)getVersionSDK;


@end

NS_ASSUME_NONNULL_END
