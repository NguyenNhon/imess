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

class AddFriendViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    var firebaseDatabaseReference : FIRDatabaseReference!
    var userCurrent : FIRUser!
    //let firebaseRecyclerAdapter :
    
    @IBAction func clickSearch(_ sender: Any) {
        configDatabase()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //FIRApp.configure()
        firebaseDatabaseReference = FIRDatabase.database().reference()
        
        searchTextField.leftViewMode = 	UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: searchTextField.frame.height, height: searchTextField.frame.height))
        let image = UIImage(named: "search.png")
        imageView.image = image
        searchTextField.leftView = imageView
        
        searchTextField.addTarget(self, action: #selector(AddFriendViewController.enterKeyPressed(_:)), for: .editingChanged)
        
    }
    
    func configDatabase(){
        
        //userCurrent =
//        if userCurrent == nil {
//            print("usercurrent == nil")
//            return
//        }
        let usersRef = self.firebaseDatabaseReference.child("users")
        let thisUser = usersRef.child((FIRAuth.auth()?.currentUser?.uid)!)
        //let EmailUser = thisUser.child("email")
        let friendList = thisUser.child("friends")
        //let query = thisUser.queryOrderedByKey().queryEqual(toValue: searchTextField.text, childKey: "email")
        
        friendList.observeSingleEvent(of: FIRDataEventType.value
            , with: { snapshot in
                
            if ( snapshot.value is NSNull ) {
                print("not found")
            } else {
                print("Co \(snapshot.childrenCount) users")
//                print("Co \(snapshot.children) users")
//                for child in snapshot.children {
//                    if let name = (child as? NSDictionary)?["name"] as? String {
//                        print("\(name)")
//                    }
//                }
                
                let enumerator = snapshot.children
                while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                    print("\((rest.value as? NSDictionary)?["name"])")
                }
            }
        })
    }
    
    func enterKeyPressed(_ sender: Any){
        //configDatabase()
    }
    
}
