//
//  MainViewController.swift
//  SampleApp-Swift
//
//  Created by Nir Lachman on 12/02/2018.
//  Copyright © 2018 LivePerson. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    // MARK: IBActions
    @IBAction func messagingClicked(_ sender: Any) {
       self.performSegue(withIdentifier: "showMessaging", sender: self)
    }
    
    @IBAction func monitoringClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "showMonitoring", sender: self)
    }
}
