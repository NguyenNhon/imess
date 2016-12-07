//
//  HomeViewController.swift
//  imess
//
//  Created by Nhon Nguyen on 10/31/16.
//  Copyright © 2016 Nhon Nguyen. All rights reserved.
//

import UIKit

class HomeViewController: UITabBarController, UITabBarControllerDelegate {
//    var actionButton: ActionButton!
    var initTabBar : ETabBarName = .RECENT
    
    @IBOutlet weak var tabBarRootView: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.delegate = self
        self.navigationController?.isNavigationBarHidden = true
        print("index: \(self.selectedViewController?.textInputContextIdentifier)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        switch initTabBar {
        case .RECENT:
            self.selectedIndex = 0
        case .GROUP:
            self.selectedIndex = 1
        case .FRIEND:
            self.selectedIndex = 2
        }
    }
}

enum ETabBarName {
    case RECENT, GROUP, FRIEND
}
