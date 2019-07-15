//
//  HomeTabBarViewController.swift
//  SampleApp
//
//  Created by Luis Castillo on 6/5/19.
//  Copyright © 2019 LivePerson. All rights reserved.
//

import UIKit

class HomeTabBarViewController: UITabBarController {

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let monitoringWithNavigation = MonitoringViewController()
        let monitoringNavigationController = UINavigationController(rootViewController: monitoringWithNavigation)
        monitoringNavigationController.tabBarItem.title = "Monitoring"
        
        let messagingWithNavigation = MessagingViewController()
        let messagingNavigationController = UINavigationController(rootViewController: messagingWithNavigation)
        messagingNavigationController.tabBarItem.title = "Messaging"
        
        let messagingVCwithoutNavigation = MessagingViewController()
        messagingVCwithoutNavigation.tabBarItem.title = "Messaging w/o Nav"
        
        viewControllers = [
            monitoringNavigationController,
            messagingNavigationController,
            messagingVCwithoutNavigation
        ]
        
        self.tabBar.tintColor = UIColor.black
    }
}
