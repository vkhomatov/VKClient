//
//  Friend.swift
//  MH VK Client 1.0
//
//  Created by Vitaly Khomatov on 16.12.2019.
//  Copyright © 2019 Macrohard. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift


class FriendVK: Object, Comparable {
    
    
    static func == (lhs: FriendVK, rhs: FriendVK) -> Bool {
        return lhs.lastName == rhs.lastName
    }
    
    static func < (lhs: FriendVK, rhs: FriendVK) -> Bool {
        return lhs.lastName < rhs.lastName
    }
    
    @objc dynamic var id: Int = 0
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var mainPhoto: String = ""
    @objc dynamic var deactivated: String = ""
    var fullName: String { firstName + " " + lastName }
    
    let albums = List<FriendAlbum>()
    
    convenience init(from json: JSON) {
        self.init()
        
        self.id = json["id"].intValue
        self.firstName = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.mainPhoto = json["photo_100"].stringValue
        self.deactivated = json["deactivated"].stringValue
        
    }
    
    open var completionBlock: (() -> Void)?

    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}



