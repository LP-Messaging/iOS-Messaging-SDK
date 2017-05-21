//
//  ViewController.h
//  SampleApp
//
//  Created by Nimrod Shai on 2/11/16.
//  Copyright © 2016 LivePerson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConversationViewController.h"

@interface ViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITextField *accountTextField;
@property (nonatomic, weak) IBOutlet UITextField *firstNameTextField;
@property (nonatomic, weak) IBOutlet UITextField *lastNametextField;

@property (nonatomic, weak) IBOutlet UISwitch *authenticationSwitch;
@property (nonatomic, weak) IBOutlet UISwitch *windowSwitch;

@property (nonatomic, strong) ConversationViewController* conversationViewController;

@end

