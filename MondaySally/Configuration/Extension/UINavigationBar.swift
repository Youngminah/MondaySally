//
//  UINavigationBar.swift
//  MondaySally
//
//  Created by meng on 2021/06/29.
//

import UIKit

extension UINavigationBar {
    
    // MARK: 네비게이션바를 투명하게 처리
    var isTransparent: Bool {
        get {
            return false
        } set {
            self.isTranslucent = newValue
            self.setBackgroundImage(newValue ? UIImage() : nil, for: .default)
            self.shadowImage = newValue ? UIImage() : nil
            self.backgroundColor = newValue ? .clear : nil
        }
    }
    
    //네비게이션바 폰트와 사이즈
    func applyFontAndSize(){
        self.titleTextAttributes =
        [NSAttributedString.Key.foregroundColor: UIColor.label,
         NSAttributedString.Key.font: UIFont(name: "NotoSansCJKkr-Medium", size: 17)!]
    }
    
    // 기본 그림자 스타일을 초기화해야 커스텀 스타일을 적용할 수 있다.
    static func clearShadow() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
    }
}
