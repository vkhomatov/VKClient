//
//  Animator.swift
//  MH VK Client 1.0
//
//  Created by Vit on 06.12.2019.
//  Copyright © 2019 Macrohard. All rights reserved.
//

//import UIKit

/*class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    private let animationDuration: TimeInterval = 1
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // Получаем оба view controller'a
        guard let source = transitionContext.viewController(forKey: .from),
            let destination = transitionContext.viewController(forKey: .to) else { return }
        
        // Добавляем destination в контейнер
        transitionContext.containerView.addSubview(destination.view)
        
        destination.view.layer.anchorPoint = CGPoint(x: 1, y: 0)
        
        // задаем итоговое местоположение для обоих view каждого из контроллеров, оно совпадает с экраном телефона
        source.view.frame = transitionContext.containerView.frame
        destination.view.frame = transitionContext.containerView.frame
        
        // трансформируем положение экрана на который нужно перейти
        destination.view.transform = CGAffineTransform(translationX: 0,
                                                       y: -destination.view.bounds.height)
        
        // запускаем анимированное возвращение экрана в итоговое положение
        UIView.animate(withDuration: animationDuration, animations: {
            destination.view.transform = .identity
        }) { completed in
            transitionContext.completeTransition(completed)
        }
    }
} */


//// Операция размытия изображения
//class BlurImageOperation: Operation {
//// Исходное изображение
//    var inputImage: UIImage
//// Размытое изображение
//    var outputImage: UIImage?
//
//// Логика нашей операции
//    override func main() {
//// Размываем изображение
//        let inputCIImage = CIImage(image: inputImage)!
//        let filter = CIFilter(name: "CIGaussianBlur", parameters: [kCIInputImageKey: inputCIImage])!
//        let outputCIImage = filter.outputImage!
//        let context = CIContext()
//        
//        let cgiImage = context.createCGImage(outputCIImage, from: outputCIImage.extent)
//
//// Кладем размытое изображение в свойство
//        outputImage = UIImage(cgImage: cgiImage!)
//    }
//
//// Конструктор для создания операции с изображением
//    init(inputImage: UIImage) {
//        self.inputImage = inputImage
//        super.init()
//    }
//}
