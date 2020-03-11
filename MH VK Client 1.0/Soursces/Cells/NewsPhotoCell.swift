//
//  NewsPhotoCell.swift
//  MH VK Client 1.0
//
//  Created by Vitaly Khomatov on 23.02.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import UIKit

class NewsPhotoCell: UITableViewCell {
    
    
    @IBOutlet weak var newsPhoto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsPhoto.image = nil
        
    }
    
    
    public func configure(witch news: NewsForTable) {
        
        if news.photorow {
            
            if news.photo != nil {
                self.newsPhoto.kf.setImage(with: URL(string: news.photo!.imageCellURLString)) }
        }
        
        if news.wallphoto {
            if news.wallphotos[0].imageCellURLString != "" {
                self.newsPhoto.kf.setImage(with: URL(string: news.wallphotos[0].imageCellURLString)) }
        }
    }
    
//    public func configure_wallphoto(witch news: NewsForTable) {
//
//        if news.wallphotos[0].imageCellURLString != "" {
//            self.newsPhoto.kf.setImage(with: URL(string: news.wallphotos[0].imageCellURLString))
//
//        }
//    }
    
    
}
