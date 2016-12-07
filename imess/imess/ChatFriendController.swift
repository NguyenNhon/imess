//
//  ChatFriendController.swift
//  imess
//
//  Created by Nhon Nguyen on 11/21/16.
//  Copyright © 2016 Nhon Nguyen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class ChatFriendController : UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    @IBOutlet weak var tvChat: UITableView!
    @IBOutlet weak var tfContentMessage: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewContentScroll: UIView!
    
    var groupChatId : String = ""
    var tabSendMessage : ETabBarName = .FRIEND
    var groupCurrent : Group = Group()
    var membersGroup : [User] = []
    var messages : [Message] = []
    
    //var refreshControl = UIRefreshControl()
    var countTableBeforeReload : Int = 0
    weak var activityIndicatorView : UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        tvChat.backgroundView = activityIndicatorView
        self.activityIndicatorView = activityIndicatorView
        
        initViewersInGroup()
        self.navigationController?.isNavigationBarHidden = true
        registerForKeyboardNotifications()
        self.tfContentMessage.delegate = self
        tvChat.rowHeight = UITableViewAutomaticDimension
        tvChat.estimatedRowHeight = 80.0
        self.tvChat.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        countTableBeforeReload = messages.count
        self.loadMessageFromDatabase()
        //tvChat.reloadData()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        let queue = OperationQueue()
