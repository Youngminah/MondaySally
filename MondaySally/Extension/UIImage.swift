//
//  UIImage.swift
//  MondaySally
//
//  Created by meng on 2021/08/04.
//

import UIKit

extension UIImage {
    func translatedHorizontally(by constant: CGFloat) -> UIImage? {
        let newSize = CGSize(width: size.width + constant, height: size.height)
        let newPoint = CGPoint(x: constant, y: 0.0)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        draw(at: newPoint)
        let translatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return translatedImage
    }
} 
