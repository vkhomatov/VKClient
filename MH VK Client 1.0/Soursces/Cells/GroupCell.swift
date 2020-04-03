//
//  CommunitesCell.swift
//  MH VK Client 1.0
//
//  Created by Vitaly Khomatov on 19/09/2019.
//  Copyright © 2019 Macrohard. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {

    
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupPic: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        groupName.text = nil
        groupPic.image = nil
        
    }
    
    public func configure(witch group: GroupVK) {
        self.groupName.text = group.name
        self.groupPic.kf.setImage(with: URL(string: group.imageName))
       }

}
