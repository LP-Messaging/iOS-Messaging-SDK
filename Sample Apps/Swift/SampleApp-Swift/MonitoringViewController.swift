//
//  MonitoringViewController.swift
//  SampleApp-Swift
//
//  Created by Nir Lachman on 12/02/2018.
//  Copyright © 2018 LivePerson. All rights reserved.
//

import UIKit
import LPMessagingSDK
import LPInfra
import LPMonitoring

class MonitoringViewController: UIViewController {
    @IBOutlet var accountTextField: UITextField!
    let consumerID = "CONSUMER_ID" // REPLACE THIS!
    let appInstallID = "APP_INSTALL_ID" // REPLACE THIS!
    var pageId: String?
    var campaignInfo: LPCampaignInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: IBActions
    
    /// Init Messaging SDK with brandID (account number) and LPMonitoringInitParams (For monitoring)
    @IBAction func initSDKsClicked(_ sender: Any) {
        defer {
            self.view.endEditing(true)
        }
        
        guard let accountNumber = self.accountTextField.text, !accountNumber.isEmpty else {
            return
        }
        
        let monitoringInitParams = LPMonitoringInitParams(appInstallID: appInstallID)

        do {
            try LPMessagingSDK.instance.initialize(accountNumber, monitoringInitParams: monitoringInitParams)
        } catch let error as NSError {
            print("initialize error: \(error)")
            return
        }
    }
    
    /// Get Engagement clicked selector
    /// Send new Get Engagement using LPMonitoringAPI
    /// CampaignInfo will be saved in the response in order to be able to use routed conversation in Messaging, using the MessagingSDK
    @IBAction func getEngagementClicked(_ sender: Any) {
        defer {
            self.view.endEditing(true)
        }

        let entryPoints = ["tel://972737004000",
                           "http://www.liveperson.com",
                           "sec://Sport",
                           "lang://Eng"]
        let engagementAttributes = [
            ["type": "purchase", "total": 20.0],
            ["type": "lead",
             "lead": ["topic": "luxury car test drive 2015",
                      "value": 22.22,
                      "leadId": "xyz123"]]
        ]

        let monitoringParams = LPMonitoringParams(entryPoints: entryPoints, engagementAttributes: engagementAttributes)
        let identity = LPMonitoringIdentity(consumerID: consumerID, issuer: "")
        LPMonitoringAPI.instance.getEngagement(identities: [identity], monitoringParams: monitoringParams, completion: { [weak self] (getEngagementResponse) in
            print("received get engagement response with pageID: \(String(describing: getEngagementResponse.pageId)), campaignID: \(String(describing: getEngagementResponse.engagementDetails?.first?.campaignId)), engagementID: \(String(describing: getEngagementResponse.engagementDetails?.first?.engagementId))")
            // Save PageId for future reference
            self?.pageId = getEngagementResponse.pageId
            if let campaignID = getEngagementResponse.engagementDetails?.first?.campaignId, let engagementID = getEngagementResponse.engagementDetails?.first?.engagementId, let contextID = getEngagementResponse.engagementDetails?.first?.contextId, let sessionID = getEngagementResponse.sessionId, let visitorID = getEngagementResponse.visitorId {
                self?.campaignInfo = LPCampaignInfo(campaignId: campaignID, engagementId: engagementID, contextId: contextID, sessionId: sessionID, visitorId: visitorID)
            }
        }) { [weak self] (error) in
            self?.campaignInfo = nil
            print("get engagement error: \(error.userInfo.description)")
        }
    }
    
    /// Send SDE clicked selector
    /// Send new SDE using LPMonitoringAPI
    /// PageID in the response will be saved for future request for SDE
    @IBAction func sendSDEClicked(_ sender: Any) {
        defer {
            self.view.endEditing(true)
        }

        let entryPoints = ["http://www.liveperson-test.com",
                           "sec://Food",
                           "lang://De"]
        let engagementAttributes = [
            ["type": "purchase",
             "total": 11.7,
             "orderId": "DRV1534XC"],
            ["type": "lead",
             "lead": ["topic": "luxury car test drive 2015",
                      "value": 22.22,
                      "leadId": "xyz123"]]
        ]

        let monitoringParams = LPMonitoringParams(entryPoints: entryPoints, engagementAttributes: engagementAttributes, pageId: self.pageId)
        let identity = LPMonitoringIdentity(consumerID: consumerID, issuer: "BrandIssuer")
        LPMonitoringAPI.instance.sendSDE(identities: [identity], monitoringParams: monitoringParams, completion: { [weak self] (sendSdeResponse) in
            print("received send sde response with pageID: \(String(describing: sendSdeResponse.pageId))")
            // Save PageId for future reference
            self?.pageId = sendSdeResponse.pageId
        }) { [weak self] (error) in
            self?.pageId = nil
            print("send sde error: \(error.userInfo.description)")
        }
    }
    
    /// Show Conversation clicked selector
    /// Show conversation in MessagingSDK will use the saved CampaignInfo, if received, from the Get Engagement Request
    @IBAction func showConversationWithCampaignClicked(_ sender: Any) {
        guard let campaignInfo = self.campaignInfo, let accountNumber = self.accountTextField.text, !accountNumber.isEmpty  else {
            print("Can't show conversation without valid campaignInfo")
            return
        }

        let conversationQuery = LPMessagingSDK.instance.getConversationBrandQuery(accountNumber, campaignInfo: campaignInfo)
        let conversationViewParam = LPConversationViewParams(conversationQuery: conversationQuery, isViewOnly: false)
        LPMessagingSDK.instance.showConversation(conversationViewParam)
    }
    
    /// Logout clicked selector
    /// Logout Monitoring and Messaging SDKs - all the data will be cleared
    @IBAction func logoutClicked(_ sender: Any) {
        LPMessagingSDK.instance.logout(completion: {
            
        }) { (error) in
            
        }
    }
}


