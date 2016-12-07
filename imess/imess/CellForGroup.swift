//
//  CellForGroup.swift
//  imess
//
//  Created by Nhon Nguyen on 12/5/16.
//  Copyright © 2016 Nhon Nguyen. All rights reserved.
//

import UIKit

class CellForGroup: UITableViewCell {
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupInfo: UILabel!
    @IBOutlet weak var groupPictureUserOne: UIImageView!
    @IBOutlet weak var groupPictureUserTwo: UIImageView!
    @IBOutlet weak var groupPictureUserThree: UIImageView!
    @IBOutlet weak var groupViewOfPicture: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
