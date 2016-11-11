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
    var firebaseDatabaseReference : FIRDatabaseReference!
    var userCurrent : FIRUser!
    var listUsers : [User]!
    
    @IBOutlet weak var tvListUsers: UITableView!
    @IBAction func clickSearch(_ sender: Any) {
        self.listUsers.removeAll()
        self.tvListUsers.reloadData()
        findFriends()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        firebaseDatabaseReference = FIRDatabase.database().reference()
        listUsers = []
        searchTextField.leftViewMode = 	UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: searchTextField.frame.height, height: searchTextField.frame.height))
        let image = UIImage(named: "search.png")
        imageView.image = image
        searchTextField.leftView = imageView
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
                //print("Co \(snapshot.childrenCount) users")
                let enumerator = snapshot.children
                while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                        let idFriend = (rest.value as? NSDictionary)?["id"]! as! String
                        let nameFriend = (rest.value as? NSDictionary)?["name"]! as! String
                        let photoUrlFriend = (rest.value as? NSDictionary)?["photoUrl"]! as! String
                        let emailFriend = (rest.value as? NSDictionary)?["email"]! as! String
                        self.listUsers.append(User(name: nameFriend, email: emailFriend, id: idFriend, photoUrl: photoUrlFriend))
                    self.tvListUsers.reloadData()
                }
            }
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
        }
        return cell
    }
}
