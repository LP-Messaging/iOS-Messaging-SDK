//
//  ViewController.swift
//  SampleApp-Swift
//
//  Created by Nimrod Shai on 2/23/16.
//  Copyright © 2016 LivePerson. All rights reserved.
//

import UIKit
import LPMessagingSDK
import LPAMS
import LPInfra

let WINDOW_SWITCH = "WindowSwitch"
let AUTHENTIACTION_SWITCH = "AuthenticationSwitch"

class MessagingViewController: UIViewController, LPMessagingSDKdelegate {

    var conversationQuery: ConversationParamProtocol?
    var conversationViewController: ConversationViewController?
    
    @IBOutlet var accountTextField: UITextField!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!

    @IBOutlet var windowSwitch: UISwitch!
    @IBOutlet var authenticationSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let windowSwitch = UserDefaults.standard.bool(forKey: WINDOW_SWITCH)
        self.windowSwitch.isOn = windowSwitch;

        let authenticationSwitch = UserDefaults.standard.bool(forKey: AUTHENTIACTION_SWITCH)
        self.authenticationSwitch.isOn = authenticationSwitch

        
        LPMessagingSDK.instance.delegate = self
        self.setSDKConfigurations()
        LPMessagingSDK.instance.subscribeLogEvents(LogLevel.trace) { (log) -> () in
            print("LPMessagingSDK log: \(String(describing: log.text))")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
        This method sets the SDK configurations.
        For example: 
        Change background color of remote user (such as Agent)
        Change background color of user (such as Consumer)
     */
    func setSDKConfigurations() {
        let configurations = LPConfig.defaultConfiguration
        configurations.remoteUserBubbleBackgroundColor = UIColor.blue
        configurations.userBubbleBackgroundColor = UIColor.lightGray
        self.setCustomButton()
    }
    
    /**
    This method sets the user details such as first name, last name, profile image and phone number.
    */
    func setUserDetails() {
        let user = LPUser(firstName: self.firstNameTextField.text!, lastName: self.lastNameTextField.text!, nickName: "my nick name", uid: nil, profileImageURL: "http://www.mrbreakfast.com/ucp/342_6053_ucp.jpg", phoneNumber: nil, employeeID: "1111-1111")
        LPMessagingSDK.instance.setUserProfile(user, brandID: self.accountTextField.text!)
    }
    
    /**
    This method lets you enter a UIBarButton to the navigation bar (in window mode).
    When the button is pressed it will call the following delegate method: LPMessagingSDKCustomButtonTapped
    */
    func setCustomButton() {
        LPConfig.defaultConfiguration.customButtonImage = UIImage(named: "phone_icon")
    }

    //MARK:- IBActions
    /// Init Monitoring and Messaging SDKs
    @IBAction func initSDKsClicked(_ sender: Any) {
        defer {
            self.view.endEditing(true)
        }
        
        guard let accountNumber = self.accountTextField.text, !accountNumber.isEmpty else {
            return
        }
        
        do {
            try LPMessagingSDK.instance.initialize(accountNumber)
        } catch let error as NSError {
            print("initialize error: \(error)")
            return
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
    @IBAction func showConversation() {
        guard let accountNumber = self.accountTextField.text, !accountNumber.isEmpty else {
            return
        }
        
        self.conversationQuery = LPMessagingSDK.instance.getConversationBrandQuery(accountNumber)
        guard self.conversationQuery != nil else {
            return
        }

        if self.windowSwitch.isOn {
            if self.authenticationSwitch.isOn {
                let conversationViewParams = LPConversationViewParams(conversationQuery: self.conversationQuery!, containerViewController: nil, isViewOnly: false)
                let authenticationParams = LPAuthenticationParams(authenticationCode: "zcKZeImY5h7xOVPj", jwt: nil, redirectURI: nil, authenticationType: .authenticated)
                LPMessagingSDK.instance.showConversation(conversationViewParams, authenticationParams: authenticationParams)
            } else {
                let conversationViewParams = LPConversationViewParams(conversationQuery: self.conversationQuery!, containerViewController: nil, isViewOnly: false)
                LPMessagingSDK.instance.showConversation(conversationViewParams, authenticationParams: nil)
            }
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            self.conversationViewController = storyboard.instantiateViewController(withIdentifier: "ConversationViewController") as? ConversationViewController

            guard self.conversationViewController != nil || self.conversationQuery != nil else {
                return
            }
            
            self.conversationViewController!.account = accountNumber
            self.conversationViewController!.conversationQuery = self.conversationQuery!
            if self.authenticationSwitch.isOn {
                let conversationViewParams = LPConversationViewParams(conversationQuery: self.conversationQuery!, containerViewController: conversationViewController, isViewOnly: false)
                let authenticationParams = LPAuthenticationParams(authenticationCode: accountNumber, jwt: nil, redirectURI: nil, authenticationType: .authenticated)
                LPMessagingSDK.instance.showConversation(conversationViewParams, authenticationParams: authenticationParams)
            } else {
                let conversationViewParams = LPConversationViewParams(conversationQuery: self.conversationQuery!, containerViewController: conversationViewController, isViewOnly: false)
                LPMessagingSDK.instance.showConversation(conversationViewParams, authenticationParams: nil)
            }
            self.navigationController?.pushViewController(self.conversationViewController!, animated: true)
        }

        self.setUserDetails()
        self.view.endEditing(true)
    }

    
    @IBAction func windowSwitchChanged(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: WINDOW_SWITCH)
        UserDefaults.standard.synchronize()
    }

    @IBAction func authenticationSwitchChanged(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: AUTHENTIACTION_SWITCH)
        UserDefaults.standard.synchronize()
    }

    //MARK:- LPMessagingSDKDelegate
    
    /**
    This delegate method is required.
    It is called when authentication process fails
    */
    func LPMessagingSDKAuthenticationFailed(_ error: NSError) {
        NSLog("Error: \(error)");
    }
    
    /**
    This delegate method is required.
    It is called when the SDK version you're using is obselete and needs an update.
    */
    func LPMessagingSDKObseleteVersion(_ error: NSError) {
        NSLog("Error: \(error)");
    }
    
    /**
    This delegate method is optional.
    It is called each time the SDK receives info about the agent on the other side.
    
    Example:
    You can use this data to show the agent details on your navigation bar (in view controller mode)
    */
    func LPMessagingSDKAgentDetails(_ agent: LPUser?) {
        guard self.conversationViewController != nil else {
            return
        }

        let name: String = agent?.nickName ?? ""
        self.conversationViewController?.title = name
    }
    
    /**
    This delegate method is optional.
    It is called each time the SDK menu is opened/closed.
    */
    func LPMessagingSDKActionsMenuToggled(_ toggled: Bool) {
        
    }
    
    /**
    This delegate method is optional.
    It is called each time the agent typing state changes.
    */
    func LPMessagingSDKAgentIsTypingStateChanged(_ isTyping: Bool) {
        
    }
    
    /**
    This delegate method is optional.
    It is called after the customer satisfaction page is submitted with a score.
    */
    func LPMessagingSDKCSATScoreSubmissionDidFinish(_ accountID: String, rating: Int) {
    
    }
    
    /**
    This delegate method is optional.
    If you set a custom button, this method will be called when the custom button is clicked.
    */
    func LPMessagingSDKCustomButtonTapped() {
        
    }
    
    /**
    This delegate method is optional.
    It is called whenever an event log is received.
    */
    func LPMessagingSDKDidReceiveEventLog(_ eventLog: String) {
        
    }
    
    /**
    This delegate method is optional.
    It is called when the SDK has connections issues.
    */
    func LPMessagingSDKHasConnectionError(_ error: String?) {
        
    }

    /**
     This delegate method is required.
     It is called when the token which used for authentication is expired
     */
    func LPMessagingSDKTokenExpired(_ brandID: String) {
        
    }
    
    /**
     This delegate method is required.
     It lets you know if there is an error with the sdk and what this error is
     */
    func LPMessagingSDKError(_ error: NSError) {
        
    }
    
    /**
     This delegate method is optional.
     It is called when the conversation view controller removed from its container view controller or window.
     */
    func LPMessagingSDKConversationViewControllerDidDismiss() {
        
    }
    
    /**
     This delegate method is optional.
     It is called when a new conversation has started, from the agent or from the consumer side.
     */
    func LPMessagingSDKConversationStarted(_ conversationID: String?) {
        
    }
    
    /**
     This delegate method is optional.
     It is called when a conversation has ended, from the agent or from the consumer side.
     */
    func LPMessagingSDKConversationEnded(_ conversationID: String?) {
        
    }
    
    /**
     This delegate method is optional.
     It is called when the customer satisfaction survey is dismissed after the user has submitted the survey/
     */
    func LPMessagingSDKConversationCSATDismissedOnSubmittion(_ conversationID: String?) {
        
    }
    
    /**
     This delegate method is optional.
     It is called each time connection state changed for a brand with a flag whenever connection is ready.
     Ready means that all conversations and messages were synced with the server.
     */
    func LPMessagingSDKConnectionStateChanged(_ isReady: Bool, brandID: String) {
        
    }
    
    /**
     This delegate method is optional.
     It is called when the user tapped on the agent’s avatar in the conversation and also in the navigation bar within window mode.
     */
    func LPMessagingSDKAgentAvatarTapped(_ agent: LPUser?) {
        
    }
    
    /**
     This delegate method is optional.
     It is called when the Conversation CSAT did load
    */
    func LPMessagingSDKConversationCSATDidLoad(_ conversationID: String?) {
        
    }
    
    /**
     This delegate method is optional.
     It is called when the Conversation CSAT skipped by the consumer
     */
    func LPMessagingSDKConversationCSATSkipped(_ conversationID: String?) {
        
    }
    
    /**
     This delegate method is optional.
     It is called when the user is opening photo sharing gallery/camera and the persmissions denied
    */
    func LPMessagingSDKUserDeniedPermission(_ permissionType: LPPermissionTypes) {
        
    }
    
    
    @IBAction func resignKeyboard() {
        self.view.endEditing(true)
    }
}

