//
//  CustomPop+PopAnimators.swift
//  MH VK Client 1.0
//
//  Created by Vitaly Khomatov on 06.12.2019.
//  Copyright © 2019 Macrohard. All rights reserved.
//

import UIKit

class PushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private let animationDuration: TimeInterval = 1
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from),
            let destination = transitionContext.viewController(forKey: .to) else { return }
        
        transitionContext.containerView.addSubview(destination.view)
        
        destination.view.layer.anchorPoint = CGPoint(x: 0, y: 0)
        
        
        source.view.frame = transitionContext.containerView.frame
        destination.view.frame = transitionContext.containerView.frame
        
        destination.view.transform = CGAffineTransform(rotationAngle: -90.degreesToRadians)
        
        
        UIView.animateKeyframes(withDuration: animationDuration, delay: 0, options: .calculationModePaced, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.33, animations: {
                let translation = CGAffineTransform(rotationAngle: -60.degreesToRadians)
                destination.view.transform = translation
            })
            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.33, animations: {
                let translation = CGAffineTransform(rotationAngle: -30.degreesToRadians)
                destination.view.transform = translation
            })
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.33, animations: {
                // let translation = CGAffineTransform(rotationAngle: 0)
                //destination.view.transform = translation
                destination.view.transform = .identity
            })
            
            
        }) { finished in
            if finished && !transitionContext.transitionWasCancelled {
                destination.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
}

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private let animationDuration: TimeInterval = 1
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from),
            let destination = transitionContext.viewController(forKey: .to) else { return }
        
        transitionContext.containerView.addSubview(destination.view)
        transitionContext.containerView.addSubview(source.view)
        
        
        destination.view.layer.anchorPoint = CGPoint(x: 0, y: 0)
        
        
        source.view.frame = transitionContext.containerView.frame
        destination.view.frame = transitionContext.containerView.frame
        
        UIView.animateKeyframes(withDuration: animationDuration, delay: 0, options: .calculationModePaced, animations: {
            
            /*  UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.75, animations: {
             destination.view.transform = .identity
             }) */
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.33, animations: {
                let translation = CGAffineTransform(rotationAngle: -30.degreesToRadians)
                source.view.transform = translation
            })
            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.33, animations: {
                let translation = CGAffineTransform(rotationAngle: -60.degreesToRadians)
                source.view.transform = translation
            })
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.33, animations: {
                let translation = CGAffineTransform(rotationAngle: -90.degreesToRadians)
                source.view.transform = translation
            })
            
            
        }) { finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.removeFromParent()
            } else if transitionContext.transitionWasCancelled {
                source.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
}


extension Int {
    var degreesToRadians: CGFloat { return CGFloat(Int(self)) * .pi / 180 }
}

//extension FloatingPoint {
//    var degreesToRadians: Self { return self * .pi / 180 }
//    var radiansToDegrees: Self { return self * 180 / .pi }
//}
