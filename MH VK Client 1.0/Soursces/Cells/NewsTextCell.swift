//
//  NewsTextCell.swift
//  MH VK Client 1.0
//
//  Created by Vitaly Khomatov on 23.02.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import UIKit

class NewsTextCell: UITableViewCell {
    
    var less: Bool = true
    private var seeMoreDidTapHandler: (() -> Void)?

    
    func onSeeMoreDidTap(_ handler: @escaping () -> Void) {
           
           self.seeMoreDidTapHandler = handler
       }
    
    
    @IBOutlet weak var messageLabel: UILabel! {
        didSet {
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    let textMaxHeight = 200.0

    
    @IBOutlet weak var moreLessButton: UIButton!
    
    @IBAction func moreLessButtonClick(_ sender: Any) {
        
        
        if less {
            let cellTextHeight = getLabelHeight(text: messageLabel.text!, font:  self.messageLabel.font)
            self.messageLabel.numberOfLines = Int(cellTextHeight) / Int(self.messageLabel.font.lineHeight)
            self.moreLessButton.setTitle("less", for: .normal)
     
            print("ВЫСОТА ТЕКСТА: \(cellTextHeight)")
            print("КОЛ-ВО СТРОК: \(self.messageLabel.numberOfLines)")

            
        } else {
            self.messageLabel.numberOfLines = Int(textMaxHeight) / Int(self.messageLabel.font.lineHeight)
            self.moreLessButton.setTitle("more", for: .normal)
      
        }
        
        less.toggle()

        self.seeMoreDidTapHandler?()


    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.text = nil
        moreLessButton.isHidden = true
        less = true

    }
    

//    let instets: CGFloat = 10.0
//
//    func getLabelSize(text: String, font: UIFont) -> CGSize {
//        // определяем максимальную ширину текста - это ширина ячейки минус отступы слева и справа
//        let maxWidth = bounds.width - instets * 2
//        // получаем размеры блока под надпись
//        // используем максимальную ширину и максимально возможную высоту
//        let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
//        // получаем прямоугольник под текст в этом блоке и уточняем шрифт
//        let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
//        // получаем ширину блока, переводим её в Double
//        let width = Double(rect.size.width)
//        // получаем высоту блока, переводим её в Double
//        let height = Double(rect.size.height)
//        // получаем размер, при этом округляем значения до большего целого числа
//        let size = CGSize(width: ceil(width), height: ceil(height))
//        return size
//    }

    // вычисляем высоту текстового блока
    let instets: CGFloat = 10.0

       func getLabelHeight(text: String, font: UIFont) -> Double {
           // определяем максимальную ширину текста - это ширина ячейки минус отступы слева и справа
           let maxWidth = bounds.width - instets * 2
           // получаем размеры блока под надпись
           // используем максимальную ширину и максимально возможную высоту
           let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
           // получаем прямоугольник под текст в этом блоке и уточняем шрифт
           let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
           // получаем ширину блока, переводим её в Double
        //   let width = ceil(Double(rect.size.width))
           // получаем высоту блока, переводим её в Double
           let height = ceil(Double(rect.size.height))
           // получаем размер, при этом округляем значения до большего целого числа
        //   let size = CGSize(width: ceil(width), height: ceil(height))
           return height
       }
    
    
    public func configure(witch news: NewsForTable) {
        
        if news.text != "" {
            self.messageLabel.text = news.text
            
            let cellTextHeight = getLabelHeight(text: news.text, font:  self.messageLabel.font)


            if (cellTextHeight - textMaxHeight) > 100 {
          //  self.messageLabel.heightAnchor.constraint(equalToConstant: CGFloat(cellMinHeight)).isActive = true
            self.messageLabel.numberOfLines = Int(textMaxHeight) / Int(self.messageLabel.font.lineHeight)

                if moreLessButton != nil {
                    self.moreLessButton.isHidden = false

                }

            less = true
                
         //   print("ВЫСОТА ТЕКСТА: \(textMaxHeight)")
         //   print("КОЛ-ВО СТРОК: \(self.messageLabel.numberOfLines)\n")

            }

      
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
