//
//  FriendPhoto.swift
//  MH VK Client 1.0
//
//  Created by Vit on 16.12.2019.
//  Copyright © 2019 Macrohard. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift


class FriendPhoto: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var albumId: Int = 0
    @objc dynamic var ownerId: Int = 0
    @objc dynamic var likesCount: Int = 0
    @objc dynamic var likeUser: Int = 0
    @objc dynamic var imageCellURLString: String = ""
    @objc dynamic var imageFullURLString: String = ""
    
    convenience init(from json: JSON) {
        self.init()
        
        self.id = json["id"].intValue
        self.albumId = json["album_id"].intValue
        self.ownerId = json["owner_id"].intValue
        //self.likesCount = json["likes"].intValue
        self.likesCount = json["likes"]["count"].intValue
        self.likeUser = json["likes"]["user_likes"].intValue
        
        guard let imageSize = json["sizes"].array?.first(where: { $0["type"] == "s" }) else { return }
        self.imageCellURLString = imageSize["url"].stringValue
        
        if let imageCellURLString = json["sizes"].array?.first(where: { $0["type"] == "m" })?["url"].string {
            self.imageCellURLString = imageCellURLString
        }
        
        self.imageFullURLString = self.imageCellURLString
        
        if let sizes = json["sizes"].array?
            .filter({ ["w", "z", "y", "x", "m"].contains($0["type"]) })
            .sorted(by: { $0["width"].intValue * $0["height"].intValue > $1["width"].intValue * $1["height"].intValue }),
            let photoUrlString = sizes.first?["url"].string {
            self.imageFullURLString = photoUrlString
        }
        
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
