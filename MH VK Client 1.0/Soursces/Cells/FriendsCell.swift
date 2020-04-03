//
//  FriendsCell.swift
//  MH VK Client 1.0
//
//  Created by Vitaly Khomatov on 19/09/2019.
//  Copyright © 2019 Macrohard. All rights reserved.
//

import UIKit
import Kingfisher


class FriendsCell: UITableViewCell {
    
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var friendPic: FriendPicImageView!    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    } 
    
    override func prepareForReuse() {
        super.prepareForReuse()
        friendName.text = nil
        friendPic.image = nil
        friendName.textColor = .black
        isUserInteractionEnabled = true
    }
    
    public func configure(witch friend: FriendVK) {
        self.friendName.text = friend.fullName
        self.friendPic.kf.setImage(with: URL(string: friend.mainPhoto))
    }
    
}
