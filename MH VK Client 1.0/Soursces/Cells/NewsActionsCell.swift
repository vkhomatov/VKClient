//
//  NewsActionsCell.swift
//  MH VK Client 1.0
//
//  Created by Vitaly Khomatov on 23.02.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class NewsActionsCell: UITableViewCell {
    
    @IBAction func likeButton(_ sender: UIButton) {
        
    }
    
    @IBOutlet weak var likeUser: UIImageView!
    
    @IBOutlet weak var likeCount: UILabel!
        
    @IBOutlet weak var commentsCount: UILabel!
    
    @IBOutlet weak var repostCount: UILabel!
    
    @IBOutlet weak var viewsCount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
   override func prepareForReuse() {
        super.prepareForReuse()
        likeCount.text = nil
        commentsCount.text = nil
        repostCount.text = nil
        viewsCount.text = nil
        likeUser.image =  UIImage(systemName: "suit.heart")
    }
    
    public func configure(witch news: NewsForTable) {
        self.likeCount.text = String(news.likesCount)
        self.commentsCount.text = String(news.comments)
        self.repostCount.text = String(news.reposts)
        self.viewsCount.text = String(news.views)
        
        if news.likeUser == 1 {
            likeUser.image =  UIImage(systemName: "suit.heart.fill")
        }
                
    }

}
