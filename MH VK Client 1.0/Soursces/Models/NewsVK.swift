//
//  NewsVK.swift
//  MH VK Client 1.0
//
//  Created by Vitaly Khomatov on 28.02.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//
//import Foundation
//import SwiftyJSON
//import UIKit
//
//class NewsVK {
//    
//    var items = [NewsItemVK]()
//    var profiles = [NewsProfileVK]()
//    var groups = [GroupVK]()
//    var new_offset : String = "" // String или Int?
//    var next_from : String = "" // String или Int?
//    
//    
//    convenience init(from json: JSON) {
//        
//        self.init()
//        
//        let itemsJSONs = json["items"].arrayValue
//        self.items = itemsJSONs.map  { NewsItemVK(from: $0) }
//        
//        let profilesJSONs = json["profiles"].arrayValue
//        self.profiles = profilesJSONs.map  { NewsProfileVK(from: $0) }
//        
//        let groupsJSONs = json["groups"].arrayValue
//        self.groups = groupsJSONs.map  { GroupVK(from: $0) }
//        
//        
//    }
//    
//}


