//
//  RHC.h
//  ICSdkEKYC
//
//  Created by Lê Minh Hiếu on 6/8/25.
//  Copyright © 2025 iOS Team IC - Innovation Center. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RHC : NSObject

/// Kiểm tra xem một phương thức có bị hook hoặc can thiệp (tamper/swizzle) hay không.
/// @param className Tên lớp, ví dụ: @"UIImage", @"ICFaceOvalViewController"
/// @param selectorName Tên selector, ví dụ: @"imageWithCGImage:", @"captureOutput:didOutputSampleBuffer:fromConnection:".
/// @param isClassMethod YES nếu là class method, NO nếu là instance method
/// @return NSDictionary kết quả với định dạng:
/// {
///     @"success": @(YES/NO),
///     @"message": @"Thông tin chi tiết"
/// }
+ (NSDictionary<NSString *, id> *)cHFC:(NSString *)className selector:(NSString *)selectorName isClassMethod:(BOOL)isClassMethod;

/// Kiểm tra các thiết bị camera đáng ngờ (ví dụ: thiết bị đầu vào ảo, giả lập camera).
///
/// @return NSDictionary chứa kết quả kiểm tra, có định dạng:
///         {
///             @"success": @(YES/NO),  // YES nếu tất cả thiết bị camera hợp lệ (pass),
///                                     // NO nếu phát hiện thiết bị đáng ngờ (fail)
///             @"message": @"Chuỗi mô tả chi tiết kết quả"
///         }
+ (NSDictionary<NSString *, id> *)cSCD;

/// Kiểm tra xem trong call stack hiện tại có xuất hiện module nào bất thường không
/// (không nằm trong danh sách các module đã được load hợp lệ).
///
/// @return NSDictionary chứa kết quả kiểm tra, có định dạng:
///         {
///             @"success": @(YES/NO),  // YES nếu call stack không chứa module lạ (pass),
///                                     // NO nếu có module bất thường trong call stack (fail)
///             @"message": @"Chuỗi mô tả chi tiết kết quả"
///         }
+ (NSDictionary<NSString *, id> *)cSMC;

@end

NS_ASSUME_NONNULL_END
