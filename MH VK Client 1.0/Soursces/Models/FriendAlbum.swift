//
//  FriendAlbum.swift
//  MH VK Client 1.0
//
//  Created by Vitaly Khomatov on 13.01.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class FriendAlbum: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var idRealm: Int = 0
    @objc dynamic var ownerId: Int = 0
    @objc dynamic var coverPhoto: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var photosCount: Int = 0
    
    let photos = List<FriendPhoto>()
    
    convenience init(from json: JSON) {
        self.init()

        self.id = json["id"].intValue
        self.ownerId = json["owner_id"].intValue
        self.coverPhoto = json["thumb_src"].stringValue
        self.title = json["title"].stringValue
        self.photosCount = json["size"].intValue
        self.idRealm = json["id"].intValue
        
//        if let sizes = json["sizes"].array?
//                   .filter({ ["w", "z", "y", "x", "m"].contains($0["type"]) })
//                   .sorted(by: { $0["type"] > $1["type"] }),
//                   let photoUrlString = sizes.first?["src"].string {
//                   self.coverPhoto = photoUrlString
//               }
//        print("self.coverPhoto = \(self.coverPhoto)")


        if self.id < 0  {
            self.idRealm += self.ownerId
        }
    }
    
    override static func primaryKey() -> String? {
        return "idRealm"
    }
    
    
} 
