//
//  ICEkycCameraInteractor.h
//  ICSdkEKYC
//
//  Created by MinhMinh on 08/12/2022.
//  Copyright © 2022 iOS Team IC - Innovation Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICEkycCameraProtocols.h"

NS_ASSUME_NONNULL_BEGIN

@interface ICEkycCameraInteractor : NSObject<ICEkycCameraInteractorInputProtocol>

@property (nonatomic, weak, nullable) id<ICEkycCameraInteractorOutputProtocol> output;

@end

NS_ASSUME_NONNULL_END
