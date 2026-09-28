//
//  ICEkycCameraPresenter.h
//  ICSdkEKYC
//
//  Created by MinhMinh on 08/12/2022.
//  Copyright © 2022 iOS Team IC - Innovation Center. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICEkycCameraProtocols.h"

NS_ASSUME_NONNULL_BEGIN

@interface ICEkycCameraPresenter : NSObject<ICEkycCameraInteractorOutputProtocol, ICEkycCameraPresenterProtocol>

@property (nonatomic, weak, nullable) id<ICEkycCameraViewProtocol> view;
@property (nonatomic) id<ICEkycCameraInteractorInputProtocol> interactor;
@property (nonatomic) id<ICEkycCameraWireframeProtocol> router;

- (instancetype)initWithInterface:(id<ICEkycCameraViewProtocol>)interface
                       interactor:(id<ICEkycCameraInteractorInputProtocol>)interactor
                           router:(id<ICEkycCameraWireframeProtocol>)router;

// MARK: - call api
// Thực hiện tạo link upload
- (void) callApiCreateLinkUploadImage:(UIImage *)image fileName:(NSString *)fileName contentType:(NSString *)contentType side:(NSString *)side flow:(NSString *)flow;

// Thực hiện tạo link upload
- (void) callApiCreateLinkUploadData:(NSData *)data fileName:(NSString *)fileName contentType:(NSString *)contentType side:(NSString *)side flow:(NSString *)flow;

// Thực hiện Upload ảnh lên link
- (void) callApiUploadImage:(UIImage *)image toUrl:(NSString *)toUrl hash:(NSString *)hash encrypt:(NSString *)encrypt contentType:(NSString *)contentType date:(NSString *)date signature:(NSString *)signature algorithm:(NSString *)algorithm credential:(NSString *)credential policy:(NSString *)policy side:(NSString *)side;

// Thực hiện Upload data lên link
- (void) callApiUploadData:(NSData *)data toUrl:(NSString *)toUrl hash:(NSString *)hash encrypt:(NSString *)encrypt contentType:(NSString *)contentType date:(NSString *)date signature:(NSString *)signature algorithm:(NSString *)algorithm credential:(NSString *)credential policy:(NSString *)policy side:(NSString *)side;

// thực hiện tải ảnh QRCode lên máy chủ
- (void) callApiUploadQRCodeImage:(UIImage *)image cropedImage:(UIImage *)cropedImage path:(NSURL *)path title:(NSString *)title description:(NSString *)description flow:(NSString *)flow;


// thực hiện tải ảnh MẶT TRƯỚC (Chụp giấy tờ) lên máy chủ
- (void) callApiUploadFrontImage:(UIImage *)image cropedImage:(UIImage *)cropedImage path:(NSURL *)path title:(NSString *)title description:(NSString *)description flow:(NSString *)flow;

// thực hiện tải ảnh MẶT SAU (Chụp giấy tờ) lên máy chủ
- (void) callApiUploadBackImage:(UIImage *)image cropedImage:(UIImage *)cropedImage path:(NSURL *)path title:(NSString *)title description:(NSString *)description flow:(NSString *)flow;


// thực hiện tải ảnh CHÂN DUNG THẲNG (Chụp chân dung 1 hướng hoặc xoay mặt) lên máy chủ
- (void) callApiUploadFaceImage:(UIImage *)image cropedImage:(UIImage *)cropedImage path:(NSURL *)path title:(NSString *)title description:(NSString *)description flow:(NSString *)flow;

// thực hiện tải ảnh CHÂN DUNG QUAY TRÁI (Chụp chân dung xoay mặt) lên máy chủ
// thực hiện tải ảnh CHÂN DUNG QUAY PHẢI (Chụp chân dung xoay mặt) lên máy chủ

// thực hiện tải ảnh CHÂN DUNG XA (Chụp chân dung Oval) lên máy chủ
- (void) callApiUploadFarFaceImage:(UIImage *)image cropedImage:(UIImage *)cropedImage path:(NSURL *)path title:(NSString *)title description:(NSString *)description flow:(NSString *)flow;

// thực hiện tải ảnh CHÂN DUNG GẦN (Chụp chân dung Oval) lên máy chủ
- (void) callApiUploadNearFaceImage:(UIImage *)image cropedImage:(UIImage *)cropedImage path:(NSURL *)path title:(NSString *)title description:(NSString *)description flow:(NSString *)flow;

// thực hiện tải dữ liệu QUÉT 3 CHIỀU (Chụp chân dung Oval) lên máy chủ
- (void) callApiUploadLogData:(NSData *)logData path:(NSURL *)path title:(NSString *)title description:(NSString *)description flow:(NSString *)flow;


