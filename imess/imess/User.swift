//
//  User.swift
//  imess
//
//  Created by Nhon Nguyen on 11/6/16.
//  Copyright © 2016 Nhon Nguyen. All rights reserved.
//

import Foundation

class User {
    private var _name : String
    var name: String {
        get{
            return self._name
        }
        set{
            self._name = newValue
        }
    }
    private var _email: String
    var email: String {
        get {
            return self._email
        }
        set {
            self._email = newValue
        }
    }
    
    init() {
        self._name = ""
        self._email = ""
    }
    
    init(name: String, email: String) {
        self._name = name
        self._email = email
    }
}
