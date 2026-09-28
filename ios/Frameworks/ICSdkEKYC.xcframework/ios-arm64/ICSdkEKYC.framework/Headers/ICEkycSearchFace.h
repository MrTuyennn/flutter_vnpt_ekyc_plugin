//
//  ICEkycSearchFace.h
//  ICSdkEKYC
//
//  Created by MinhMinhMinh on 31/10/2023.
//  Copyright © 2023 iOS Team IC - Innovation Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ICEkycSearchFace : NSObject

// Hash khuôn mặt tìm kiếm. (không được để trống)
@property (nonatomic) NSString *hashFace;

// UUID unit chứa khuôn mặt cần tìm kiếm. (không được để trống)
@property (nonatomic) NSString *uuidUnit;

// Số kết quả tìm kiếm tối đa. (không được để trống)
@property (nonatomic) NSInteger maxResult;

// Ngưỡng tìm kiếm. (không được để trống)
@property (nonatomic) CGFloat threshold;

// Token ảnh Watermask
@property (nonatomic) NSString *token;

@end

NS_ASSUME_NONNULL_END
