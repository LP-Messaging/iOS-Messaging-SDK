//
//  AppDelegate.m
//  SampleApp
//
//  Created by Nimrod Shai on 2/11/16.
//  Copyright © 2016 LivePerson. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>

#import <LPMessagingSDK/LPMessagingSDK.h>

@interface AppDelegate () <LPMessagingSDKNotificationDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Register for push remote push notifications
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {

        }];
    }
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    return YES;
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[LPMessaging instance] registerPushNotificationsWithToken:deviceToken notificationDelegate:self alternateBundleID:nil authenticationParams:nil];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [[LPMessaging instance] handlePush:userInfo];
}

//MARK: - LPMessagingSDKNotificationDelegate
/*
 For more information on `LPMessagingSDKNotificationDelegate` see:
     https://developers.liveperson.com/mobile-app-messaging-sdk-for-ios-customizing-toast-notifications.html
 */
-(BOOL)LPMessagingSDKNotificationWithShouldShowPushNotification:(LPNotification *)notification {
    return false;
}
    
-(void)LPMessagingSDKNotificationWithDidReceivePushNotification:(LPNotification *)notification {
    
}
    
-(void)LPMessagingSDKNotificationWithNotificationTapped:(LPNotification *)notification {
    
}

@end
