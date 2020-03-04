//
//  NewsProfileVK.swift
//  MH VK Client 1.0
//
//  Created by Vitaly Khomatov on 28.02.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//


import SwiftyJSON

class NewsProfileVK {
    
    var id: Int = 0
    var firstName: String = ""
    var lastName: String = ""
    var mainPhoto: String = ""
    var deactivated: String = ""
    
    var photo : String = ""
    var photo_medium_rec : String = ""
    var screen_name : String = ""
    
    var fullName: String { firstName + " " + lastName }
    
    convenience init(from json: JSON) {
        self.init()
        
        self.id = json["id"].intValue
        self.firstName = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.mainPhoto = json["photo_100"].stringValue
        self.photo = json["photo"].stringValue
        self.photo_medium_rec = json["photo_medium_rec"].stringValue
        self.screen_name = json["screen_name"].stringValue
        
    }
    
}



