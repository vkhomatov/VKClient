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
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsPhoto.image = nil
      //  newsPhoto.isHidden = true

    }
    
    
    public func configure(witch news: NewsForTable) {
        
        
        if news.photo != nil {
        //    newsPhoto.isHidden = false
        self.newsPhoto.kf.setImage(with: URL(string: news.photo!.imageCellURLString))

          //   print("ИМАДЖВЬЮ ОТКРЫТ")


        }


        
       // let screenSize: CGRect = UIScreen.main.bounds
       // self. = ((screenSize.width) / CGFloat((news.widhtPhoto/news.heighPhoto)))
        
       // self.frame.height =
        
//        if news.attachPhoto != nil
//        {
//        self.newsPhoto.kf.setImage(with: URL(string: news.attachPhoto!))
//            newsPhoto.isHidden = false
//
//        }
//        else {
//            newsPhoto.isHidden = true
//            print("ИМАДЖВЬЮ СПРЯТАН")
//        }
        
    }
    
}
