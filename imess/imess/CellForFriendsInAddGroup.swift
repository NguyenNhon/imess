//
//  CellForAddFriendInGroup.swift
//  imess
//
//  Created by Nhon Nguyen on 11/29/16.
//  Copyright © 2016 Nhon Nguyen. All rights reserved.
//

import UIKit
class CellForAddFriendInGroup: UITableViewCell {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileEmail: UILabel!
    @IBOutlet weak var statusInGroup: UISwitch!
    
    weak var settingCell: SettingCellDelegate?
    
    @IBAction func changedStatus(_ sender: Any) {
        self.settingCell?.didChangeStatusSwitch(sender: self, isOn: statusInGroup.isOn)
    }
    
    
    var dataProfileUid: String? = nil
    
    var dataProfilePhotoUrl: String? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}


protocol SettingCellDelegate: class {
    func didChangeStatusSwitch(sender: CellForAddFriendInGroup, isOn: Bool)
}
