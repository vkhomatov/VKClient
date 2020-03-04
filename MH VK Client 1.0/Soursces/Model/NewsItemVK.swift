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
    
    var text: String = ""
    var likesCount: Int = 0
    var likeUser: Int = 0
    var reposts: Int = 0
    var comments: Int = 0
    var views: Int = 0
    
    
    var attachments : [Attachment]?
    
    
    convenience init(from json: JSON) {
        self.init()
        
        self.source_id = json["source_id"].intValue
        self.type = json["type"].stringValue
        self.date = json["date"].doubleValue
        
        self.text = json["text"].stringValue
        self.likesCount = json["likes"]["count"].intValue
        self.likeUser = json["likes"]["user_likes"].intValue
        self.reposts = json["reposts"]["count"].intValue
        self.comments = json["comments"]["count"].intValue
        self.views = json["views"]["count"].intValue
        
        let attachmentsJSONs = json["attachments"].arrayValue
        self.attachments = attachmentsJSONs.map { Attachment(from: $0) }
        
        
    }
    
    
    
}

