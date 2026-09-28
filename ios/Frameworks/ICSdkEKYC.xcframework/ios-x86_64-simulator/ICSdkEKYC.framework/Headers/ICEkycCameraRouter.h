//
//  ICEkycCameraRouter.h
//  ICSdkEKYC
//
//  Created by MinhMinh on 08/12/2022.
//  Copyright © 2022 iOS Team IC - Innovation Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICEkycCameraProtocols.h"
#import "ICEkycCameraViewController.h"

@interface ICEkycCameraRouter : NSObject<ICEkycCameraWireframeProtocol>

@property (nonatomic, weak) ICEkycCameraViewController *viewController;

+ (UIViewController *)createModule;

@end
