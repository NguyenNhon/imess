//
//  AddGroupViewController.swift
//  imess
//
//  Created by Nhon Nguyen on 11/25/16.
//  Copyright © 2016 Nhon Nguyen. All rights reserved.
//

import UIKit

class AddGroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tfGroupName: UITextField!
    @IBOutlet weak var imgGroupPicture: UIImageView!
    @IBOutlet weak var tvFriends: UITableView!
    @IBAction func addFriendClick(_ sender: Any) {
        let addFriendInGroup = self.storyboard?.instantiateViewController(withIdentifier: "addFriendInGroup")
        self.navigationController?.pushViewController(addFriendInGroup!, animated: true)
    }
    
    let friendsOfCurrentUser : [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsOfCurrentUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
