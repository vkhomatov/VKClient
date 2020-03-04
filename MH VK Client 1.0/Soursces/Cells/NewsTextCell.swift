//
//  NewsTextCell.swift
//  MH VK Client 1.0
//
//  Created by Vitaly Khomatov on 23.02.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import UIKit

class NewsTextCell: UITableViewCell {
    
    
    @IBOutlet weak var messageLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.text = nil
        
    }
    
    public func configure(witch news: NewsForTable) {
        
        if news.text != "" {
            self.messageLabel.text = news.text
        }
        else if news.otherrow {
            self.messageLabel.text = "Новость содержит только \(news.attachType) контент"
        }
        
        if news.text == "" && !news.otherrow {
            self.messageLabel.text = "Новость не содержит контент"
        }
    }
        
}
