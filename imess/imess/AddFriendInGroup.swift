//
//  AddFriendInGroup.swift
//  imess
//
//  Created by Nhon Nguyen on 11/27/16.
//  Copyright © 2016 Nhon Nguyen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase

class AddFriendInGroup: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, SettingCellDelegate {
    
    @IBOutlet weak var tvCurrentFriends: UITableView!
    @IBAction func clickDone(_ sender: Any) {
        
    }
    
    @IBAction func clickCancel(_ sender: Any) {
        
    }
    
    
    var currentFriends : [User] = []
    var friendsInGroup : [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func clickDoneButton(_ sender : UIBarButtonItem) {
        print("abc")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.navigationController?.navigationBar.topItem?.rightBarButtonItem?.isEnabled = true
        self.navigationController?.isNavigationBarHidden = true
        //        let btn = UIButton(type: .custom)
        //        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //        btn.addTarget(self, action: #selector(AddFriendInGroup.clickDoneButton(sender:)), for: .touchUpInside)
        //self.navigationController!.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(AddFriendInGroup.clickDoneButton(_:)))
        //self.navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
        initCurrentFriends()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MemberInGroup" {
            let vc = segue.destination as! AddGroupViewController
            vc.navigationController?.isNavigationBarHidden = false
            vc.friendsInGroup += friendsInGroup
        }
    }
    
    func initCurrentFriends() {
        FIRDatabase.database().reference().child("users").child("\((FIRAuth.auth()?.currentUser?.uid)!)").child("friends").observeSingleEvent(of: .value, with: {
            (snapshot) in
            if snapshot.value is NSNull {
                print("Not found")
            } else {
                if snapshot.exists() {
                    self.currentFriends.removeAll()
                    let enumerator = snapshot.children
                    while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                        let idFriend = (rest.value as? NSDictionary)?["id"]! as! String
                        let nameFriend = (rest.value as? NSDictionary)?["name"]! as! String
                        let photoUrlFriend = (rest.value as? NSDictionary)?["photoUrl"]! as! String
                        let emailFriend = (rest.value as? NSDictionary)?["email"]! as! String
                        self.currentFriends.append(User(name: nameFriend, email: emailFriend, id: idFriend, photoUrl: photoUrlFriend))
                    }
                    //print("\(self.currentFriends.count)")
                    self.tvCurrentFriends.reloadData()
                }
            }
            //self.activityIndicatorView.stopAnimating()
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tvCurrentFriends.dequeueReusableCell(withIdentifier: "CellForAddFriendInGroup", for: indexPath) as! CellForAddFriendInGroup
        if self.currentFriends.count > indexPath.row {
            let urlPhoto = NSURL(string: self.currentFriends[indexPath.row].photoUrl)
            if let dataPhoto = NSData(contentsOf: urlPhoto as! URL) {
                cell.profilePicture.image = UIImage(data: dataPhoto as Data)
            }
            cell.profileName.text = self.currentFriends[indexPath.row].name
            cell.profileEmail.text = self.currentFriends[indexPath.row].email
            //cell.statusInGroup.addTarget(self, action: #selector(AddFriendInGroup.changedStatus), for: UIControlEvents.valueChanged)
            cell.settingCell = self
            cell.dataProfileUid = self.currentFriends[indexPath.row].id
            cell.dataProfilePhotoUrl = self.currentFriends[indexPath.row].photoUrl
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentFriends.count
    }
    
    func didChangeStatusSwitch(sender: CellForAddFriendInGroup, isOn: Bool) {
        let indexForCell : Int = (self.tvCurrentFriends.indexPath(for: sender)?.row)!
        if indexForCell < currentFriends.count {
            if isOn {
                friendsInGroup.append(currentFriends[indexForCell])
                //print("list: \(friendsInGroup.count) add: \(friendsInGroup[friendsInGroup.count - 1].email)")
            } else {
                friendsInGroup.remove(at: friendsInGroup.index(where: {(u) -> Bool in
                    return u.email == sender.profileEmail.text!
                })!)
                //print("list: \(friendsInGroup.count) remove)")
            }
        }
    }
}
