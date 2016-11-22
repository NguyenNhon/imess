//
//  Label.swift
//  imess
//
//  Created by Nhon Nguyen on 11/22/16.
//  Copyright © 2016 Nhon Nguyen. All rights reserved.
//

import UIKit

class Label: UILabel {
    override func draw(_ rect: CGRect) {
        self.setNeedsLayout()
        return super.draw(UIEdgeInsetsInsetRect(rect, UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)))
    }
}
