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
//        if let myImage = self.newsPhoto.image {
//            let myImageWidth = myImage.size.width
//            let myImageHeight = myImage.size.height
//            let myViewWidth = self.frame.size.width
//
//            let ratio = myViewWidth/myImageWidth
//            let scaledHeight = myImageHeight * ratio
//
//            return CGSize(width: myViewWidth, height: scaledHeight)
//        }
//
//        return CGSize(width: -1.0, height: -1.0)
//    }
    
    
    
    @IBOutlet weak var newsPhoto: UIImageView!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // newsPhoto.layoutIfNeeded()
    }
    
//    private var photoLoadHandler: (() -> Void)?
//
//
//    func cellLayout(_ handler: @escaping () -> Void) {
//
//    //    print("self.frame.size.height = \(self.frame.size.height)")
//              self.photoLoadHandler = handler
//      //  self.frame.size.height = 200.0
//          }

    
    override func prepareForReuse() {
        super.prepareForReuse()
      //  self.frame.size.height = 200.0
        newsPhoto.image = nil

    }
    
    
    public func configure(witch news: NewsForTable) {
        
        if news.photorow {
            
            if news.photo != nil {
                
                self.newsPhoto.kf.setImage(with: URL(string: news.photo!.imageFullURLString))
               // self.frame.size.height = 200.0

              //  self.layoutSubviews()
                self.setNeedsDisplay()

              //  self.photoLoadHandler?()
               
            }
        }
        
        if news.wallphoto {
            if news.wallphotos[0].imageCellURLString != "" {
                
                self.newsPhoto.kf.setImage(with: URL(string: news.wallphotos[0].imageFullURLString))
              //  self.photoLoadHandler?()
                self.layoutSubviews()
                
            }
        }
    }

    
}
