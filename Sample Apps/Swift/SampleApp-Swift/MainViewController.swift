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
        let vc = MessagingViewController()
       self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func monitoringClicked(_ sender: Any) {
        let vc = MonitoringViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
