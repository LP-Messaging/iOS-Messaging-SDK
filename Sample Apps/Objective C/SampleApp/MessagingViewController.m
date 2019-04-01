//
//  ViewController.m
//  SampleApp
//
//  Created by Nimrod Shai on 2/11/16.
//  Copyright © 2016 LivePerson. All rights reserved.
//

#import "MessagingViewController.h"
#import <LPMessagingSDK/LPMessagingSDK.h>
#import <LPInfra/LPInfra.h>
#import <LPAMS/LPAMS.h>


#define WINDOW_SWITCH @"windowSwitch"
#define AUTHENTIACTION_SWITCH @"authenticationSwitch"


@interface MessagingViewController ()<LPMessagingSDKdelegate>

@property (nonatomic, strong) id <ConversationParamProtocol> conversationQuery;

@end

@implementation MessagingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BOOL windowSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:WINDOW_SWITCH];
    self.windowSwitch.on = windowSwitch;
    
    BOOL authenticationSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:AUTHENTIACTION_SWITCH];
    self.authenticationSwitch.on = authenticationSwitch;
    
    [LPMessagingSDK instance].delegate = self;
    [self setSDKConfigurations];
    [[LPMessagingSDK instance] subscribeLogEvents:LogLevelInfo logEvent:^(LPLog *log) {
        NSLog(@"LPMessaging Log: %@", log.text);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 This method sets the SDK configurations.
 For example:
 Change background color of remote user (such as Agent)
 Change background color of user (such as Consumer)
 */
- (void)setSDKConfigurations {
    LPConfig *configurations = [LPConfig defaultConfiguration];
    configurations.remoteUserBubbleBackgroundColor = [UIColor blueColor];
    configurations.userBubbleBackgroundColor = [UIColor lightGrayColor];
    [self setCustomButton];
}

/**
 This method sets the user details such as first name, last name, profile image and phone number.
 */
- (void)setUserDetails {
    LPUser *user = [[LPUser alloc] initWithFirstName:self.firstNameTextField.text lastName:self.lastNametextField.text nickName:@"my nickname" uid:nil profileImageURL:@"http://www.mrbreakfast.com/ucp/342_6053_ucp.jpg" phoneNumber:@"000-0000000" employeeID:@"1111-11111"];
    [[LPMessagingSDK instance] setUserProfile:user brandID:self.accountTextField.text];
}

/**
 This method lets you enter a UIBarButton to the navigation bar (in window mode).
 When the button is pressed it will call the following delegate method: LPMessagingSDKCustomButtonTapped
 */
- (void)setCustomButton {
    UIImage *customButtonImage = [UIImage imageNamed:@"phone_icon"];
    [[LPMessagingSDK instance] setCustomButton: customButtonImage];
}

#pragma mark - IBActions

- (IBAction)initSDKClicked:(id)sender {
    NSString *account = self.accountTextField.text;
    if (account.length == 0) {
        return;
    }
    
    NSError *error = nil;
    [[LPMessagingSDK instance] initialize:account monitoringInitParams:nil error:&error];
    if (error) {
        NSLog(@"LPMessagingSDK Initialize Error: %@",error);
        return;
    }
}
    
    
/**
 This method shows the conversation screen. It considers different modes:
 
 Window Mode:
 - Window           - Shows the conversation screen in a new window created by the SDK. Navigation bar is included.
 - View controller  - Shows the conversation screen in a view controller of your choice.
 
 Authentication Mode:
 - Authenticated    - Conversation history is saved and shown.
 - Unauthenticated  - Conversation starts clean every time.
 
 */
- (IBAction)showConversation:(id)sender {
    NSString *account = self.accountTextField.text;
    
    //ConversationParamProtocol
    self.conversationQuery = [[LPMessagingSDK instance] getConversationBrandQuery:account campaignInfo:nil];
    
    //LPConversationHistoryControlParam
    LPConversationHistoryControlParam * controlParam = [[LPConversationHistoryControlParam alloc] initWithHistoryConversationsStateToDisplay: LPConversationsHistoryStateToDisplayNone
                                                                                                                 historyConversationsMaxDays:-1
                                                                                                                          historyMaxDaysType:LPConversationHistoryMaxDaysDateTypeStartConversationDate];
    //ConversationViewController
    self.conversationViewController = nil;
    
    //needed for ViewController Mode (Non-Window mode)
    if (self.windowSwitch.on == false) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        self.conversationViewController = [storyBoard instantiateViewControllerWithIdentifier:@"ConversationViewController"];
        self.conversationViewController.account = account;
        self.conversationViewController.conversationQuery = self.conversationQuery;
    }
    
    //LPConversationViewParams
    LPConversationViewParams *conversationViewParams = [[LPConversationViewParams alloc] initWithConversationQuery:self.conversationQuery
                                                                                           containerViewController:self.conversationViewController
                                                                                                        isViewOnly:NO
                                                                                   conversationHistoryControlParam:controlParam];
    //LPAuthenticationParams
    LPAuthenticationParams *authenticationParams = nil;
    if (self.authenticationSwitch.on) {
        authenticationParams = [[LPAuthenticationParams alloc] initWithAuthenticationCode:@"ENTER_AUTH_CODE"
                                                                                      jwt:nil
                                                                              redirectURI:nil
                                                                    certPinningPublicKeys:nil
                                                                       authenticationType:LPAuthenticationTypeAuthenticated];
    }
    
    [[LPMessagingSDK instance] showConversation:conversationViewParams authenticationParams:authenticationParams];
    
    //needed for ViewController Mode (Non-Window mode)
    if (self.conversationViewController != nil) {
        [[self navigationController] pushViewController:self.conversationViewController animated:true];
    }
    
    [self setUserDetails];
}

- (IBAction)windowSwitchChanged:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:WINDOW_SWITCH];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)authenticationSwitchChanged:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:AUTHENTIACTION_SWITCH];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - LPMessagingSDKDelegate

