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
    
    @IBOutlet weak var tvListFriends: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        actionButton = ActionButton(attachedToView: self.view)
        actionButton.action = { button in button.toggleMenu() }
        actionButton.setTitle("+", forState: UIControlState())
        actionButton.backgroundColor = UIColor(red: 238.0/255.0, green: 130.0/255.0, blue: 34.0/255.0, alpha:1.0)
        actionButton.getButton().addTarget(self, action: #selector(FriendViewController.buttonTouchDown(_:)), for: .touchDown)
        initListFriends()
        self.tvListFriends.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func initListFriends() {
        FIRDatabase.database().reference().child("users").child("\((FIRAuth.auth()?.currentUser?.uid)!)").child("friends").observeSingleEvent(of: .value, with: {
            (snapshot) in
            //print("\(snapshot.children.nextObject())")
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
                        //print("\(self.listFriends.count)")
                    }
                    self.tvListFriends.reloadData()
                }
            }
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
            }
            cell?.profileName.text = self.listFriends[indexPath.row].name
            cell?.profileEmail.text = self.listFriends[indexPath.row].email
            
            cell?.dataProfileUid = self.listFriends[indexPath.row].id
            cell?.dataProfilePhotoUrl = self.listFriends[indexPath.row].photoUrl
        }
        return (cell!)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatFriendVC = self.storyboard?.instantiateViewController(withIdentifier: "chatFriend")
        self.navigationController?.pushViewController(chatFriendVC!, animated: true)
    }
}
