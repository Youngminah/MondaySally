//
//  Color.swift
//  MondaySally
//
//  Created by meng on 2021/06/29.
//

import UIKit

extension UIColor {
    // MARK: hex code를 이용하여 정의
    // ex. UIColor(hex: 0xF5663F)
    convenience init(hex: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    // MARK: 메인 테마 색 또는 자주 쓰는 색을 정의
    // ex. label.textColor = .mainOrange
    @nonobjc class var mainOrange: UIColor {
      return UIColor(red: 255.0 / 255.0, green: 120.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var mainBlue: UIColor {
      return UIColor(red: 255.0 / 255.0, green: 120.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var mainYellow: UIColor {
      return UIColor(red: 255.0 / 255.0, green: 120.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var tagColor: UIColor {
      return UIColor(red: 175.0 / 255.0, green: 175.0 / 255.0, blue: 78.0 / 175.0, alpha: 1.0)
    }
}


extension CALayer {
    // Sketch 스타일의 그림자를 생성하는 유틸리티 함수
    func applyShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4
    ) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
    }
}
