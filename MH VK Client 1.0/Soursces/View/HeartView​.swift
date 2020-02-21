//
//  HeartView​.swift
//  MH VK Client 1.0
//
//  Created by Vit on 26/09/2019.
//  Copyright © 2019 Macrohard. All rights reserved.
//

import UIKit


class HeartView​: UIControl {

    
    @IBOutlet weak var heartLabel: UILabel!
    
    var isLiked: Bool = false
    var likeCount: Int = 0
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        heartLabel.text = String(likeCount)
        drawHeart(red: isLiked)
        
    }
    
    
//    required init(likeCount: Int, likeUser: Bool) {
//          self.init()
//        self.likeCount = likeCount
//        self.isLiked = likeUser
//    }
    
    
   override init(frame: CGRect) {
        super.init(frame: frame)
    
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }

    
    private func setupView() {
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGR)
        
        
        
       // print("self.likeCount \(likeCount)")
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    //MARK: - Privates
    
    // Функция обработки нажатия на сердце
    @objc func likeTapped() {
        isLiked.toggle()
        
        let springAnimation = CASpringAnimation(keyPath: "transform.scale")
        
        springAnimation.fromValue = 0
        springAnimation.toValue = 1
        springAnimation.duration = 0.5
        springAnimation.initialVelocity = 0
        springAnimation.mass = 0.5
        springAnimation.stiffness = 200
        springAnimation.isRemovedOnCompletion = false
        springAnimation.fillMode = .forwards
        
        self.layer.add(springAnimation, forKey: nil)
        
        // Анимация Label с количеством лайков
        UIView.transition(with: heartLabel, duration: 0.25, options: .transitionFlipFromBottom, animations: { self.heartLabel.text = String(self.likeCount) })
        
        
        drawHeart(red: isLiked)
        sendActions(for: .valueChanged)
        
        
    }
    
    // Функция прорисовки сердца
    func drawHeart(red : Bool) {
        
        setNeedsDisplay()
        
        guard let context = UIGraphicsGetCurrentContext() else  { return }
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 13.52, y: 1.14))
        bezierPath.addCurve(to: CGPoint(x: 4.7, y: 4.37), controlPoint1: CGPoint(x: 13.09, y: 1.11), controlPoint2: CGPoint(x: 7.53, y: 2))
        bezierPath.addCurve(to: CGPoint(x: 1.32, y: 19.27), controlPoint1: CGPoint(x: 1.22, y: 7.31), controlPoint2: CGPoint(x: 0.47, y: 12.38))
        bezierPath.addCurve(to: CGPoint(x: 26.39, y: 51), controlPoint1: CGPoint(x: 2.84, y: 31.73), controlPoint2: CGPoint(x: 26.39, y: 51))
        bezierPath.addCurve(to: CGPoint(x: 50.79, y: 19.27), controlPoint1: CGPoint(x: 26.39, y: 51), controlPoint2: CGPoint(x: 49.44, y: 31.73))
        bezierPath.addCurve(to: CGPoint(x: 39.95, y: 1.14), controlPoint1: CGPoint(x: 52.15, y: 6.8), controlPoint2: CGPoint(x: 46.72, y: 2.43))
        bezierPath.addCurve(to: CGPoint(x: 26.39, y: 8.26), controlPoint1: CGPoint(x: 33.17, y: -0.16), controlPoint2: CGPoint(x: 26.39, y: 8.26))
        bezierPath.addCurve(to: CGPoint(x: 13.52, y: 1.14), controlPoint1: CGPoint(x: 26.39, y: 8.26), controlPoint2: CGPoint(x: 20.21, y: 1.55))
        bezierPath.close()
        
        
        if red { UIColor.red.setFill()
            bezierPath.fill()
            heartLabel.textColor = .red
            heartLabel.text = String(likeCount + 1)
        } else {  heartLabel.textColor = .black }
        
       // heartLabel.text = String(likeCount - 1)
        
        UIColor.black.setStroke()
        bezierPath.lineWidth = 1
        context.saveGState()
        context.setLineDash(phase: 0, lengths: [2, 2])
        bezierPath.stroke()
        context.restoreGState()
        
        setNeedsDisplay()
        
    }
}


//extension HeartView​: FriendPhotosControllerDelegate {
//
//
//    func setPhotoLikesCount(count: Int, likeUser: Int)
//    {
//        self.likeCount = count
//        if likeUser == 1 {
//            self.isLiked = true } else {
//            self.isLiked = false
//
//        }
//        print("ДЕЛЕГАТ СРАБОТАЛ, КОЛ-ВО ЛАЙКОВ: \(likeCount)")
//    }
//
////    func changeNextButtonTitle(text: String) {
////     mainView.nextButton.setTitle(text, for: .normal)
////    }
////
////    func setPickerView(view: UIView) {
////        mainView.addSubview(view)
////    }
//
//}
