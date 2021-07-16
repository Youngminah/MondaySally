//
//  IndicatorView.swift
//  MondaySally
//
//  Created by meng on 2021/06/29.
//

import UIKit

open class IndicatorView {
    static let shared = IndicatorView()
        
    let containerView = UIView()
    let activityIndicator = UIActivityIndicatorView()
    
    open func show() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        self.containerView.frame = window.frame
        self.containerView.center = window.center
        self.containerView.backgroundColor = .clear
        
        self.containerView.addSubview(self.activityIndicator)
        UIApplication.shared.windows.first?.addSubview(self.containerView)
    }
    
    open func showIndicator() {
        self.containerView.backgroundColor = UIColor(hex: 0xFFFFFF, alpha: 1)
        
        self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        self.activityIndicator.style = .large
        self.activityIndicator.color = #colorLiteral(red: 1, green: 0.4705882353, blue: 0.3058823529, alpha: 1)
        self.activityIndicator.center = self.containerView.center
        
        self.activityIndicator.startAnimating()
    }
    
    open func dismiss() {
        self.activityIndicator.stopAnimating()
        self.containerView.removeFromSuperview()
    }
}
