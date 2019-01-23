//
//  MonitoringViewController.m
//  SampleApp
//
//  Created by Nir Lachman on 12/02/2018.
//  Copyright © 2018 LivePerson. All rights reserved.
//

#import "MonitoringViewController.h"
#import <LPMonitoring/LPMonitoring.h>
#import <LPInfra/LPInfra.h>
#import <LPMessagingSDK/LPMessagingSDK.h>

NSString * const consumerID = @"CONSUMER_ID"; // REPLACE THIS!
NSString * const appInstallID = @"APP_INSTALL_ID"; // REPLACE THIS!
@interface MonitoringViewController ()
@property (nonatomic, strong)  NSString * _Nullable  pageId;
@property (nonatomic, strong)  LPCampaignInfo * _Nullable  campaignInfo;
@end

@implementation MonitoringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// MARK: IBAction
/// Init Messaging SDK with brandID (account number) and LPMonitoringInitParams (For monitoring)
- (IBAction)initSdkClicked:(id)sender {
    [[self view] endEditing:YES];
    NSString *account = self.accountTextField.text;
    if (account.length > 0) {
        LPMonitoringInitParams *monitoringInitParams = [[LPMonitoringInitParams alloc] initWithAppInstallID: account];
        NSError *error = nil;
        [[LPMessagingSDK instance] initialize:account monitoringInitParams:monitoringInitParams error:&error];
        if (error) {
            NSLog(@"LPMessagingSDK Initialize Error: %@",error);
            return;
        }
    }
}

/// Get Engagement clicked selector
/// Send new Get Engagement using LPMonitoringAPI
/// CampaignInfo will be saved in the response in order to be able to use routed conversation in Messaging, using the MessagingSDK
- (IBAction)getEngagementClicked:(id)sender {
    [[self view] endEditing:YES];
    
    NSArray *entryPoints = @[@"tel://972737004000",
                             @"http://www.liveperson.com",
                             @"sec://Sport",
                             @"lang://Eng"];
    NSArray *engagementAttributes = @[
                                      @{@"type": @"purchase", @"total": @20.0},
                                      @{@"type": @"lead", @"lead": @{@"topic": @"luxury car test drive 2015", @"value": @22.22, @"leadId": @"xyz123"}},
                                      ];
    
    LPMonitoringParams *monitoringParams = [[LPMonitoringParams alloc] initWithEntryPoints:entryPoints engagementAttributes:engagementAttributes pageId:NULL];
    __weak MonitoringViewController *weakSelf = self;
      LPMonitoringIdentity *identity = [[LPMonitoringIdentity alloc] initWithConsumerID:consumerID
                                                                                 issuer:@""];
      [[LPMonitoringAPI instance] getEngagementWithIdentities:@[identity] monitoringParams:monitoringParams completion:^(LPGetEngagementResponse * _Nonnull getEngagementResponse) {
          weakSelf.pageId = getEngagementResponse.pageId;
          if (getEngagementResponse.engagementDetails.count > 0) {
              weakSelf.pageId = getEngagementResponse.pageId;
              LPEngagementDetails *engagementDetails = getEngagementResponse.engagementDetails[0];
              NSInteger campaignId = engagementDetails.campaignId;
              NSInteger engagementId = engagementDetails.engagementId;
              NSString *contextId = engagementDetails.contextId;
              NSString *sessionId = getEngagementResponse.sessionId;
              NSString *visitorId = getEngagementResponse.visitorId;
              if (campaignId > 0 && engagementId > 0 && contextId != nil) {
                  weakSelf.campaignInfo = [[LPCampaignInfo alloc] initWithCampaignId:campaignId
                                                                        engagementId:engagementId
                                                                           contextId:contextId
                                                                           sessionId:sessionId
                                                                           visitorId:visitorId];
              }
          }
      } failure:^(NSError * _Nonnull error) {
          weakSelf.campaignInfo = nil;
          NSLog(@"get engagement error: %@", error.localizedDescription);
      }];
}

/// Send SDE clicked selector
/// Send new SDE using LPMonitoringAPI
/// PageID in the response will be saved for future request for SDE
- (IBAction)sendSdeClicked:(id)sender {
    [[self view] endEditing:YES];
    
    NSArray *entryPoints = @[@"tel://972737004000",
                             @"http://www.liveperson.com",
                             @"sec://Sport",
                             @"lang://Eng"];
    NSArray *engagementAttributes = @[
                                      @{@"type": @"purchase", @"total": @20.0},
                                      @{@"type": @"lead", @"lead": @{@"topic": @"luxury car test drive 2015", @"value": @22.22, @"leadId": @"xyz123"}},
                                      ];
    
    __weak MonitoringViewController *weakSelf = self;
    LPMonitoringParams *monitoringParams = [[LPMonitoringParams alloc] initWithEntryPoints:entryPoints
                                                                      engagementAttributes:engagementAttributes
                                                                                    pageId:@"pageId"];
    LPMonitoringIdentity *identity = [[LPMonitoringIdentity alloc] initWithConsumerID:consumerID
                                                                               issuer:@"BrandIssuer"];
    [[LPMonitoringAPI instance] sendSDEWithIdentities:@[identity] monitoringParams:monitoringParams completion:^(LPSendSDEResponse * _Nonnull sendSdeResponse) {
        weakSelf.pageId = sendSdeResponse.pageId;
    } failure:^(NSError * _Nonnull error) {
        weakSelf.campaignInfo = nil;
        NSLog(@"send sde error: %@", error.localizedDescription);
    }];
}

/// Show Conversation clicked selector
/// Show conversation in MessagingSDK will use the saved CampaignInfo, if received, from the Get Engagement Request
- (IBAction)showConversationWithCampaignClicked:(id)sender {
    [[self view] endEditing:YES];
    
    if (self.campaignInfo != nil && self.accountTextField.text.length > 0) {
        id <ConversationParamProtocol> conversationQuery = [[LPMessagingSDK instance] getConversationBrandQuery:self.accountTextField.text campaignInfo:self.campaignInfo];
        LPConversationViewParams *conversationViewParams = [[LPConversationViewParams alloc] initWithConversationQuery:conversationQuery
                                                                                               containerViewController:nil
                                                                                                            isViewOnly:NO
                                                                                       conversationHistoryControlParam:nil];
        [[LPMessagingSDK instance] showConversation:conversationViewParams authenticationParams:nil];
    }
}

/// Logout clicked selector
/// Logout Messaging SDK - all the data will be cleared
- (IBAction)logoutClicked:(id)sender {
    [[self view] endEditing:YES];
    [[LPMessagingSDK instance] logoutWithCompletion:^{
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

@end
