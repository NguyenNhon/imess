//
//  RecentViewController.swift
//  imess
//
//  Created by Nhon Nguyen on 11/2/16.
//  Copyright © 2016 Nhon Nguyen. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import Firebase

class RecentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tvGroupRecent: UITableView!
    var groupRecent : [Group] = []
    weak var activityIndicatorView : UIActivityIndicatorView!
    var groupIdSelected = ""
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueRecentToChat" {
            let vc = segue.destination as! ChatFriendController
            vc.groupChatId = self.groupIdSelected
            vc.tabSendMessage = .RECENT
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        tvGroupRecent.backgroundView = activityIndicatorView
        self.activityIndicatorView = activityIndicatorView
        initGroupRecent()
    }
    
    func initGroupRecent() {
        self.activityIndicatorView.startAnimating()
        let userCurrent = ViewController.UserCurrent
        self.groupRecent.removeAll()
        FIRDatabase.database().reference().child("recent").child("\((userCurrent?.uid)!)").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.value is NSNull {
            } else {
                let data = snapshot.children
                var countGroup = snapshot.childrenCount
                while let rest = data.nextObject() as? FIRDataSnapshot {
                    let groupTemp = Group()
                    groupTemp.id = (rest.value as? NSDictionary)?["id"] as! String
                    groupTemp.title = (rest.value as? NSDictionary)?["title"] as! String
                    groupTemp.photoUrl = (rest.value as? NSDictionary)?["photoUrl"] as! String
                    groupTemp.timeSend = (rest.value as? NSDictionary)?["timeSend"] as! String
                    FIRDatabase.database().reference().child("recent").child("\((userCurrent?.uid)!)").child("\(groupTemp.id)").child("members").observeSingleEvent(of: .value, with: { (snapshotMembers) in
                        if snapshotMembers.value is NSNull {
                        } else {
                            let dataMembers = snapshotMembers.children
                            while let restMembers = dataMembers.nextObject() as? FIRDataSnapshot {
                                let memberTemp = User()
                                memberTemp.id = (restMembers.value as? NSDictionary)?["id"] as! String
                                memberTemp.email = (restMembers.value as? NSDictionary)?["email"] as! String
                                memberTemp.name = (restMembers.value as? NSDictionary)?["name"] as! String
                                memberTemp.photoUrl = (restMembers.value as? NSDictionary)?["photoUrl"] as! String
                                groupTemp.members.append(memberTemp)
                            }
                            if self.groupRecent.count > 0 {
                                if groupTemp.timeSend > self.groupRecent[0].timeSend{
                                    self.groupRecent.insert(groupTemp, at: 0)
                                } else {
                                    self.groupRecent.append(groupTemp)
                                }
                            } else {
                                self.groupRecent.append(groupTemp)
                            }
                            countGroup = countGroup - 1
                            if countGroup <= 0 {
                                self.activityIndicatorView.stopAnimating()
                                self.tvGroupRecent.reloadData()
//                                let alert = UIAlertController(title: "Message", message: "\(self.groupRecent.count) \n \(self.groupRecent[0].members.count)", preferredStyle: .alert)
//                                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
//                                alert.addAction(action)
//                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    })
                }
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groupRecent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < self.groupRecent.count && self.groupRecent[indexPath.row].members.count > 2 {
            let cell = tvGroupRecent.dequeueReusableCell(withIdentifier: "CellGroup", for: indexPath) as! CellGroup
            if indexPath.row < self.groupRecent.count {
                if self.groupRecent[indexPath.row].members.count >= 3 {
                    //let userCurrent = ViewController.UserCurrent
                    let urlPhotoUser1 = NSURL(string: self.groupRecent[indexPath.row].members[0].photoUrl)
                    if let dataPhotoUser1 = NSData(contentsOf: urlPhotoUser1 as! URL) {
                        cell.groupPictureUserOne.image = UIImage(data: dataPhotoUser1 as Data)
                        cell.groupPictureUserOne.layer.masksToBounds = true
                        cell.groupPictureUserOne.layer.cornerRadius = 25.0
                    }
                    let urlPhotoUser2 = NSURL(string: self.groupRecent[indexPath.row].members[1].photoUrl)
                    if let dataPhotoUser2 = NSData(contentsOf: urlPhotoUser2 as! URL) {
                        cell.groupPictureUserTwo.image = UIImage(data: dataPhotoUser2 as Data)
                        cell.groupPictureUserTwo.layer.masksToBounds = true
                        cell.groupPictureUserTwo.layer.cornerRadius = 12.5
                    }
                    let urlPhotoUser3 = NSURL(string: self.groupRecent[indexPath.row].members[2].photoUrl)
                    if let dataPhotoUser3 = NSData(contentsOf: urlPhotoUser3 as! URL) {
                        cell.groupPictureUserThree.image = UIImage(data: dataPhotoUser3 as Data)
                        cell.groupPictureUserThree.layer.masksToBounds = true
                        cell.groupPictureUserThree.layer.cornerRadius = 12.5
                    }
                }
                cell.groupName.text = self.groupRecent[indexPath.row].title
                cell.groupInfo.text = "\(self.groupRecent[indexPath.row].members.count) members"
            }
            return cell
        }
        let cell = self.tvGroupRecent.dequeueReusableCell(withIdentifier: "CellFriend", for: indexPath) as! CellFriend
        if self.groupRecent.count > indexPath.row {
            
            switch self.groupRecent[indexPath.row].members.count {
            case 1:
                let urlPhoto = NSURL(string: self.groupRecent[indexPath.row].members[0].photoUrl)
                if let dataPhoto = NSData(contentsOf: urlPhoto as! URL) {
                    cell.profilePictureFriend.image = UIImage(data: dataPhoto as Data)
                    cell.profilePictureFriend.layer.masksToBounds = true
                    cell.profilePictureFriend.layer.cornerRadius = 25.0
                }
                cell.profileNameFriend.text = self.groupRecent[indexPath.row].members[0].name
                cell.profileEmailFriend.text = self.groupRecent[indexPath.row].members[0].email
            case 2:
                let userCurrent = ViewController.UserCurrent
                let user = self.groupRecent[indexPath.row].members.first(where: { m in
                    return m.email != userCurrent?.email
                })
                let urlPhoto = NSURL(string: (user?.photoUrl)!)
                if let dataPhoto = NSData(contentsOf: urlPhoto as! URL) {
                    cell.profilePictureFriend.image = UIImage(data: dataPhoto as Data)
                    cell.profilePictureFriend.layer.masksToBounds = true
                    cell.profilePictureFriend.layer.cornerRadius = 25.0
                }
                cell.profileNameFriend.text = (user?.name)!
                cell.profileEmailFriend.text = (user?.email)!
            default: break
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.groupIdSelected = self.groupRecent[indexPath.row].id
        self.performSegue(withIdentifier: "SegueRecentToChat", sender: indexPath)
    }
}
