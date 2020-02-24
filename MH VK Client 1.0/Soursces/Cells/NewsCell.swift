//
//  NewsCell.swift
//  MH VK Client 1.0
//
//  Created by Vit on 02/10/2019.
//  Copyright © 2019 Macrohard. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    
    var like : Bool = false
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentCountLabel: UILabel!
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var shareCountLabel: UILabel!
    
    @IBOutlet weak var seeCountLabel: UILabel!
    @IBOutlet weak var seePicLabel: UILabel!
    
    @IBOutlet weak var newsPicImage: UIImageView!
    @IBOutlet weak var newsNameLabel: UILabel!
    
    
    @IBAction func pressLikeButton(_ sender: Any) {
        
        if !like {
            likeButton.titleLabel?.textColor = .red
            
            var num : Int?
            num = Int(likeCountLabel.text!)
            if num != nil {
                num! += 1
                likeCountLabel.text = String(num!)
                likeCountLabel.textColor = .red
                likeButton.titleLabel?.textColor = .red
                like = true
            }
        } else {
            var num : Int?
            num = Int(likeCountLabel.text!)
            if num != nil {
                num! -= 1
                likeCountLabel.text = String(num!)
                likeCountLabel.textColor = .red
                likeButton.titleLabel?.textColor = .gray
                like = false
            }
            
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        newsNameLabel.text = nil
        newsPicImage.image = nil
        likeCountLabel.text = "0"
        commentCountLabel.text = "0"
        shareCountLabel.text = "0"
        like = false
        
        
    }
    
  
}
