//
//  ChatFriendController.swift
//  imess
//
//  Created by Nhon Nguyen on 11/21/16.
//  Copyright © 2016 Nhon Nguyen. All rights reserved.
//

import UIKit

class ChatFriendController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tvChat: UITableView!
    
    @IBOutlet weak var tfContentMessage: UITextField!
    
    var messages : [Message] = [Message(newId: "1", newMessage: "Message 1: noi dung message nay la de test cho message 1 1 message co do dai kha dai de coi su co dan cua view message ntn ahihi noi dung message nay la de test cho message 1 1 message co do dai kha dai de coi su co dan cua view message ntn ahihi noi dung message nay la de test cho message 1 1 message co do dai kha dai de coi su co dan cua view message ntn ahihi noi dung message nay la de test cho message 1 1 message co do dai kha dai de coi su co dan cua view message ntn ahihi", newTimeSend: NSDate(), newOwner: User(name: "Owner message 1", email: "1@gmail.com", id: "id owner 1", photoUrl: "https://lh6.googleusercontent.com/-2yFMxbAwgvo/AAAAAAAAAAI/AAAAAAAAAEg/X6vBUfnFpqk/s96-c/photo.jpg"), newViewers: [User(name: "user view 1", email: "email view 1", id: "id view 1", photoUrl: "https://lh6.googleusercontent.com/-XNHumyZMMig/AAAAAAAAAAI/AAAAAAAAABA/6FJC_qodfQc/s96-c/photo.jpg"), User(name: "user view 2", email: "email view 2", id: "id view 2", photoUrl: "https://lh6.googleusercontent.com/-2yFMxbAwgvo/AAAAAAAAAAI/AAAAAAAAAEg/X6vBUfnFpqk/s96-c/photo.jpg")]),
                                Message(newId: "2", newMessage: "Message 2: noi dung message nay la de test cho message 1 1 message co do dai kha dai de coi su co dan cua view message ntn ahihi aaaaaaaaaaaa aaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaaaaaaaa aaaaaaaa aaaaaaaaaaaaa aaaaaaaaaaaaaaa aaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaa aaaaaa", newTimeSend: NSDate(), newOwner: User(name: "owner 2", email: "email owner 2", id: "id owner 2", photoUrl: "https://lh6.googleusercontent.com/-2yFMxbAwgvo/AAAAAAAAAAI/AAAAAAAAAEg/X6vBUfnFpqk/s96-c/photo.jpg"), newViewers: [User(name: "viewer 2", email: "2@gmail.com", id: "id viewer 2", photoUrl: "https://lh6.googleusercontent.com/-2yFMxbAwgvo/AAAAAAAAAAI/AAAAAAAAAEg/X6vBUfnFpqk/s96-c/photo.jpg")]),
                                Message(newId: "2", newMessage: "Message 2: noi dung message nay la de test cho message 1 1 message co do dai kha dai de coi su co dan cua view message ntn ahihi bbbbbbbbbb bbbbbbbbbbbbb bbbbbbbbbbbbbbb bbbbbbbbbbbb bbbbbbbbbbbbb bbbbbbbbbbbb bbbbbbbbbbbbbbbb bbbbbbbbbbbbbbb bbbbbbbbb", newTimeSend: NSDate(), newOwner: User(name: "owner 2", email: "email owner 2", id: "id owner 2", photoUrl: "https://lh6.googleusercontent.com/-2yFMxbAwgvo/AAAAAAAAAAI/AAAAAAAAAEg/X6vBUfnFpqk/s96-c/photo.jpg"), newViewers: [User(name: "viewer 2", email: "2@gmail.com", id: "id viewer 2", photoUrl: "https://lh6.googleusercontent.com/-2yFMxbAwgvo/-XNHumyZMMig/AAAAAAAAAAI/AAAAAAAAABA/6FJC_qodfQc/s96-c/photo.jpg")]),
                                Message(newId: "2", newMessage: "Message 2: noi dung message nay la de test cho message 1 1 message co do dai kha dai de coi su co dan cua view message ntn ahihi cccccccccccc ccccccccccccccc cccccccccccccc ccccccccccccccccc cccccccccccccc", newTimeSend: NSDate(), newOwner: User(name: "owner 2", email: "email owner 2", id: "id owner 2", photoUrl: "https://lh6.googleusercontent.com/-2yFMxbAwgvo/AAAAAAAAAAI/AAAAAAAAAEg/X6vBUfnFpqk/s96-c/photo.jpg"), newViewers: [User(name: "viewer 2", email: "2@gmail.com", id: "id viewer 2", photoUrl: "https://lh6.googleusercontent.com/-2yFMxbAwgvo/-XNHumyZMMig/AAAAAAAAAAI/AAAAAAAAABA/6FJC_qodfQc/s96-c/photo.jpg")])]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(messages.count)")
        tvChat.estimatedRowHeight = 100.0
        tvChat.rowHeight = UITableViewAutomaticDimension
        tvChat.reloadData()
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
                //cell.message.layer.cornerRadius = 10.0
//                cell.message.drawText(in: UIEdgeInsetsInsetRect(cell.message.layer.frame, UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)))
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
            //print("\(messages[indexPath.row].message)")
            cell.message.text = messages[indexPath.row].message
            cell.message.layer.masksToBounds = true
            cell.viewMessage.layer.cornerRadius = 20.0
            //cell.message.layer.cornerRadius = 20.0
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

//internal extension UILabel {
//    override internal func draw(_ rect: CGRect) {
//        let insets = UIEdgeInsets.init(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
//        super.draw(UIEdgeInsetsInsetRect(rect, insets))
//    }
//}
