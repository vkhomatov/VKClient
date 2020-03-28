//
//  NewsLinkCell.swift
//  MH VK Client 1.0
//
//  Created by Vitaly Khomatov on 04.03.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import UIKit

class NewsLinkCell: UITableViewCell {
    
    @IBOutlet weak var linkTitle: UILabel!
    @IBOutlet weak var linkCaption: UILabel!
    @IBOutlet weak var linkPhoto: UIImageView!
    @IBOutlet weak var linkDescription: UILabel!
    @IBOutlet weak var linkUrl: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        linkTitle.text = nil
        linkCaption.text = nil
        linkPhoto.image = nil
        linkDescription.text = nil
        linkUrl.text = nil
        
        
//        linkPhoto.layer.cornerRadius = 20
//        super.layoutSubviews()


        
    }
    
    public func configure(witch news: NewsForTable) {
        
        if news.link != nil {
            
            self.linkTitle.text = news.link!.title
            self.linkCaption.text = news.link!.caption
            self.linkPhoto.kf.setImage(with: URL(string: news.link!.photo!.imageFullURLString))
            self.linkDescription.text = news.link!.description
            self.linkUrl.text = news.link!.url
        }

    }
    
    
}
