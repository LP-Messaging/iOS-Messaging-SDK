//
//  ConversationViewController.swift
//  SampleApp-Swift
//
//  Created by Nimrod Shai on 2/23/16.
//  Copyright © 2016 LivePerson. All rights reserved.
//

import Foundation
import LPMessagingSDK

class ConversationViewController: UIViewController {

    var account: String? = nil
    var conversationQuery: ConversationParamProtocol?
    
    @IBAction func backButtonPressed() {
        if self.account != nil {
            self.conversationQuery = LPMessaging.instance.getConversationBrandQuery(self.account!)
            if self.conversationQuery != nil {
                LPMessaging.instance.removeConversation(self.conversationQuery!)
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func menuButtonPressed() {
        var style = UIAlertController.Style.actionSheet
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            style = .alert
        }
        
        let alertController = UIAlertController(title: "Menu", message: "Choose an option", preferredStyle: style)
        
        /**
        is how to resolve a conversation
        */
        let resolveAction = UIAlertAction(title: "Resolve", style: .default) { (alert: UIAlertAction) -> Void in
            if self.conversationQuery != nil {
                LPMessaging.instance.resolveConversation(self.conversationQuery!)
            }
        }
        
        let urgentTitle = LPMessaging.instance.isUrgent(self.conversationQuery!) ? "Dismiss Urgent" : "Mark as Urgent"
     
        /**
        This is how to manage the urgency state of the conversation
        */
        let urgentAction = UIAlertAction(title: urgentTitle, style: .default) { (alert: UIAlertAction) -> Void in
            if LPMessaging.instance.isUrgent(self.conversationQuery!) {
                LPMessaging.instance.dismissUrgent(self.conversationQuery!)
            } else {
                LPMessaging.instance.markAsUrgent(self.conversationQuery!)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert: UIAlertAction) -> Void in
            
        }
        
        alertController.addAction(resolveAction)
        alertController.addAction(urgentAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true) { () -> Void in
            
        }
    }
}
