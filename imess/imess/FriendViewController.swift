//
//  FriendViewController.swift
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

class FriendViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    var actionButton: ActionButton!
    var listFriends : [User] = []
    var resultGroupId : String = ""
    
    @IBOutlet weak var tvListFriends: UITableView!
    weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        tvListFriends.backgroundView = activityIndicatorView
        self.activityIndicatorView = activityIndicatorView
        
        self.navigationController?.isNavigationBarHidden = true
        actionButton = ActionButton(attachedToView: self.view)
        actionButton.action = { button in button.toggleMenu() }
        actionButton.setTitle("+", forState: UIControlState())
        actionButton.backgroundColor = UIColor(red: 238.0/255.0, green: 130.0/255.0, blue: 34.0/255.0, alpha:1.0)
        actionButton.getButton().addTarget(self, action: #selector(FriendViewController.buttonTouchDown(_:)), for: .touchDown)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.activityIndicatorView.startAnimating()
        initListFriends()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueChatFriend" {
            let vc = segue.destination as! ChatFriendController
            vc.groupChatId = self.resultGroupId
            vc.tabSendMessage = .FRIEND
        }
    }
    
    func initListFriends() {
        FIRDatabase.database().reference().child("users").child("\((FIRAuth.auth()?.currentUser?.uid)!)").child("friends").observeSingleEvent(of: .value, with: {
            (snapshot) in
            if snapshot.value is NSNull {
                print("Not found")
            } else {
                if snapshot.exists() {
                    self.listFriends.removeAll()
                    let enumerator = snapshot.children
                    while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                        let idFriend = (rest.value as? NSDictionary)?["id"]! as! String
                        let nameFriend = (rest.value as? NSDictionary)?["name"]! as! String
                        let photoUrlFriend = (rest.value as? NSDictionary)?["photoUrl"]! as! String
                        let emailFriend = (rest.value as? NSDictionary)?["email"]! as! String
                        self.listFriends.append(User(name: nameFriend, email: emailFriend, id: idFriend, photoUrl: photoUrlFriend))
                    }
                    self.tvListFriends.reloadData()
                }
            }
            self.activityIndicatorView.stopAnimating()
        })
    }
    
    func buttonTouchDown(_ sender: UIButton) {
        let addFriendVC = self.storyboard?.instantiateViewController(withIdentifier: "addFriendViewController")
        self.navigationController?.pushViewController(addFriendVC!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listFriends.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tvListFriends.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? CustomCellFriend
        if self.listFriends.count > indexPath.row {
            let urlPhoto = NSURL(string: self.listFriends[indexPath.row].photoUrl)
            if let dataPhoto = NSData(contentsOf: urlPhoto as! URL) {
                cell?.profilePicture.image = UIImage(data: dataPhoto as Data)
                cell?.profilePicture.layer.masksToBounds = true
                cell?.profilePicture.layer.cornerRadius = 25.0
            }
            cell?.profileName.text = self.listFriends[indexPath.row].name
            cell?.profileEmail.text = self.listFriends[indexPath.row].email
            
            cell?.dataProfileUid = self.listFriends[indexPath.row].id
            cell?.dataProfilePhotoUrl = self.listFriends[indexPath.row].photoUrl
        }
        return (cell!)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //add group nếu chưa chat, nếu rồi thì lấy ra id group để lấy messages chat
        //-check đã tồn tại group gồm 2 người này chưa
        //+ Trong group usercurrent lấy danh sách private chat id: trong ds kiểm tra tồn tại email ko?
        self.activityIndicatorView.startAnimating()
        let userCurrent = ViewController.UserCurrent
        let idUserCurrent = userCurrent?.uid
        let userFriend = self.listFriends[indexPath.row]
        let refIsChatFriend = FIRDatabase.database().reference().child("users").child("\(idUserCurrent!)").child("privateChatId")
        refIsChatFriend.observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.value is NSNull {
                //chưa có chat với ai cả
                //add group chat
                let refGroup = FIRDatabase.database().reference().child("chats").childByAutoId()
                var members : [String : [String : String]] = [:]
                members["\(idUserCurrent!)"] = ["id": "\(idUserCurrent!)", "email": "\((userCurrent?.email)!)", "name": "\((userCurrent?.displayName)!)", "photoUrl": "\((userCurrent?.photoURL?.absoluteString)!)"]
                members["\(userFriend.id)"] = ["id": "\(userFriend.id)", "email": "\(userFriend.email)", "name": "\(userFriend.name)", "photoUrl": "\(userFriend.photoUrl)"]
                refGroup.setValue(["id": "\(refGroup.key)", "title": "\((userCurrent?.email)!)+\(userFriend.email)", "photoUrl": "photoGroup", "members": members])
                //add vào private chat id (id group : email friend)
                let refUser = FIRDatabase.database().reference().child("users")
                refUser.observeSingleEvent(of: .value, with: { (snapshot) in
                    refUser.child("\(idUserCurrent!)").child("privateChatId").child("\(refGroup.key)").setValue(["email": "\(userFriend.email)"])
                    refUser.child("\(userFriend.id)").child("privateChatId").child("\(refGroup.key)").setValue(["email": "\((userCurrent?.email)!)"])
                    self.resultGroupId = refGroup.key
                    self.performSegue(withIdentifier: "SegueChatFriend", sender: indexPath)
                    self.activityIndicatorView.stopAnimating()
                    return
                })
            } else {
                let enumerator = snapshot.children
                while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                    let emailFriend = (rest.value as? NSDictionary)?["email"] as! String
                    if emailFriend == userFriend.email {
                        self.resultGroupId = rest.key
                        self.performSegue(withIdentifier: "SegueChatFriend", sender: indexPath)
                        self.activityIndicatorView.stopAnimating()
                        return
                    }
                }
                if self.resultGroupId == "" {
                    let refGroup = FIRDatabase.database().reference().child("chats").childByAutoId()
                    var members : [String : [String : String]] = [:]
                    members["\(idUserCurrent!)"] = ["id": "\(idUserCurrent!)", "email": "\((userCurrent?.email)!)", "name": "\((userCurrent?.displayName)!)", "photoUrl": "\((userCurrent?.photoURL?.absoluteString)!)"]
                    members["\(userFriend.id)"] = ["id": "\(userFriend.id)", "email": "\(userFriend.email)", "name": "\(userFriend.name)", "photoUrl": "\(userFriend.photoUrl)"]
                    refGroup.setValue(["id": "\(refGroup.key)", "title": "\((userCurrent?.email)!)+\(userFriend.email)", "photoUrl": "photoGroup", "members": members])
                    let refUser = FIRDatabase.database().reference().child("users")
                    refUser.observeSingleEvent(of: .value, with: { (snapshot) in
                        refUser.child("\(idUserCurrent!)").child("privateChatId").child("\(refGroup.key)").setValue(["email": "\(userFriend.email)"])
                        refUser.child("\(userFriend.id)").child("privateChatId").child("\(refGroup.key)").setValue(["email": "\((userCurrent?.email)!)"])
                        self.resultGroupId = refGroup.key
                        self.performSegue(withIdentifier: "SegueChatFriend", sender: indexPath)
                        self.activityIndicatorView.stopAnimating()
                        return
                    })
                }
            }
        })
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //todo: xoá bạn trong friends của users, và xoá id group chat private
            let userCurrent = ViewController.UserCurrent
            let friend = self.listFriends[indexPath.row]
            FIRDatabase.database().reference().child("users").child("\((userCurrent?.uid)!)").child("friends").child("\(friend.id)").removeValue()
            FIRDatabase.database().reference().child("users").child("\(friend.id)").child("friends").child("\((userCurrent?.uid)!)").removeValue()
            let refPrivateGroup = FIRDatabase.database().reference().child("users").child("\((userCurrent?.uid)!)").child("privateChatId")
            refPrivateGroup.observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.value is NSNull {
                } else {
                    let data = snapshot.children
                    while let rest = data.nextObject() as? FIRDataSnapshot {
                        if friend.email == (rest.value as? NSDictionary)?["email"] as! String {
                            refPrivateGroup.child("\(rest.key)").removeValue()
                            FIRDatabase.database().reference().child("users").child("\(friend.id)").child("privateChatId").child("\(rest.key)").removeValue()
                            FIRDatabase.database().reference().child("chats").child("\(rest.key)").removeValue()
                            FIRDatabase.database().reference().child("messages").child("\(rest.key)").removeValue()
                        }
                    }
                }
                self.listFriends.remove(at: indexPath.row)
                self.tvListFriends.reloadData()
            })
        }
    }
}
