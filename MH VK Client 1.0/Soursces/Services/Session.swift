//
//  Session.swift
//  MH VK Client 1.0
//
//  Created by Vitaly Khomatov on 14.12.2019.
//  Copyright © 2019 Macrohard. All rights reserved.
//

import Foundation

class Session {
    private init() { }
    
    var accessToken = ""
    var usedId = 0
    
    static let shared = Session()
}
