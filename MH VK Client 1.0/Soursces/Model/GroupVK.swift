//
//  GroupVK.swift
//  MH VK Client 1.0
//
//  Created by Vit on 16.12.2019.
//  Copyright © 2019 Macrohard. All rights reserved.
//

import Foundation
import SwiftyJSON

class GroupVK: Equatable {
    
    let id: Int
    let name: String
    let imageName: String
    
    init(from json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.imageName = json["photo_100"].stringValue
    }
    
    static func == (lhs: GroupVK, rhs: GroupVK) -> Bool {
        return lhs.name == rhs.name && lhs.imageName == rhs.imageName
    }
    
}

//{
//"response": {
//    "count": 51,
//    "items": [
//        {
//            "id": 36485711,
//            "name": "Stereokiss",
//            "screen_name": "thestereokiss",
//            "is_closed": 0,
//            "type": "group",
//            "is_admin": 0,
//            "is_member": 1,
//            "is_advertiser": 0,
//            "photo_50": "https://sun9-67.userapi.com/c638831/v638831954/10649/OFa3NnLw4wA.jpg?ava=1",
//            "photo_100": "https://sun9-15.userapi.com/c638831/v638831954/10648/w4pobRqry-8.jpg?ava=1",
//            "photo_200": "https://sun9-63.userapi.com/c638831/v638831954/10647/XxxsOekBl1M.jpg?ava=1"
//        },
