//
//  CellForFriendsInAddGroup.swift
//  imess
//
//  Created by Nhon Nguyen on 12/1/16.
//  Copyright © 2016 Nhon Nguyen. All rights reserved.
//

import UIKit

class CellForFriendsInGroup: UITableViewCell {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileEmail: UILabel!
    @IBOutlet weak var statusFriendInGroup: UISwitch!
    @IBAction func changedStatusSwitch(_ sender: Any) {
        settingSwitchDelegate.didChangedStatus(self, isOn: statusFriendInGroup.isOn)
    }
    
    weak var settingSwitchDelegate: SettingSwitchInCellDelegate!
    
    var dataProfileUid: String? = nil
    var dataProfilePhotoUrl: String? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

protocol SettingSwitchInCellDelegate: class {
    func didChangedStatus(_ sender: CellForFriendsInGroup, isOn: Bool)
}
