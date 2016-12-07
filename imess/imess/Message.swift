//
//  Message.swift
//  imess
//
//  Created by Nhon Nguyen on 11/22/16.
//  Copyright © 2016 Nhon Nguyen. All rights reserved.
//

import Foundation

class Message {
    private var _id : String
    private var _message : String
    private var _timeSend : String
    private var _owner : User
    private var _viewers : [User]
    var id : String {
        get {
            return _id
        }
        set {
            _id = newValue
        }
    }
    var message : String {
        get {
            return _message
        }
        set {
            _message = newValue
        }
    }
    var timeSend : String {
        get {
            return _timeSend
        }
        set {
            _timeSend = newValue
        }
    }
    var owner : User {
        get {
            return _owner
        }
        set {
            _owner = newValue
        }
    }
    var viewers : [User] {
        get {
            return _viewers
        }
        set {
            _viewers = newValue
        }
    }
    
    init() {
        _id = ""
        _message = ""
        _timeSend = ""
        _owner = User()
        _viewers = []
    }
    
    init(newId : String, newMessage : String, newTimeSend : String, newOwner : User, newViewers : [User]) {
        _id = newId
        _message = newMessage
        _timeSend = newTimeSend
        _owner = newOwner
        _viewers = newViewers
    }
}
