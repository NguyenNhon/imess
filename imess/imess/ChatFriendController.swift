//
//  ChatFriendController.swift
//  imess
//
//  Created by Nhon Nguyen on 11/21/16.
//  Copyright © 2016 Nhon Nguyen. All rights reserved.
//

import UIKit

class ChatFriendController : UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    @IBOutlet weak var tvChat: UITableView!
    
    @IBOutlet weak var tfContentMessage: UITextField!

    var isKeyboardUp : Bool = false
    
    func touchUpInsideTextView(_ sender: Any) {
        
        //NSLayoutConstraint(item: tfContentMessage, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottomMargin, multiplier: 1.0, constant: 324.0).isActive = true
    }
    @IBOutlet weak var scrollView: UIScrollView!

    //keyboard
    func registerForKeyboardNotifications()
    {
        //Adding notifies on keyboard appearing
//        NotificationCenter.default.addObserver(self, selector: #selector(ChatFriendController.keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatFriendController.keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatFriendController.keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    func deregisterFromKeyboardNotifications()
    {
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification)
    {
        //Need to calculate keyboard exact size due to Apple suggestions
        //self.scrollView.isScrollEnabled = true
        
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        if isKeyboardUp == false {
            moveView(textField: tfContentMessage, moveDistance: -keyboardSize!.height, up: true)
            isKeyboardUp = true
        }
        //self.scrollView.isScrollEnabled = false
        //print("height: \(keyboardSize!.height)")
        //let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
//        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0,  keyboardSize!.height, 0.0)
//        
//        self.scrollView.contentInset = contentInsets
//        self.scrollView.scrollIndicatorInsets = contentInsets
//        
//        var aRect : CGRect = self.view.frame
//        aRect.size.height -= keyboardSize!.height
//        if tfContentMessage != nil {
//            if (!aRect.contains(tfContentMessage!.frame.origin)) {
//                self.scrollView.scrollRectToVisible(tfContentMessage!.frame, animated: true)
//            }
//        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification)
    {
        //Once keyboard disappears, restore original positions
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        if isKeyboardUp == true {
            moveView(textField: tfContentMessage, moveDistance: -keyboardSize!.height, up: false)
            isKeyboardUp = false
        }
        
//        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
//        self.scrollView.contentInset = contentInsets
//        self.scrollView.scrollIndicatorInsets = contentInsets
//        self.view.endEditing(true)
//        self.scrollView.isScrollEnabled = false
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        tfContentMessage = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        //tfContentMessage = nil
    }
    //keyboard
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func moveView(textField: UITextField, moveDistance: CGFloat, up: Bool) {
        var moveDuration = 0.3
        if isKeyboardUp {
            moveDuration = 0.1
        } else {
            moveDuration = 0.4
        }
        
        let movement : CGFloat = CGFloat( up ? moveDistance : -moveDistance)
        UIView.beginAnimations("animatedTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    var messages : [Message] = [Message(newId: "1", newMessage: "Message 1: noi dung message nay la de test cho message 1 1 message co do dai kha dai de coi su co dan cua view message ntn ahihi noi dung message nay la de test cho message 1 1 message co do dai kha dai de coi su co dan cua view message ntn ahihi noi dung message nay la de test cho message 1 1 message co do dai kha dai de coi su co dan cua view message ntn ahihi noi dung message nay la de test cho message 1 1 message co do dai kha dai de coi su co dan cua view message ntn ahihi", newTimeSend: NSDate(), newOwner: User(name: "Owner message 1", email: "1@gmail.com", id: "id owner 1", photoUrl: "https://lh6.googleusercontent.com/-2yFMxbAwgvo/AAAAAAAAAAI/AAAAAAAAAEg/X6vBUfnFpqk/s96-c/photo.jpg"), newViewers: [User(name: "user view 1", email: "email view 1", id: "id view 1", photoUrl: "https://lh6.googleusercontent.com/-XNHumyZMMig/AAAAAAAAAAI/AAAAAAAAABA/6FJC_qodfQc/s96-c/photo.jpg"), User(name: "user view 2", email: "email view 2", id: "id view 2", photoUrl: "https://lh6.googleusercontent.com/-2yFMxbAwgvo/AAAAAAAAAAI/AAAAAAAAAEg/X6vBUfnFpqk/s96-c/photo.jpg")]),
                                Message(newId: "2", newMessage: "Message 2: noi dung message nay la de test cho message 1 1 message co do dai kha dai de coi su co dan cua view message ntn ahihi aaaaaaaaaaaa aaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaaaaaaaa aaaaaaaa aaaaaaaaaaaaa aaaaaaaaaaaaaaa aaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaa aaaaaa", newTimeSend: NSDate(), newOwner: User(name: "owner 2", email: "email owner 2", id: "id owner 2", photoUrl: "https://lh6.googleusercontent.com/-2yFMxbAwgvo/AAAAAAAAAAI/AAAAAAAAAEg/X6vBUfnFpqk/s96-c/photo.jpg"), newViewers: [User(name: "viewer 2", email: "2@gmail.com", id: "id viewer 2", photoUrl: "https://lh6.googleusercontent.com/-2yFMxbAwgvo/AAAAAAAAAAI/AAAAAAAAAEg/X6vBUfnFpqk/s96-c/photo.jpg")]),
                                Message(newId: "2", newMessage: "Message 2: noi dung message nay la de test cho message 1 1 message co do dai kha dai de coi su co dan cua view message ntn ahihi bbbbbbbbbb bbbbbbbbbbbbb bbbbbbbbbbbbbbb bbbbbbbbbbbb bbbbbbbbbbbbb bbbbbbbbbbbb bbbbbbbbbbbbbbbb bbbbbbbbbbbbbbb bbbbbbbbb", newTimeSend: NSDate(), newOwner: User(name: "owner 2", email: "email owner 2", id: "id owner 2", photoUrl: "https://lh6.googleusercontent.com/-2yFMxbAwgvo/AAAAAAAAAAI/AAAAAAAAAEg/X6vBUfnFpqk/s96-c/photo.jpg"), newViewers: [User(name: "viewer 2", email: "2@gmail.com", id: "id viewer 2", photoUrl: "https://lh6.googleusercontent.com/-2yFMxbAwgvo/-XNHumyZMMig/AAAAAAAAAAI/AAAAAAAAABA/6FJC_qodfQc/s96-c/photo.jpg")]),
                                Message(newId: "2", newMessage: "Message 2: noi dung message nay la de test cho message 1 1 message co do dai kha dai de coi su co dan cua view message ntn ahihi cccccccccccc ccccccccccccccc cccccccccccccc ccccccccccccccccc cccccccccccccc", newTimeSend: NSDate(), newOwner: User(name: "owner 2", email: "email owner 2", id: "id owner 2", photoUrl: "https://lh6.googleusercontent.com/-2yFMxbAwgvo/AAAAAAAAAAI/AAAAAAAAAEg/X6vBUfnFpqk/s96-c/photo.jpg"), newViewers: [User(name: "viewer 2", email: "2@gmail.com", id: "id viewer 2", photoUrl: "https://lh6.googleusercontent.com/-2yFMxbAwgvo/-XNHumyZMMig/AAAAAAAAAAI/AAAAAAAAABA/6FJC_qodfQc/s96-c/photo.jpg")])]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyboardNotifications()
        self.tfContentMessage.delegate = self
        self.tvChat.delegate = self
        print("\(messages.count)")
        tvChat.estimatedRowHeight = 100.0
        tvChat.rowHeight = UITableViewAutomaticDimension
        tvChat.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        deregisterFromKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            let cell = self.tvChat.dequeueReusableCell(withIdentifier: "LeftCellChat") as! LeftCellChat
            if  self.messages.count > indexPath.row {
                cell.profileName.text = messages[indexPath.row].owner.name
                cell.message.text = messages[indexPath.row].message
                cell.message.layer.masksToBounds = true
                cell.viewMesage.layer.cornerRadius = 20.0
                let urlPhoto = NSURL(string: self.messages[indexPath.row].owner.photoUrl)
                if let dataPhoto = NSData(contentsOf: urlPhoto as! URL) {
                    cell.profilePicture.image = UIImage(data: dataPhoto as Data)
                }
            }
            return cell
        }
        let cell = self.tvChat.dequeueReusableCell(withIdentifier: "RightCellChat") as! RightCellChat
        if  self.messages.count > indexPath.row{
            cell.message.text = messages[indexPath.row].message
            cell.message.layer.masksToBounds = true
            cell.viewMessage.layer.cornerRadius = 20.0
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
