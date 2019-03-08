//
//  AppDelegate.m
//  SampleApp
//
//  Created by Nimrod Shai on 2/11/16.
//  Copyright © 2016 LivePerson. All rights reserved.
//

#import "AppDelegate.h"
#import <LPMessagingSDK/LPMessagingSDK.h>
#import <LPInfra/LPInfra.h>
#import <LPAMS/LPAMS.h>

@interface AppDelegate () <LPMessagingSDKNotificationDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // Register for push remote push notifications
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    return YES;
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[LPMessagingSDK instance] registerPushNotificationsWithToken:deviceToken notificationDelegate:self alternateBundleID:nil authenticationParams:nil];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [[LPMessagingSDK instance] handlePush:userInfo];
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