//        queue.addOperation({
//            // do something in the background
//            self.loadMessageFromDatabase()
//            OperationQueue.main.addOperation( {
//                if self.messages.count > 0 {
//                    self.setBottomView()
//                }
//            })
//        })
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        //self.setBottomView()
        //self.showScrollOptions()
    }
    
    func showScrollOptions() {
        let sheet = UIAlertController(title: "Where to", message: "Would you like to scroll to bottom?", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Reload", style: UIAlertActionStyle.cancel, handler:{ (alert: UIAlertAction) in
            self.scrollToLastRow()
            self.dismiss(animated: true, completion: nil)
        });
        sheet.addAction(cancelAction)
        self.present(sheet, animated: true, completion: nil)
    }
    
    func scrollToLastRow() {
        let lastRowIndex = self.messages.count - 1
        let pathToLastRow = IndexPath(row: lastRowIndex, section: 0)
        self.tvChat.scrollToRow(at: pathToLastRow, at: .bottom, animated: true)
    }
    
    func initViewersInGroup() {
        //let ref = FIRDatabase.database().reference().child("chats").child("\(groupChatId)")
        FIRDatabase.database().reference().child("chats").child("\(groupChatId)").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.value is NSNull {
            } else {
                self.groupCurrent.id = self.groupChatId
                self.groupCurrent.title = snapshot.childSnapshot(forPath: "title").value as! String
                self.groupCurrent.photoUrl = snapshot.childSnapshot(forPath: "photoUrl").value as! String
            }
        })
        FIRDatabase.database().reference().child("chats").child("\(groupChatId)").child("members").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.value is NSNull {
            } else {
                let data = snapshot.children
                while let rest = data.nextObject() as? FIRDataSnapshot {
                    let email = (rest.value as? NSDictionary)?["email"] as! String
                    let id = (rest.value as? NSDictionary)?["id"] as! String
                    let name = (rest.value as? NSDictionary)?["name"] as! String
                    let photoUrl = (rest.value as? NSDictionary)?["photoUrl"] as! String
                    self.membersGroup.append(User(name: name, email: email, id: id, photoUrl: photoUrl))
                }
                self.groupCurrent.members = self.membersGroup
            }
        })
    }
    
    func setBottomView() {
        let lastSectionIndex = self.tvChat.numberOfSections - 1
        let lastRowIndex = self.tvChat.numberOfRows(inSection: lastSectionIndex) - 1
        let pathToLastRow = IndexPath(row: lastRowIndex, section: lastSectionIndex)
        self.tvChat.scrollToRow(at: pathToLastRow, at: .none, animated: true)
    }
    
    func loadMessageFromDatabase() {
        //load message of group
        let ref = FIRDatabase.database().reference().child("messages").child("\(self.groupChatId)")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.value is NSNull {
            } else {
                self.messages.removeAll()
                let messageGroup = Message()
                let data = snapshot.children
                while let rest = data.nextObject() as? FIRDataSnapshot{
                    let ownerMessage : User = User()
                    ownerMessage.id = ((rest.value as? NSDictionary)?["owner"] as? NSDictionary)?["id"] as! String
                    ownerMessage.name = ((rest.value as? NSDictionary)?["owner"] as? NSDictionary)?["name"] as! String
                    ownerMessage.email = ((rest.value as? NSDictionary)?["owner"] as? NSDictionary)?["email"] as! String
                    ownerMessage.photoUrl = ((rest.value as? NSDictionary)?["owner"] as? NSDictionary)?["photoUrl"] as! String
                    messageGroup.owner = ownerMessage
                    messageGroup.id = (rest.value as? NSDictionary)?["id"] as! String
                    messageGroup.timeSend = (rest.value as? NSDictionary)?["timeSend"] as! String
                    messageGroup.message = (rest.value as? NSDictionary)?["message"] as! String
                    
                    let viewersMessage : [User] = []
                    messageGroup.viewers = viewersMessage
                    self.messages.append(Message(newId: messageGroup.id, newMessage: messageGroup.message, newTimeSend: messageGroup.timeSend, newOwner: messageGroup.owner, newViewers: messageGroup.viewers))
                }
                if self.countTableBeforeReload != self.messages.count {
                    self.countTableBeforeReload = self.messages.count
                    self.tvChat.reloadData()
                    self.showScrollOptions()
                }
            }
        })
    }
    
    @IBAction func clickSendMessage(_ sender: Any) {
        let userCurrent = ViewController.UserCurrent
        let messageSend = Message()
        messageSend.message = self.tfContentMessage.text!
        messageSend.owner = User(name: (userCurrent?.displayName)!, email: (userCurrent?.email)!, id: (userCurrent?.uid)!, photoUrl: (userCurrent?.photoURL?.absoluteString)!)
        var ownerMessage : [String: String] = [:]
        ownerMessage["id"] = (userCurrent?.uid)!
        ownerMessage["name"] = (userCurrent?.displayName)!
        ownerMessage["email"] = (userCurrent?.email)!
        ownerMessage["photoUrl"] = (userCurrent?.photoURL?.absoluteString)!
        var viewerMessage : [String: [String: String]] = [:]
        for v in membersGroup {
            if v.email == (userCurrent?.email)! {
                continue
            }
            messageSend.viewers.append(v)
            //viewerMessage["\(v.id)"] = ["id": "\((userCurrent?.uid)!)", "name": "\((userCurrent?.displayName)!)", "email": "\((userCurrent?.email)!)", "photoUrl": "\((userCurrent?.photoURL?.absoluteString)!)"]
            viewerMessage["\(v.id)"] = ["id": "\(v.id)", "name": "\(v.name)", "email": "\(v.email)", "photoUrl": "\(v.photoUrl)"]
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        let defauftTimeZoneStr = formatter.string(from: Date())
        messageSend.timeSend = defauftTimeZoneStr
        let ref = FIRDatabase.database().reference().child("messages").child("\(self.groupChatId)").childByAutoId()
        //id, message, timeSend, owner, viewers
        ref.setValue(["id": "\(ref.key)", "message": "\((self.tfContentMessage.text)!)", "timeSend": defauftTimeZoneStr, "owner": ownerMessage, "viewers": viewerMessage])
        self.messages.append(Message(newId: messageSend.id, newMessage: messageSend.message, newTimeSend: messageSend.timeSend, newOwner: messageSend.owner, newViewers: messageSend.viewers))
        UIView.setAnimationsEnabled(false)
        self.tvChat.beginUpdates()
        self.tvChat.insertRows(at: [IndexPath(row: self.messages.count - 1, section: 0)], with: .fade)
        self.tvChat.endUpdates()
        UIView.setAnimationsEnabled(true)
        self.tvChat.layoutIfNeeded()
        self.setBottomView()
        self.tfContentMessage.text = ""
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            var membersTemp : [String : [String : String]] = [:]
            for u in self.membersGroup {
                membersTemp["\(u.id)"] = ["id": "\(u.id)", "name": "\(u.name)", "email": "\(u.email)", "photoUrl": "\(u.photoUrl)"]
            }
            for v in self.membersGroup {
                FIRDatabase.database().reference().child("recent").child("\(v.id)").child("\(self.groupChatId)").setValue(["id": "\(self.groupChatId)", "title": "\(self.groupCurrent.title)", "photoUrl": "\(self.groupCurrent.photoUrl)", "timeSend": "\(defauftTimeZoneStr)", "members": membersTemp])
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height + 10){
            loadMessageFromDatabase()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        deregisterFromKeyboardNotifications()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueBackMessage" {
            let vc = segue.destination as! HomeViewController
            vc.initTabBar = tabSendMessage
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //todoIfNeed: get list viewer in here
        if indexPath.row < self.messages.count && self.messages[indexPath.row].owner.email != (ViewController.UserCurrent.email)! {
            let cell = self.tvChat.dequeueReusableCell(withIdentifier: "LeftCellChat") as! LeftCellChat
            if  self.messages.count > indexPath.row {
                cell.profileName.text = messages[indexPath.row].owner.name
                cell.message.text = messages[indexPath.row].message
                cell.message.layer.masksToBounds = true
                cell.viewMesage.layer.cornerRadius = 20.0
                let urlPhoto = NSURL(string: self.messages[indexPath.row].owner.photoUrl)
                if let dataPhoto = NSData(contentsOf: urlPhoto as! URL) {
                    cell.profilePicture.image = UIImage(data: dataPhoto as Data)
                    cell.profilePicture.layer.masksToBounds = true
                    cell.profilePicture.layer.cornerRadius = 20.0
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
    
    var isKeyboardUp : Bool = false
    
    //keyboard
    func registerForKeyboardNotifications()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(ChatFriendController.keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatFriendController.keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    func deregisterFromKeyboardNotifications()
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification){
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        if isKeyboardUp == false {
            moveView(textField: tfContentMessage, moveDistance: -(keyboardSize!.height), up: true)
            isKeyboardUp = true
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        if isKeyboardUp == true {
            moveView(textField: tfContentMessage, moveDistance: -(keyboardSize!.height), up: false)
            isKeyboardUp = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        tfContentMessage = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        //tfContentMessage = nil
    }
    //keyboard
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            touch.view?.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
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
        self.viewContentScroll.frame = self.viewContentScroll.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
}
