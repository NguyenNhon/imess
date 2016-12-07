//
//  CellGroup.swift
//  imess
//
//  Created by Nhon Nguyen on 12/7/16.
//  Copyright © 2016 Nhon Nguyen. All rights reserved.
//

import UIKit

class CellGroup: UITableViewCell {
    
    @IBOutlet weak var groupPictureUserOne: UIImageView!
    @IBOutlet weak var groupPictureUserTwo: UIImageView!
    @IBOutlet weak var groupPictureUserThree: UIImageView!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupInfo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
