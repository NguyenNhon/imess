//
//  AddGroupViewController.swift
//  imess
//
//  Created by Nhon Nguyen on 11/25/16.
//  Copyright © 2016 Nhon Nguyen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase

class AddGroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SettingSwitchInCellDelegate {
    
    
    @IBOutlet weak var tfGroupName: UITextField!
    @IBOutlet weak var imgGroupPicture: UIImageView!
    @IBOutlet weak var tvFriends: UITableView!
    
    @IBAction func clickDoneAddGroup(_ sender: Any) {
        //check text field is null
//        if self.tfGroupName.text! == "" {
//            let alert = UIAlertController(title: "Error", message: "Name group is nil", preferredStyle: .alert)
//            let alertAction = UIAlertAction(title: "OK", style: .default, handler: { (result) in
//                print("OK")
//            })
//            alert.addAction(alertAction)
//            self.present(alert, animated: true, completion: nil)
//            return
//        }
//        //show list group in group view
//        let userCurrent = ViewController.UserCurrent
//        let idUserCurrent = userCurrent?.uid
//        let ref = FIRDatabase.database().reference().child("chats")
//        ref.observeSingleEvent(of: .value, with: { snapshot in
//            var members : [String : [String : String]] = [:]
//            members["\(idUserCurrent!)"] = ["id": "\(idUserCurrent!)", "email" : "\((userCurrent?.email)!)", "name" : "\((userCurrent?.displayName)!)", "photoUrl" : "\((userCurrent?.photoURL?.path)!)"]
//            for u in self.friendsInGroup {
//                let users = ["id": "\(u.id)", "email" : "\(u.email)", "name" : "\(u.name)", "photoUrl" : "\(u.photoUrl)"]
//                members["\(u.id)"] = users
//            }
//            let refId = ref.childByAutoId()
//            refId.setValue(["title": self.tfGroupName.text!, "id": "\(refId.key)", "photoUrl": "photoGroup", "members": members])
//            
//            
//            let refUsers = FIRDatabase.database().reference().child("users")
//            for user in members {
//                //print("\(user.key) : \(user.value)")
//                refUsers.child("\(user.key)").child("chats").child("\(refId.key)").setValue(["id" : "\(refId.key)", "title" : "\(self.tfGroupName.text!)", "photoUrl": "photoGroup"])
//            }
//            //chuyển tab
//            let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "homeview")
//            self.navigationController?.pushViewController(storyboard!, animated: true)
//        })
    }
    
    var currentFriends : [User] = []
    var friendsInGroup : [User] = []
    
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
                    self.tvFriends.reloadData()
                }
            }
            //self.activityIndicatorView.stopAnimating()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //print("\(friendsInGroup.count)")
        self.tvFriends.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initCurrentFriends()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "SegueDoneAddGroup" {
            //check text field is null
            if self.tfGroupName.text! == "" {
                let alert = UIAlertController(title: "Error", message: "Name group is nil", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: { (result) in
                    print("OK")
                })
                alert.addAction(alertAction)
                self.present(alert, animated: true, completion: nil)
                return false
            }
            //show list group in group view
            let userCurrent = ViewController.UserCurrent
            let idUserCurrent = userCurrent?.uid
            let ref = FIRDatabase.database().reference().child("chats")
            ref.observeSingleEvent(of: .value, with: { snapshot in
                var members : [String : [String : String]] = [:]
                for u in self.friendsInGroup {
                    let users = ["id": "\(u.id)", "email" : "\(u.email)", "name" : "\(u.name)", "photoUrl" : "\(u.photoUrl)"]
                    members["\(u.id)"] = users
                }
                members["\(idUserCurrent!)"] = ["id": "\(idUserCurrent!)", "email" : "\((userCurrent?.email)!)", "name" : "\((userCurrent?.displayName)!)", "photoUrl" : "\((userCurrent?.photoURL?.absoluteString)!)"]
                let refId = ref.childByAutoId()
                refId.setValue(["title": self.tfGroupName.text!, "id": "\(refId.key)", "photoUrl": "photoGroup", "members": members])
                let refUsers = FIRDatabase.database().reference().child("users")
                for user in members {
                    //print("\(user.key) : \(user.value)")
                    refUsers.child("\(user.key)").child("chats").child("\(refId.key)").setValue(["id" : "\(refId.key)", "title" : "\(self.tfGroupName.text!)", "photoUrl": "photoGroup"])
                }
                self.performSegue(withIdentifier: "SegueDoneAddGroup", sender: sender)
            })
        } else {
            return true
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueCancelAddGroup" || segue.identifier == "SegueDoneAddGroup" {
            let vc = segue.destination as! HomeViewController
            vc.initTabBar = .GROUP
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tvFriends.dequeueReusableCell(withIdentifier: "CellForFriendsInGroup", for: indexPath) as! CellForFriendsInGroup
        if self.currentFriends.count > indexPath.row {
            let urlPhoto = NSURL(string: self.currentFriends[indexPath.row].photoUrl)
            if let dataPhoto = NSData(contentsOf: urlPhoto as! URL) {
                cell.profilePicture.image = UIImage(data: dataPhoto as Data)
            }
            cell.profileName.text = self.currentFriends[indexPath.row].name
            cell.profileEmail.text = self.currentFriends[indexPath.row].email
            cell.settingSwitchDelegate = self
            cell.dataProfileUid = self.currentFriends[indexPath.row].id
            cell.dataProfilePhotoUrl = self.currentFriends[indexPath.row].photoUrl
        }
        return cell
    }
    
    func didChangedStatus(_ sender: CellForFriendsInGroup, isOn: Bool) {
        let indexForCell : Int = (self.tvFriends.indexPath(for: sender)?.row)!
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