// thực hiện BÓC TÁCH THÔNG TIN GIẤY TỜ MẶT TRƯỚC (Chụp giấy tờ)
- (void) callApiGetInfoFrontCard:(NSString *)front cropParam:(NSString *)cropParam type:(NSString *)type validate:(BOOL)validate flow:(NSString *)flow;


// thực hiện BÓC TÁCH THÔNG TIN GIẤY TỜ MẶT TRƯỚC VÀ MẶT SAU (Chụp giấy tờ)
- (void) callApiGetInformationCard:(NSString *)front back:(NSString *)back cropParam:(NSString *)cropParam type:(NSString *)type validate:(BOOL)validate flow:(NSString *)flow;

// thực hiện KIỂM TRA GIẤY TỜ MẶT TRƯỚC ĐƯỢC CHỤP TRỰC TIẾP HOẶC KHÔNG
- (void) callApiCheckLivenessFrontCard:(NSString *)card cropParam:(NSString *)cropParam flow:(NSString *)flow;

// thực hiện KIỂM TRA GIẤY TỜ MẶT SAU ĐƯỢC CHỤP TRỰC TIẾP HOẶC KHÔNG
- (void) callApiCheckLivenessBackCard:(NSString *)card cropParam:(NSString *)cropParam flow:(NSString *)flow;


// thực hiện SO SÁNH ẢNH CHÂN DUNG ở GIẤY TỜ MẶT TRƯỚC với ẢNH CHÂN DUNG vừa chụp
- (void) callApiCompareImageCard:(NSString *)front face:(NSString *)face flow:(NSString *)flow;

// thực hiện SO SÁNH ẢNH CHÂN DUNG đầy đủ (có thể lấy từ ảnh thẻ NFC) với ẢNH CHÂN DUNG vừa chụp (compare-general)
- (void) callApiCompareFaceOne:(NSString *)faceOne faceTwo:(NSString *)faceTwo thresLevel:(NSString *)thresLevel flow:(NSString *)flow;


// thực hiện KIỂM TRA KHUÔN MẶT ĐƯỢC CHỤP TRỰC TIẾP HOẶC KHÔNG
- (void) callApiCheckLivenessFace:(NSString *)face logData:(NSString *)logData modeLiveness:(ModeCheckLivenessFace)modeLiveness flow:(NSString *)flow;

// thực hiện KIỂM TRA KHUÔN MẶT ĐƯỢC CHỤP TRỰC TIẾP HOẶC KHÔNG KIỂU 3 CHIỀU
- (void) callApiCheckLiveness3DScanImageNear:(NSString *)imageNear imageFar:(NSString *)imageFar logData:(NSString *)logData modeLiveness:(ModeCheckLivenessFace)modeLiveness flow:(NSString *)flow;

// thực hiện KIỂM TRA KHUÔN MẶT CÓ BỊ CHE HAY KHÔNG
- (void) callApiCheckMaskFace:(NSString *)face flow:(NSString *)flow;

// Lưu log toàn bộ giao dịch ngay cả khi KH bị thao tác lỗi. Chỉ gửi khi bị lỗi
- (void) callApiUploadSdkLog:(NSString *)sdkLog flow:(NSString *)flow path:(NSString *)path flowEkyc:(NSString *)flowEkyc;


// thực hiện TÌM KIẾM THÔNG TIN CÁ NHÂN


// MARK: query db
// thực hiện CÀI ĐẶT LẠI thông tin ICEKYCSavedData
- (void) resetICEKYCSavedData;

//
- (void) saveClientSession:(NSString *)clientSession;

// thực hiện CÀI ĐẶT CÁC THÔNG TIN ẢNH cho ICEKYCSavedData Khi isTurnOffCallService
- (void) saveQRCode:(NSString *)qrCode qrCodeDetail:(NSString *)qrCodeDetail image:(UIImage *)image cropedImage:(UIImage *)cropedImage path:(NSURL *)path;

- (void) saveFrontImage:(UIImage *)image cropedImage:(UIImage *)cropedImage path:(NSURL *)path cropParam:(NSString *)cropParam;

- (void) saveBackImage:(UIImage *)image cropedImage:(UIImage *)cropedImage path:(NSURL *)path cropParam:(NSString *)cropParam;
//
- (void) saveStraightFaceImage:(UIImage *)image cropedImage:(UIImage *)cropedImage path:(NSURL *)path;
//
- (void) saveFarImage:(UIImage *)farImage cropedFar:(UIImage *)cropedFar nearImage:(UIImage *)nearImage cropedNear:(UIImage *)cropedNear dataScan3D:(NSData *)dataScan3D path:(NSURL *)path;

@end

NS_ASSUME_NONNULL_END
