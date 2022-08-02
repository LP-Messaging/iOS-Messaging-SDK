//
//  BSMobileProvision.h
//  Consumer
//
//  Created by Hernan Arber on 5/14/15.
//  Copyright (c) 2015 liveperson. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIApplicationReleaseMode) {
    UIApplicationReleaseUnknown,
    UIApplicationReleaseSimulator,
    UIApplicationReleaseDev,
    UIApplicationReleaseAdHoc,
    UIApplicationReleaseAppStore,
    UIApplicationReleaseEnterprise,
};

@interface UIApplication (LPBSMobileProvision)

-(UIApplicationReleaseMode) releaseMode;

@end
