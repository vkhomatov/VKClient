//
//  NewsHeadCell.swift
//  MH VK Client 1.0
//
//  Created by Vitaly Khomatov on 23.02.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import UIKit
//import TinyConstraints

class NewsHeadCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var headPhoto: FriendPicImageView!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        dateLabel.text = nil
        headPhoto.image = nil
    }
    
//    public func configure(witch friend: FriendVK) {
//        self.friendName.text = friend.fullName
//        self.friendPic.kf.setImage(with: URL(string: friend.mainPhoto))
//    }
    
      override func awakeFromNib() {
     super.awakeFromNib()
     // Initialization code
     }
     
     
    
}
