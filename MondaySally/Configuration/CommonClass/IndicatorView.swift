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
    let viewForActivityIndicator = UIView()
    let activityIndicator = UIActivityIndicatorView()
    let window = UIWindow(frame: UIScreen.main.bounds)
    
    open func show() {
        self.containerView.frame = window.frame
        self.containerView.center = window.center
        self.containerView.backgroundColor = .clear
        
        viewForActivityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        viewForActivityIndicator.center = window.center

        UIApplication.shared.windows.first?.addSubview(self.containerView)
        self.containerView.addSubview(self.viewForActivityIndicator)
        self.viewForActivityIndicator.addSubview(self.activityIndicator)
    }
    
    open func showIndicator() {
        self.containerView.backgroundColor = UIColor(hex: 0xFFFFFF, alpha: 1)
        self.viewForActivityIndicator.layer.cornerRadius = 10
        self.viewForActivityIndicator.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
        self.viewForActivityIndicator.alpha = 0.8
        
        self.activityIndicator.frame = CGRect(x: viewForActivityIndicator.frame.size.width / 2 - 20,
                                              y: viewForActivityIndicator.frame.size.height / 2 - 20,
                                              width: 40,
                                              height: 40)
        self.activityIndicator.style = .large
        self.activityIndicator.color = #colorLiteral(red: 1, green: 0.4705882353, blue: 0.3058823529, alpha: 1)
        
        self.activityIndicator.startAnimating()
    }
    
    open func showTransparentIndicator() {
        self.containerView.backgroundColor = UIColor(hex: 0xFFFFFF, alpha: 0.5)
        self.viewForActivityIndicator.layer.cornerRadius = 10
        self.viewForActivityIndicator.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
        self.viewForActivityIndicator.alpha = 0.8
        
        self.activityIndicator.frame = CGRect(x: viewForActivityIndicator.frame.size.width / 2 - 20,
                                              y: viewForActivityIndicator.frame.size.height / 2 - 20,
                                              width: 40,
                                              height: 40)
        self.activityIndicator.style = .large
        self.activityIndicator.color = #colorLiteral(red: 1, green: 0.4705882353, blue: 0.3058823529, alpha: 1)

        self.activityIndicator.startAnimating()
    }
    
    open func dismiss() {
        self.activityIndicator.stopAnimating()
        self.containerView.removeFromSuperview()
        self.activityIndicator.removeFromSuperview()
        self.viewForActivityIndicator.removeFromSuperview()
    }
}
