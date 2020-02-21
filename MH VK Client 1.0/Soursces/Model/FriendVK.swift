//
//  Friend.swift
//  MH VK Client 1.0
//
//  Created by Vit on 16.12.2019.
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
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

//{
//"response": {
//    "count": 112,
//    "items": [
//        {
//            "id": 31147,
//            "first_name": "Вера",
//            "last_name": "Вишневая",
//            "is_closed": false,
//            "can_access_closed": true,
//            "photo_100": "https://sun1-24.userapi.com/dUKnKNPpY2eZX7PcaJEi8M4Z-IAdJRPIFKuXIg/EEX6ktE2qVs.jpg?ava=1",
//            "online": 0,
//            "track_code": "f16a979eVW5DW9pzmCTBCYukApbqVnPEMSoifD_f1uuUOu0pozc4BUptvHLMJJMMjV6ZBB40Ew"
//        },



