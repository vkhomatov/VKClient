//
//  NewsForTable.swift
//  MH VK Client 1.0
//
//  Created by Vitaly Khomatov on 02.03.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import Foundation

struct NewsForTable {
    
    var textrow      : Bool = false
    var photorow     : Bool = false
    var linkrow      : Bool = false
    var otherrow     : Bool = false
    var rowsCount    : Int = 2
        
    var avaPhoto: String = ""
    var fullName: String = ""
    var date: String = ""
    
    var text: String = ""
    var attachType: String = ""
    
    var photo: attachPhoto? = nil
    var link: attachLink? = nil
    
    var likesCount: Int = 0
    var likeUser: Int = 0
    var reposts: Int = 0
    var comments: Int = 0
    var views: Int = 0
    
}


