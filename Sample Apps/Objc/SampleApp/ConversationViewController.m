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
    [[LPMessaging instance] removeConversation:self.conversationQuery];
    [[self navigationController] popViewControllerAnimated:true];
}

- (IBAction)menuButtonPressed:(id)sender {
    UIAlertControllerStyle style = UIAlertControllerStyleActionSheet;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        style = UIAlertControllerStyleAlert;
    }
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Menu"
                                          message:@"Choose an option"
                                          preferredStyle:style];
    
    /**
     This is how to resolve a conversation
     */
    UIAlertAction *resolveAction = [UIAlertAction actionWithTitle:@"Resolve" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[LPMessaging instance] resolveConversation:self.conversationQuery];
    }];
    
    
    NSString *urgentTitle = [[LPMessaging instance] isUrgent:self.conversationQuery] ? @"Dismiss Urgent" : @"Mark as Urgent";
    
    /**
     This is how to manage the urgency state of the conversation
     */
    UIAlertAction *urgentAction = [UIAlertAction actionWithTitle:urgentTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([[LPMessaging instance] isUrgent:self.conversationQuery]) {
            [[LPMessaging instance] dismissUrgent:self.conversationQuery];
        } else {
            [[LPMessaging instance] markAsUrgent:self.conversationQuery];
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
