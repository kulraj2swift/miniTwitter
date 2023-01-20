//
//  User.swift
//  miniTwitter
//
//  Created by kulraj singh on 20/01/23.
//

import Foundation

struct User {
    
    struct Keys {
        static let userId = "id"
        static let name = "name"
        static let username = "username"
    }
    
    var userId: String?
    var name: String?
    var username: String?
    
    init(dict: [String: Any]) {
        userId = dict[Keys.userId] as? String
        name = dict[Keys.name] as? String
        username = dict[Keys.username] as? String
    }
}
