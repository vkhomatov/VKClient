//
//  NewsPostVK.swift
//  MH VK Client 1.0
//
//  Created by Vitaly Khomatov on 25.02.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import SwiftyJSON

class NewsItemVK {
    
    var source_id: Int = 0
    var type: String = ""
    var date: Double = 0
    var post_type: String = ""
    var copy_owner_id: Int = 0
    var copy_post_id: Int = 0
    
    var text: String = ""
    var likesCount: Int = 0
    var likeUser: Int = 0
    var reposts: Int = 0
    var comments: Int = 0
    var views: Int = 0
    
    var attachments : [Attachment]?
    var photos: [attachPhoto] = []
    
    convenience init(from json: JSON) {
        self.init()
        
        self.source_id = json["source_id"].intValue
        self.type = json["type"].stringValue
        self.date = json["date"].doubleValue
        self.post_type = json["post_type"].stringValue
        self.copy_owner_id = json["copy_owner_id"].intValue
        self.copy_post_id = json["copy_post_id"].intValue
        
        self.text = json["text"].stringValue
        self.likesCount = json["likes"]["count"].intValue
        self.likeUser = json["likes"]["user_likes"].intValue
        self.reposts = json["reposts"]["count"].intValue
        self.comments = json["comments"]["count"].intValue
        self.views = json["views"]["count"].intValue
        
        let attachmentsJSONs = json["attachments"].arrayValue
        self.attachments = attachmentsJSONs.map { Attachment(from: $0) }
        
        let wallphotosJSONs = json["photos"]["items"].arrayValue
        self.photos = wallphotosJSONs.map { attachPhoto(from: $0) }
        
//        print("post_type: \(post_type)")
//        print("copy_owner_id: \(copy_owner_id)")
//        print("copy_post_id: \(copy_post_id)")

        
    }
    
}

