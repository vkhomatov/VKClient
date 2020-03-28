//
//  PhotoView.swift
//  MH VK Client 1.0
//
//  Created by Vitaly Khomatov on 23.03.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import UIKit

//  вычисляем и задаем правильную высоту для UIMageView
class PhotoView: UIImageView {

   override var intrinsicContentSize: CGSize {

        if let myImage = self.image {
            let myImageWidth = myImage.size.width
            let myImageHeight = myImage.size.height
            let myViewWidth = self.frame.size.width

            let ratio = myViewWidth/myImageWidth
            let scaledHeight = myImageHeight * ratio

            return CGSize(width: myViewWidth, height: scaledHeight)
        }

        return CGSize(width: -1.0, height: -1.0)
    }
    
    

}
