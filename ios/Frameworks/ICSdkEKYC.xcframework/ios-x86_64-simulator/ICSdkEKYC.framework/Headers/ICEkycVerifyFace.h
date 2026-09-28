//
//  ICEkycVerifyFace.h
//  ICSdkEKYC
//
//  Created by MinhMinhMinh on 31/10/2023.
//  Copyright © 2023 iOS Team IC - Innovation Center. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ICEkycVerifyFace : NSObject

// Mã HASH ảnh chân dung được dùng để thực hiện xác thực khuôn mặt. Mặc định "". (không được để trống)
@property (nonatomic) NSString *hashFace;

// Định danh Unit của mỗi khách hàng. Mặc định "". (không được để trống)
@property (nonatomic) NSString *uuidUnit;

// Định danh Unit của mỗi khách hàng. Mặc định ""
@property (nonatomic) NSString *unitCode;

// Định danh Unit của mỗi người dùng, đi kèm với 1 thông tin khôn mặt & số giấy tờ. Mặc định "". (không được để trống nếu không truyền `cardId`)
@property (nonatomic) NSString *uuidCustomer;

// Số ID của mỗi người dùng. Mặc định "". (không được để trống nếu không truyền `uuidCustomer`)
@property (nonatomic) NSString *cardId;

// Loại thẻ định danh. Mặc định ""
@property (nonatomic) NSString *cardIdType;

// Token truyền từ bên ngoài vào SDK. Mặc định ""
@property (nonatomic) NSString *token;


@end

NS_ASSUME_NONNULL_END
