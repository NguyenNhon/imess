//
//  CustomTableViewCell.swift
//  imess
//
//  Created by Nhon Nguyen on 11/10/16.
//  Copyright © 2016 Nhon Nguyen. All rights reserved.
//

import UIKit
import OneSignal
import Firebase
import FirebaseDatabase

class CustomCellFriend : UITableViewCell {
    
//    @IBOutlet weak var profilePicture: UIImageView!
//    
//    @IBOutlet weak var profileName: UILabel!
//    
//    @IBOutlet weak var profileEmail: UILabel!
    
    var dataProfileUid: String? = nil
    
    var dataProfilePhotoUrl: String? = nil
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var profileEmail: UILabel!
    
    @IBOutlet weak var profileName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
