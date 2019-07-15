//
//  StartViewController.swift
//  SampleApp
//
//  Created by Luis Castillo on 6/6/19.
//  Copyright © 2019 LivePerson. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    // MARK: - IBActions
    @IBAction func tabbarControllerClicked(_ sender: Any) {
        let vc = HomeTabBarViewController()
        self.present(vc, animated: true, completion: nil)
    }
}
