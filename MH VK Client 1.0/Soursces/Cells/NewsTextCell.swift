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
    
   // var attach: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.text = nil
        
    }
    
    
    
    
    public func configure(witch news: NewsForTable) {
        
        if news.text != "" {
            self.messageLabel.text = news.text
        } else if news.emptynews == true {
            self.messageLabel.text = "Отсутствует содержание новости или тип новости нераспознан"

        }
        
        
        if news.post_type == "copy" {
            self.messageLabel.text = "Новость типа репост"
        }
        
        if news.text == "" && news.otherrow {
        self.messageLabel.text = "Новость содержит только \(news.attachType) аттачмент"
        }
        
        
        if news.othernews {
            self.messageLabel.text = "Новость содержит только \(news.attachType) контент"
        }
        
        
        
    }
    
}