/**
 This delegate method is required.
 It is called when authentication process fails
 */
- (void)LPMessagingSDKAuthenticationFailed:(NSError *)error {
    NSLog(@"Error: %@",error);
}

/**
 This delegate method is required.
 It is called when the SDK version you're using is obselete and needs an update.
 */
- (void)LPMessagingSDKObseleteVersion:(NSError *)error {
    NSLog(@"Error: %@",error);
}

/**
 This delegate method is optional.
 It is called each time the SDK receives info about the agent on the other side.
 
 Example:
 You can use this data to show the agent details on your navigation bar (in view controller mode)
 */
- (void)LPMessagingSDKAgentDetails:(LPUser *)agent {
    if (agent != nil) {
        self.title = [NSString stringWithFormat:@"%@",agent.nickName];
    } else {
        self.title = @"";
    }
}

/**
 This delegate method is optional.
 It is called each time the SDK menu is opened/closed.
 */
- (void)LPMessagingSDKActionsMenuToggled:(BOOL)toggled {
    
}

/**
 This delegate method is optional.
 It is called each time the agent typing state changes.
 */
- (void)LPMessagingSDKAgentIsTypingStateChanged:(BOOL)isTyping {
    
}

/**
 This delegate method is optional.
 It is called after the customer satisfaction page is submitted with a score.
 */
- (void)LPMessagingSDKCSATScoreSubmissionDidFinish:(NSString *)accountID rating:(NSInteger)rating {
    
}

/**
 This delegate method is optional.
 If you set a custom button, this method will be called when the custom button is clicked.
 */
- (void)LPMessagingSDKCustomButtonTapped {
    
}

/**
 This delegate method is optional.
 It is called whenever an event log is received.
 */
- (void)LPMessagingSDKDidReceiveEventLog:(NSString *)eventLog {
    
}

/**
 This delegate method is optional.
 It is called when the SDK has connections issues.
 */
- (void)LPMessagingSDKHasConnectionError:(NSString *)error {
    
}

/**
 This delegate method is required.
 It is called when the token which used for authentication is expired
 */
- (void)LPMessagingSDKTokenExpired:(NSString *)brandID {
    
}

/**
 This delegate method is required.
 It lets you know if there is an error with the SDK and what the error is
 */
- (void)LPMessagingSDKError:(NSError *)error {
    
}

/**
 This delegate method is optional.
 It is called when a new conversation has started, from the agent or from the consumer side.
 */
- (void)LPMessagingSDKConversationStarted:(NSString *)conversationID {
    
}

/**
 This delegate method is optional.
 It is called when a conversation has ended, from the agent or from the consumer side.
 */
- (void)LPMessagingSDKConversationEnded:(NSString *)conversationID {
    
}

/**
 This delegate method is optional.
 It is called each time connection state changed for a brand with a flag whenever connection is ready.
 Ready means that all conversations and messages were synced with the server.
 */
- (void)LPMessagingSDKConnectionStateChanged:(BOOL)isReady brandID:(NSString *)brandID {
    
}

/**
 This delegate method is optional.
 It is called when the customer satisfaction survey is dismissed after the user has submitted the survey/
 */
- (void)LPMessagingSDKConversationCSATDismissedOnSubmittion:(NSString *)conversationID {
    
}

/**
 This delegate method is optional.
 It is called when the conversation view controller removed from its container view controller or window.
 */
- (void)LPMessagingSDKConversationViewControllerDidDismiss {
    
}

/**
 This delegate method is optional.
 It is called when the user tapped on the agent’s avatar in the conversation and also in the navigation bar within window mode.
 */
- (void)LPMessagingSDKAgentAvatarTapped:(LPUser *)agent {
    
}

/**
 This delegate method is optional.
 It is called when the Conversation CSAT did load
 */
- (void)LPMessagingSDKConversationCSATDidLoad:(NSString *)conversationID {
    
}

/**
 This delegate method is optional.
 It is called when the Conversation CSAT skipped by the consumer
 */
- (void)LPMessagingSDKConversationCSATSkipped:(NSString *)conversationID {
    
}

/**
 This delegate method is optional.
 It is called when the user is opening photo sharing gallery/camera and the persmissions denied
 */
- (void)LPMessagingSDKUserDeniedPermission:(enum LPPermissionTypes)permissionType {
    
}

- (IBAction)resignKeyboard {
    [self.view endEditing:true];
}

@end
