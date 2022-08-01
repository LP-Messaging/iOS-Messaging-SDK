//
//  CIContext+Workaround.h
//  LPMessagingSDK
//
//  Created by Nir Lachman on 05/10/2016.
//  Copyright © 2016 Udi Dagan. All rights reserved.
//

#import <CoreImage/CoreImage.h>

@interface CIContext (Workaround)
+ (nonnull CIContext *)lp_contextWithOptions:(nullable NSDictionary<NSString *, id> *)options;
@end
