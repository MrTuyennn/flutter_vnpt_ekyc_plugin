//
//  ICEkycBaseViewController.h
//  ICSdkEKYC
//
//  Created by Minh Minh iOS on 07/05/2021.
//  Copyright © 2021 Minh Nguyễn. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ICEkycBaseViewController: UIViewController

@property NSBundle* bundleSDK;

/**
 * Phương thức chuyển đổi đối tượng sang dạng NSString
 * tham số 'object' là dữ liệu được truyền vào để chuyển đổi
 */
- (NSString *)convertObjectToString:(id) object;

/**
 * Phương thức chuyển đổi kích thước theo bề ngang màn hình IPAD
 * tham số 'size' là kích thước với màn hình có bề ngang là 1200.0
 */
- (CGFloat)sizeScaleIpad:(CGFloat)size;

/**
 * Phương thức chuyển đổi kích thước theo bề ngang màn hình IPHONE
 * tham số 'size' là kích thước với màn hình có bề ngang là 667.0
 */
- (CGFloat)sizeScale:(CGFloat)size;

/**
 * Phương thức chuyển đổi kích thước theo chiều dọc màn hình IPHONE
 * tham số 'size' là kích thước với màn hình có bề ngang là 375.0
 */
- (CGFloat)heightScale:(CGFloat)height;

/**
 * Phương thức chuyển đổi kích thước phông chữ theo bề ngang màn hình IPHONE
 * tham số 'size' là kích thước với màn hình có bề ngang là 375.0
 * Quy tắc:
 * Đối với màn hình có kích thước bề ngang từ 375.0 trở xuống thì giữ nguyên
 * Đối với màn hình có kích thước bề ngang trên 375.0, giá trị sẽ thay đổi như sau:
 */
- (CGFloat)fontSizeScale:(NSInteger)size;

/**
 * Phương thức chuyển đổi mã màu sang dạng UIColor
 * tham số 'rgbValue' là mã màu dạng #RGB
 * tham số 'alpha' là giá trị đậm nhạt của màu sắc, có giá trị từ 0.0(nhạt nhất) đến 1.0(đậm nhất)
 */
- (UIColor *)UIColorFromRGB:(int)rgbValue alpha:(CGFloat)alpha;

/**
 * Phương thức chuyển đổi ngôn ngữ từ KEY dang dạng VALUE, sử dụng cho chức năng đa ngôn ngữ
 * tham số 'key' là định dang cho nội dung
 * tham số 'inputLanguage' là định danh cho ngôn ngữ
 */
- (NSString *)setICEkycLocalizedString:(NSString *)key inputLanguage:(NSString*)inputLanguage;

/**
 * Phương thức lấy chiều cao của phần StatusBar. Phần hiển thị thời gian, thông tin Wifi, thông tin mạng dịch vụ
 */
- (CGFloat)getStatusBarHeight;

/**
 * Phương thức lấy chiều cao phần 'Bottom' của 'safeAreaInsets'. Phần dùng để vuốt lên để hiển thị các ứng dụng
 */
- (CGFloat)getBottomPadding;

/**
 * Phương thức lấy chiều cao của UILabel dựa vào nội dung và chiều rộng của nó
 * tham số 'label' là UILabel được sử dụng
 * tham số 'width' là chiều rộng của UILabel trên màn hình sau khi hiển thị
 */
- (CGFloat)getLabelHeight:(UILabel*)label width:(CGFloat) width;

/**
 * Phương thức chỉ định thuộc tính cho một đoạn ký tự để hiển thị
 * tham số 'text' là nội dung cần chỉnh sửa màu sắc
 * tham số 'textColor' là màu sắc cần chỉnh sửa, cài đặt
 * tham số 'font' là phông chữ cần chỉnh sửa, cài đặt
 */
- (NSMutableAttributedString *) attributedString:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font;

/**
 * Phương thức thay đổi kích thước nội dung ảnh
 * tham số 'image' là ảnh nguyên gốc
 * tham số 'size' là kích thước cần thay đổi
 */
- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size;

/**
 * Phương thức hiển thị thông tin khi eKYC
 * tham số 'message' là nội dung cần hiển thị ở màn hình theo dõi
 */
- (void) printLogDebug:(NSString *)message;

@end
