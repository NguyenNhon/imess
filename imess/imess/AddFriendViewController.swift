//
//  Filea.swift
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

class AddFriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tvListUsers: UITableView!
    weak var activityIndicatorView: UIActivityIndicatorView!
    var firebaseDatabaseReference : FIRDatabaseReference!
    var listUsers : [User]!
    var listOldFriends : [User]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        tvListUsers.backgroundView = activityIndicatorView
        self.activityIndicatorView = activityIndicatorView
        
        self.navigationController?.isNavigationBarHidden = true
        firebaseDatabaseReference = FIRDatabase.database().reference()
        listUsers = []
        listOldFriends = []
        searchTextField.leftViewMode = 	UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: searchTextField.frame.height, height: searchTextField.frame.height))
        let image = UIImage(named: "search.png")
        imageView.image = image
        searchTextField.leftView = imageView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.activityIndicatorView.startAnimating()
        findOldFriends()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueDoneAddFriend" {
            let homeView = segue.destination as! HomeViewController
            homeView.initTabBar = .FRIEND
        }
    }
    
    @IBAction func clickSearch(_ sender: Any) {
        self.activityIndicatorView.startAnimating()
        self.listUsers.removeAll()
        findFriends()
    }
    
    func findOldFriends() {
        //var oldFriends : [User] = []
        self.firebaseDatabaseReference.child("users").child("\((FIRAuth.auth()?.currentUser?.uid)!)").child("friends").observeSingleEvent(of: .value, with: {
            (snapshot) in
            //print("\(snapshot.children.nextObject())")
            if snapshot.value is NSNull {
                print("Not found")
            } else {
                if snapshot.exists() {
                    let enumerator = snapshot.children
                    self.listOldFriends.removeAll()
                    while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                        let idFriend = (rest.value as? NSDictionary)?["id"]! as! String
                        let nameFriend = (rest.value as? NSDictionary)?["name"]! as! String
                        let photoUrlFriend = (rest.value as? NSDictionary)?["photoUrl"]! as! String
                        let emailFriend = (rest.value as? NSDictionary)?["email"]! as! String
                        self.listOldFriends.append(User(name: nameFriend, email: emailFriend, id: idFriend, photoUrl: photoUrlFriend))
                    }
                }
            }
            self.activityIndicatorView.stopAnimating()
        })
    }
    
    func findFriends(){
        let usersRef = self.firebaseDatabaseReference.child("users")
        guard let emailAddFriend = self.searchTextField.text else {
            print("Text field must be enter.")
            return
        }
        let users = usersRef.queryOrdered(byChild: "email").queryStarting(atValue: emailAddFriend)
        users.observeSingleEvent(of: FIRDataEventType.value
            , with: { snapshot in
                
            if ( snapshot.value is NSNull ) {
                print("not found")
            } else {
                let enumerator = snapshot.children
                self.listUsers.removeAll()
                while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                    let emailFriend = (rest.value as? NSDictionary)?["email"]! as! String
                    if emailFriend == (ViewController.UserCurrent.email)! || self.listOldFriends.contains(where: { (user) -> Bool in
                        return emailFriend == user.email
                    }) {
                        continue
                    }
                    let idFriend = (rest.value as? NSDictionary)?["id"]! as! String
                    let nameFriend = (rest.value as? NSDictionary)?["name"]! as! String
                    let photoUrlFriend = (rest.value as? NSDictionary)?["photoUrl"]! as! String
                    self.listUsers.append(User(name: nameFriend, email: emailFriend, id: idFriend, photoUrl: photoUrlFriend))
                }
                self.tvListUsers.reloadData()
            }
            self.activityIndicatorView.stopAnimating()
        })
    }
    var tempImg : UIImage!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tvListUsers.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! CustomTableViewCell
        if self.listUsers.count > indexPath.row {
            let urlPhoto = NSURL(string: self.listUsers[indexPath.row].photoUrl)
            if let dataPhoto = NSData(contentsOf: urlPhoto as! URL) {
                cell.profilePicture.image = UIImage(data: dataPhoto as Data)
            }
            cell.profileName.text = self.listUsers[indexPath.row].name
            cell.profileEmail.text = self.listUsers[indexPath.row].email
            
            cell.dataProfileUid = self.listUsers[indexPath.row].id
            cell.dataProfilePhotoUrl = self.listUsers[indexPath.row].photoUrl
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.activityIndicatorView.isAnimating {
            return
        }
        self.activityIndicatorView.startAnimating()
        let cell = self.tvListUsers.cellForRow(at: indexPath) as! CustomTableViewCell
        let userCurrent = ViewController.UserCurrent
        let uidCurrent = userCurrent?.uid
        let uidFriend = cell.dataProfileUid
        let refDatatase = FIRDatabase.database().reference().child("users").child("\(uidCurrent!)").child("friends").child("\(uidFriend!)")
        refDatatase.observeSingleEvent(of: FIRDataEventType.value
            , with: { snapshot in
                if ( snapshot.value is NSNull ) {
                    refDatatase.setValue(["id": uidFriend!,"name": cell.profileName.text!, "email": cell.profileEmail.text!, "photoUrl": cell.dataProfilePhotoUrl!])
                    
                    //friends
                    let refDatabaseFri = FIRDatabase.database().reference().child("users").child("\(uidFriend!)").child("friends").child("\(uidCurrent!)")
                    refDatabaseFri.observeSingleEvent(of: FIRDataEventType.value
                        , with: { snapshot in
                            if ( snapshot.value is NSNull ) {
                                refDatabaseFri.setValue(["id": uidCurrent!,"name": (userCurrent?.displayName)!, "email": (userCurrent?.email)!, "photoUrl": (userCurrent?.photoURL?.absoluteString)!])
                                cell.removeFromSuperview()
                                self.listUsers.remove(at: indexPath.row)
                                tableView.reloadData()
                                self.activityIndicatorView.stopAnimating()
                            }
                    })
                }
        })
    }
}
