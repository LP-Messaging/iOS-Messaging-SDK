//
//  ConversationViewController.m
//  SampleApp
//
//  Created by Nimrod Shai on 2/23/16.
//  Copyright © 2016 LivePerson. All rights reserved.
//

#import "ConversationViewController.h"

@implementation ConversationViewController

- (IBAction)backButtonPressed:(id)sender {
    [[LPMessagingSDK instance] removeConversation:self.conversationQuery];
    [[self navigationController] popViewControllerAnimated:true];
}

- (IBAction)menuButtonPressed:(id)sender {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Menu"
                                          message:@"Choose an option"
                                          preferredStyle:UIAlertControllerStyleActionSheet];
    
    /**
     This is how to resolve a conversation
     */
    UIAlertAction *resolveAction = [UIAlertAction actionWithTitle:@"Resolve" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[LPMessagingSDK instance] resolveConversation:self.conversationQuery];
    }];
    
    
    NSString *urgentTitle = [[LPMessagingSDK instance] isUrgent:self.conversationQuery] ? @"Dismiss Urgent" : @"Mark as Urgent";
    
    /**
     This is how to manage the urgency state of the conversation
     */
    UIAlertAction *urgentAction = [UIAlertAction actionWithTitle:urgentTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([[LPMessagingSDK instance] isUrgent:self.conversationQuery]) {
            [[LPMessagingSDK instance] dismissUrgent:self.conversationQuery];
        } else {
            [[LPMessagingSDK instance] markAsUrgent:self.conversationQuery];
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:resolveAction];
    [alertController addAction:urgentAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:true completion:^{
        
    }];
}

@end
