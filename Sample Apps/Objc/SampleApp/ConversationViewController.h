//
//  ConversationViewController.h
//  SampleApp
//
//  Created by Nimrod Shai on 2/23/16.
//  Copyright © 2016 LivePerson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LPMessagingSDK/LPMessagingSDK.h>
#import <LPAMS/LPAMS.h>

@interface ConversationViewController : UIViewController

@property (nonatomic, strong) id <ConversationParamProtocol> conversationQuery;
@property (nonatomic, weak) NSString *account;

@end
