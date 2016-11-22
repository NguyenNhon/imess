//
//  LeftCellChat.swift
//  imess
//
//  Created by Nhon Nguyen on 11/22/16.
//  Copyright © 2016 Nhon Nguyen. All rights reserved.
//

import UIKit

class LeftCellChat: UITableViewCell {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var message: Label!
    @IBOutlet weak var viewMesage: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
