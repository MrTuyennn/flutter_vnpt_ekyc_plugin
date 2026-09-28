//
//  ICEkycAddInformation.h
//  ICSdkEKYC
//
//  Created by MinhMinhMinh on 30/10/2023.
//  Copyright © 2023 iOS Team IC - Innovation Center. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ICEkycAddInformation : NSObject

// UUID của khách hàng cần thêm. (không được để trống)
@property (nonatomic) NSString *uuidCustomer;

// ID của thẻ. (required)
@property (nonatomic) NSString *cardId;

// Loại giấy tờ. (không được để trống)
// - 0: Chứng minh nhân dân cũ
// - 1: Căn cước công dân
// - 2: Hộ chiếu
// - 3: Chứng minh quân đội
// - 4: Giấy phép lái xe
// - 5: Căn cước gắn chíp
// - 98: Chứng minh công an
// - 99: Giấy tờ khác"
@property (nonatomic) NSInteger cardCategoryId;

// Tên đầy đủ. (không được để trống)
@property (nonatomic) NSString *fullName;

// Ngày sinh. (không được để trống)
@property (nonatomic) NSString *dateOfBirth;

// Giới tính
@property (nonatomic) NSString *gender;

// Địa chỉ thường trú
@property (nonatomic) NSString *recentLocation;

// Quê quán
@property (nonatomic) NSString *originLocation;

// Ngày cấp
@property (nonatomic) NSString *issueDate;

// Nơi cấp
@property (nonatomic) NSString *issuePlace;

// Hiệu lực
@property (nonatomic) NSString *validDate;

// Hash ảnh giấy tờ mặt trước
@property (nonatomic) NSString *hashImageFront;

// Hash ảnh giấy tờ mặt sau
@property (nonatomic) NSString *hashImageBack;

// Quốc tịch
@property (nonatomic) NSString *nationality;

// Dùng cho hộ chiếu
@property (nonatomic) NSString *citizenId;

// Hạng (dùng cho bằng lái xe)
@property (nonatomic) NSString *rank;

// Loại (dùng cho hộ chiếu)
@property (nonatomic) NSString *cardSubType;

// Mã số (dùng cho hộ chiếu)
@property (nonatomic) NSString *codeNumber;

// Thông tin thêm
@property (nonatomic) NSString *extraInfo;

// Cộng hòa xã hội chủ nghĩa việt nam
@property (nonatomic) NSString *nationPolicy;

// Độc lập – tự do – hạnh phúc
@property (nonatomic) NSString *nationSlogan;

// Token ảnh watermask
@property (nonatomic) NSString *token;

@end

NS_ASSUME_NONNULL_END
