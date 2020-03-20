//
//  NewsAttachmentVK.swift
//  MH VK Client 1.0
//
//  Created by Vitaly Khomatov on 26.02.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import Foundation
import SwiftyJSON


class Attachment {
    
    var typeStr : String = ""
    var photoObj : attachPhoto?
    var linkObj : attachLink?
    
    convenience init(from json: JSON) {
        self.init()
        
        self.typeStr = json["type"].stringValue
        
        switch typeStr {
            
        case "photo":
            self.photoObj = attachPhoto(from: json[typeStr])
            
        case "link":
            self.linkObj = attachLink(from: json[typeStr])
            
        default:
            self.linkObj = nil
            self.photoObj = nil
            
        }
        
    }
    
}


// MARK: - Photo
class attachPhoto {
    
    var id : Int = 0
    var album_id : Int = 0
    var user_id : Int = 0
    
    var height : Int = 0
    var widht : Int = 0
    
    var imageCellURLString: String = ""
    var imageFullURLString: String = ""
    
    var likesCount: Int = 0
    var likeUser: Int = 0
    var reposts: Int = 0
    var comments: Int = 0
    var views: Int = 0
    
    convenience init(from json: JSON) {
        self.init()
        
        self.id = json["id"].intValue
        self.album_id = json["album_id"].intValue
        self.user_id = json["user_id"].intValue
        
        self.height = json["height"].intValue
        self.widht = json["widht"].intValue
        
        self.likesCount = json["likes"]["count"].intValue
        self.likeUser = json["likes"]["user_likes"].intValue
        self.reposts = json["reposts"]["count"].intValue
        self.comments = json["comments"]["count"].intValue
        self.views = json["views"]["count"].intValue
        
        
        
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
    
    
}

// MARK: - Link
class attachLink {
    
    var url : String = ""
    var title : String = ""
    var caption : String?
    var description : String = ""
    var photo : attachPhoto?
    
    convenience init(from json: JSON) {
        self.init()
        
        self.url = json["url"].stringValue
        self.title = json["title"].stringValue
        self.caption = json["caption"].stringValue
        self.description = json["description"].stringValue
        
        self.photo = attachPhoto(from: json["photo"])
        
    }
    
}
