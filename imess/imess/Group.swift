//
//  Group.swift
//  imess
//
//  Created by Nhon Nguyen on 12/5/16.
//  Copyright © 2016 Nhon Nguyen. All rights reserved.
//

import Foundation

class Group {
    private var _id: String
    var id: String {
        get {
            return _id
        }
        set {
            _id = newValue
        }
    }
    private var _title: String
    var title: String {
        get {
            return _title
        }
        set {
            _title = newValue
        }
    }
    private var _photoUrl: String
    var photoUrl: String {
        get {
            return _photoUrl
        }
        set {
            _photoUrl = newValue
        }
    }
    private var _members: [User]
    var members: [User] {
        get {
            return _members
        }
        set {
            _members = newValue
        }
    }
    init() {
        _id = ""
        _title = ""
        _photoUrl = ""
        _members = []
    }
    init(id: String, title: String, photoUrl: String, members: [User]) {
        _id = id
        _title = title
        _photoUrl = photoUrl
        _members = members
    }
}
