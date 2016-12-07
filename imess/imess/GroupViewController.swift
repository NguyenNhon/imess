//
//  GroupViewController.swift
//  imess
//
//  Created by Nhon Nguyen on 11/2/16.
//  Copyright © 2016 Nhon Nguyen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class GroupViewController: UIViewController, UITabBarDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate{
    var actionButton: ActionButton!
    
    @IBOutlet weak var tvGroups: UITableView!
    //@IBOutlet weak var searchBarGroup: UISearchBar!
    weak var activityIndicatorView: UIActivityIndicatorView!
    var groups : [Group] = []
    var groupId : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        tvGroups.backgroundView = activityIndicatorView
        self.activityIndicatorView = activityIndicatorView
        self.navigationController?.isNavigationBarHidden = true
        actionButton = ActionButton(attachedToView: self.view)
        actionButton.action = { button in button.toggleMenu() }
        actionButton.setTitle("+", forState: UIControlState())
        actionButton.backgroundColor = UIColor(red: 238.0/255.0, green: 130.0/255.0, blue: 34.0/255.0, alpha:1.0)
        actionButton.getButton().addTarget(self, action: #selector(FriendViewController.buttonTouchDown(_:)), for: .touchDown)
        initGroups()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueChatFriend" {
            let vc = segue.destination as! ChatFriendController
            vc.groupChatId = self.groupId
            vc.tabSendMessage = .GROUP
        }
    }
    
    func buttonTouchDown(_ sender : UIButton) {
        let addGroupView = self.storyboard?.instantiateViewController(withIdentifier: "AddGroup")
        self.navigationController?.pushViewController(addGroupView!, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.groupId = self.groups[indexPath.row].id
        self.performSegue(withIdentifier: "SegueChatFriend", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tvGroups.dequeueReusableCell(withIdentifier: "CellGroup", for: indexPath) as! CellForGroup
        if indexPath.row < self.groups.count {
//            let urlPhoto = NSURL(string: self.groups[indexPath.row].photoUrl)
//            if let dataPhoto = NSData(contentsOf: urlPhoto as! URL) {
//                cell.groupPicture.image = UIImage(data: dataPhoto as Data)
//            }
            if self.groups[indexPath.row].members.count >= 3 {
                //let userCurrent = ViewController.UserCurrent
                let urlPhotoUser1 = NSURL(string: self.groups[indexPath.row].members[0].photoUrl)
                if let dataPhotoUser1 = NSData(contentsOf: urlPhotoUser1 as! URL) {
                    cell.groupPictureUserOne.image = UIImage(data: dataPhotoUser1 as Data)
                    cell.groupPictureUserOne.layer.masksToBounds = true
                    cell.groupPictureUserOne.layer.cornerRadius = 25.0
                }
                let urlPhotoUser2 = NSURL(string: self.groups[indexPath.row].members[1].photoUrl)
                if let dataPhotoUser2 = NSData(contentsOf: urlPhotoUser2 as! URL) {
                    cell.groupPictureUserTwo.image = UIImage(data: dataPhotoUser2 as Data)
                    cell.groupPictureUserTwo.layer.masksToBounds = true
                    cell.groupPictureUserTwo.layer.cornerRadius = 12.5
                }
                let urlPhotoUser3 = NSURL(string: self.groups[indexPath.row].members[2].photoUrl)
                if let dataPhotoUser3 = NSData(contentsOf: urlPhotoUser3 as! URL) {
                    cell.groupPictureUserThree.image = UIImage(data: dataPhotoUser3 as Data)
                    cell.groupPictureUserThree.layer.masksToBounds = true
                    cell.groupPictureUserThree.layer.cornerRadius = 12.5
                }
            }
            //cell.groupViewOfPicture.layer.cornerRadius = 30.0
            cell.groupName.text = self.groups[indexPath.row].title
            //let membersInGroup =
            cell.groupInfo.text = "\(self.groups[indexPath.row].members.count) members"
        }
        return cell
    }
    
    func initGroups() {
        self.activityIndicatorView.startAnimating()
        let userCurrent = ViewController.UserCurrent
        self.groups.removeAll()
        let ref = FIRDatabase.database().reference().child("users").child("\((userCurrent?.uid)!)").child("chats")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.value is NSNull {
                self.tvGroups.reloadData()
                self.activityIndicatorView.stopAnimating()
            } else {
                let data = snapshot.children
                while let rest = data.nextObject() as? FIRDataSnapshot {
                    let groupId = rest.key
                    let groupTitle = (rest.value as? NSDictionary)?["title"] as! String
                    let groupPhotoUrl = (rest.value as? NSDictionary)?["photoUrl"] as! String
                    //let groupMembers: [User] = []
                    self.groups.append(Group(id: groupId, title: groupTitle, photoUrl: groupPhotoUrl, members: []))
                }
                for gr in self.groups {
                    let refChats = FIRDatabase.database().reference().child("chats").child("\(gr.id)").child("members")
                    refChats.observeSingleEvent(of: .value, with: { (snapshotGroup) in
                        if snapshotGroup.value is NSNull {
                        } else {
                            let usersGroup = snapshotGroup.children
                            while let restUser = usersGroup.nextObject() as? FIRDataSnapshot {
                                let idUser = (restUser.value as? NSDictionary)?["id"] as! String
                                let nameUser = (restUser.value as? NSDictionary)?["name"] as! String
                                let photoUrlUser = (restUser.value as? NSDictionary)?["photoUrl"] as! String
                                let emailUser = (restUser.value as? NSDictionary)?["email"] as! String
                                gr.members.append(User(name: nameUser, email: emailUser, id: idUser, photoUrl: photoUrlUser))
                            }
                        }
                        self.tvGroups.reloadData()
                        self.activityIndicatorView.stopAnimating()
                    })
                }
            }
        })
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let groupIdDeleted = self.groups[indexPath.row].id
            for user in self.groups[indexPath.row].members {
                FIRDatabase.database().reference().child("users").child("\(user.id)").child("chats").child("\(groupIdDeleted)").removeValue()
            }
            FIRDatabase.database().reference().child("messages").child("\(groupIdDeleted)").removeValue()
            FIRDatabase.database().reference().child("chats").child("\(groupIdDeleted)").removeValue()
            self.groups.remove(at: indexPath.row)
            self.tvGroups.reloadData()
        }
    }
}
