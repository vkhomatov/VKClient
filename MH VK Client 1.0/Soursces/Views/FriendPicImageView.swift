//
//  FriendPicImageView.swift
//  MH VK Client 1.0
//
//  Created by Vitaly Khomatov on 23/09/2019.
//  Copyright © 2019 Macrohard. All rights reserved.
//

import UIKit

@IBDesignable class FriendPicImageView: UIImageView {
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        let longGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(imageLongTapped(longGestureRecognizer:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(longGestureRecognizer)
        
    }
    
    @objc func imageLongTapped(longGestureRecognizer: UILongPressGestureRecognizer) {
        
        let springAnimation = CASpringAnimation(keyPath: "transform.scale")
        
        longGestureRecognizer.minimumPressDuration = 0.01
        
        if longGestureRecognizer.state == .began  {
            
            springAnimation.fromValue = 1
            springAnimation.toValue = 0.7
            springAnimation.duration = 0.1
            springAnimation.isRemovedOnCompletion = false
            springAnimation.fillMode = .forwards
            self.layer.add(springAnimation, forKey: nil)
        }
        
        if longGestureRecognizer.state == .ended  {
            
            springAnimation.fromValue = 0.7
            springAnimation.toValue = 1
            springAnimation.duration = 0.5
            springAnimation.initialVelocity = 0
            springAnimation.mass = 1
            springAnimation.stiffness = 200
            springAnimation.isRemovedOnCompletion = false
            springAnimation.fillMode = .forwards
            self.layer.add(springAnimation, forKey: nil)
        }
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyCircleShadowImageView()
        
    }
    
}


//Нашел вот такое решение на стековерфлоу,  расширения для классов создающие форму круга и тень 

extension UIView {
    
    
    
    func applyCircleShadowView(shadowRadius: CGFloat = 0,
                               shadowOpacity: Float = 0.0,
                               shadowColor: CGColor = UIColor.white.cgColor,
                               shadowOffset: CGSize = CGSize.zero) {
        layer.cornerRadius = frame.size.height / 2
        layer.masksToBounds = false
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
    }
}


// установка тени для иконок
extension UIImageView {
    
    
    @IBInspectable var myRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var myOpacity: Float {
        get {
            return layer.opacity
        }
        set {
            layer.opacity = newValue
        }
    }
    
    @IBInspectable var myColor: UIColor {
        get {
            return UIColor(cgColor: layer.shadowColor!)
        }
        set {
            layer.shadowColor = newValue.cgColor
        }
    }
    
    
    func applyCircleShadowImageView(shadowRadius: CGFloat = 0,
                                    shadowOpacity: Float = 0,
                                    shadowColor: CGColor = UIColor.white.cgColor,
                                    shadowOffset: CGSize = CGSize.zero) {
        
        // Use UIImageView.hashvalue as background view tag (should be unique)
        let background: UIView = superview?.viewWithTag(hashValue) ?? UIView() //не понял механизм, хотелось бы комментариев
        background.removeFromSuperview() //????? нужно тут или нет
        background.frame = frame
        background.backgroundColor = backgroundColor
        background.tag = hashValue
        background.applyCircleShadowView(shadowRadius: myRadius, shadowOpacity: myOpacity, shadowColor: myColor.cgColor, shadowOffset: shadowOffset)
        layer.cornerRadius = background.layer.cornerRadius
        layer.masksToBounds = true
        superview?.insertSubview(background, belowSubview: self)
    }
}

