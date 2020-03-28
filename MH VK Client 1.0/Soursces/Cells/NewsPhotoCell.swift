//
//  NewsPhotoCell.swift
//  MH VK Client 1.0
//
//  Created by Vitaly Khomatov on 23.02.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import UIKit

class NewsPhotoCell: UITableViewCell {
    
    
//    override var intrinsicContentSize: CGSize {
//
//        return newsPhoto.intrinsicContentSize
//    }
//    
    
    
    @IBOutlet weak var newsPhoto: UIImageView!
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
newsPhoto.setNeedsLayout()

    //    newsPhoto.frame = contentView.bounds
       // configure(witch: NewsForTable)
    }
    private var photoLoadHandler: (() -> Void)?


    func cellLayout(_ handler: @escaping () -> Void) {

              self.photoLoadHandler = handler
          }

    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsPhoto.image = nil

    }
    
    
    public func configure(witch news: NewsForTable) {
        
        if news.photorow {
            
            if news.photo != nil {
                
                self.newsPhoto.kf.setImage(with: URL(string: news.photo!.imageFullURLString))
             //   self.newsPhoto.setNeedsLayout()

                self.layoutSubviews()
                self.photoLoadHandler?()

              //  setNeedsDisplay()
             //   self.layoutIfNeeded()

               
            }
        }
        
        if news.wallphoto {
            if news.wallphotos[0].imageCellURLString != "" {
                
                self.newsPhoto.kf.setImage(with: URL(string: news.wallphotos[0].imageFullURLString))
          //      self.newsPhoto.setNeedsLayout()
                self.photoLoadHandler?()
                self.layoutSubviews()


              //  self.layoutIfNeeded()

//                let cellheight = Int(CGFloat(news.wallphotos[0].height) / (CGFloat(news.wallphotos[0].width) / CGFloat(self.frame.size.width)))
//                self.newsPhoto.heightAnchor.constraint(equalToConstant: CGFloat(cellheight)).isActive = true
              //  setNeedsDisplay()
                
            }
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
