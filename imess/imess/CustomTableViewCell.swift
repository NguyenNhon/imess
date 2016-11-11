//
//  CustomTableViewCell.swift
//  imess
//
//  Created by Nhon Nguyen on 11/10/16.
//  Copyright © 2016 Nhon Nguyen. All rights reserved.
//

import UIKit

class CustomTableViewCell : UITableViewCell {
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var profileName: UILabel!
    
    @IBOutlet weak var profileEmail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        print(self.profileEmail.text!)
    }
}
