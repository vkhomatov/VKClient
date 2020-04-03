//
//  FriendProfilCell.swift
//  MH VK Client 1.0
//
//  Created by Vitaly Khomatov on 19/09/2019.
//  Copyright © 2019 Macrohard. All rights reserved.
//

import UIKit
import Kingfisher


class FriendAlbumCell: UICollectionViewCell {
    
    @IBOutlet weak var friendAlbumPic: UIImageView!
    @IBOutlet weak var friendAlbumName: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        friendAlbumName.text = nil
        friendAlbumPic.image = nil
        
    }
    
    public func configure(witch album: FriendAlbum) {
        self.friendAlbumName.text = album.title
        self.friendAlbumPic.kf.setImage(with: URL(string: album.coverPhoto))
    }
    
    
}
