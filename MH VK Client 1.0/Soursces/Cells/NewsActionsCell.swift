//
//  NewsActionsCell.swift
//  MH VK Client 1.0
//
//  Created by Vitaly Khomatov on 23.02.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import UIKit

class NewsActionsCell: UITableViewCell {
    
    @IBAction func likeButton(_ sender: UIButton) {
        
    }
    
    @IBOutlet weak var likeButton: UIButton!

    @IBOutlet weak var likeCount: UILabel!
        
    @IBOutlet weak var commentsCount: UILabel!
    
    @IBOutlet weak var repostCount: UILabel!
    
    @IBOutlet weak var viewsCount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
   override func prepareForReuse() {
        super.prepareForReuse()
        likeCount.text = nil
        commentsCount.text = nil
        repostCount.text = nil
        viewsCount.text = nil
    }
    
}
