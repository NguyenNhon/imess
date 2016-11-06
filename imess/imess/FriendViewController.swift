//
//  FriendViewController.swift
//  imess
//
//  Created by Nhon Nguyen on 11/2/16.
//  Copyright © 2016 Nhon Nguyen. All rights reserved.
//

import UIKit

class FriendViewController: UIViewController {
    var actionButton: ActionButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButton = ActionButton(attachedToView: self.view)
        actionButton.action = { button in button.toggleMenu() }
        actionButton.setTitle("+", forState: UIControlState())
        actionButton.backgroundColor = UIColor(red: 238.0/255.0, green: 130.0/255.0, blue: 34.0/255.0, alpha:1.0)
        actionButton.getButton().addTarget(self, action: #selector(FriendViewController.buttonTouchDown(_:)), for: .touchDown)
    }
    
    func buttonTouchDown(_ sender: UIButton) {
        let addFriendVC = self.storyboard?.instantiateViewController(withIdentifier: "addFriendViewController")
        self.navigationController?.pushViewController(addFriendVC!, animated: true)
    }
}
