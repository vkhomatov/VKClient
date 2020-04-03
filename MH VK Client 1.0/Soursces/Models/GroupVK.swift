//
//  GroupVK.swift
//  MH VK Client 1.0
//
//  Created by Vitaly Khomatov on 16.12.2019.
//  Copyright © 2019 Macrohard. All rights reserved.
//

import Foundation
import SwiftyJSON

class GroupVK: Equatable {
    
    var id: Int = 0
    var name: String = ""
    var imageName: String = ""
    
    convenience init(from json: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.imageName = json["photo_100"].stringValue
        
    }
    
    static func == (lhs: GroupVK, rhs: GroupVK) -> Bool {
        return lhs.name == rhs.name && lhs.imageName == rhs.imageName
    }
    
}
