//
//  GroupViewController.swift
//  imess
//
//  Created by Nhon Nguyen on 11/2/16.
//  Copyright © 2016 Nhon Nguyen. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController, UITabBarDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate{
    var actionButton: ActionButton!
    
    @IBOutlet weak var tvGroups: UITableView!
    
    @IBOutlet weak var searchBarGroup: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        actionButton = ActionButton(attachedToView: self.view)
        actionButton.action = { button in button.toggleMenu() }
        actionButton.setTitle("+", forState: UIControlState())
        actionButton.backgroundColor = UIColor(red: 238.0/255.0, green: 130.0/255.0, blue: 34.0/255.0, alpha:1.0)
        actionButton.getButton().addTarget(self, action: #selector(FriendViewController.buttonTouchDown(_:)), for: .touchDown)
    }
    
    func buttonTouchDown(_ sender : UIButton) {
        let addGroupView = self.storyboard?.instantiateViewController(withIdentifier: "AddGroup")
        self.navigationController?.pushViewController(addGroupView!, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tvGroups.dequeueReusableCell(withIdentifier: "CellGroup", for: indexPath)
        //return cell
        return UITableViewCell()
    }
}
