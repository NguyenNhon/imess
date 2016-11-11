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
    private var _id : String
    var id: String {
        get{
            return self._id
        }
        set{
            self._id = newValue
        }
    }
    private var _photoUrl : String
    var photoUrl: String {
        get{
            return self._photoUrl
        }
        set{
            self._photoUrl = newValue
        }
    }
    init() {
        self._name = ""
        self._email = ""
        self._id = ""
        self._photoUrl = ""
    }
    
    init(name: String, email: String, id: String, photoUrl: String) {
        self._name = name
        self._email = email
        self._id = id
        self._photoUrl = photoUrl
    }
}
