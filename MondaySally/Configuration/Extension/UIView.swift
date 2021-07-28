//
//  UIView.swift
//  MondaySally
//
//  Created by meng on 2021/07/01.
//

import Foundation
import UIKit

extension UIView {
    
    func showViewIndicator() {
        let indicator = UIActivityIndicatorView()
//        let buttonHeight = self.bounds.size.height
//        let buttonWidth = self.bounds.size.width
//        indicator.center = CGPoint(x: buttonWidth / 2, y: buttonHeight / 2)
        indicator.center = self.center
        self.addSubview(indicator)
        indicator.startAnimating()
    }
    
    func dismissViewndicator() {
        for view in self.subviews {
            if let indicator = view as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
    
    public var width : CGFloat {
        return self.frame.size.width
    }
    
    public var height : CGFloat {
        return self.frame.size.height
    }
    
    public var top : CGFloat {
        return self.frame.origin.y
    }
    
    public var bottom : CGFloat {
        return self.frame.size.height + self.frame.origin.y
    }
    
    public var left : CGFloat {
        return self.frame.origin.x
    }
    
    public var right : CGFloat {
        return self.frame.size.width + self.frame.origin.x
    }
}
