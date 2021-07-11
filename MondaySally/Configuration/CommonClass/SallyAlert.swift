//
//  SallyAlert.swift
//  MondaySally
//
//  Created by meng on 2021/07/12.
//

import UIKit

open class SallyAlert {
    struct Constants {
        static let backgroundAlphaTo: CGFloat = 0.6
    }
    
    var didDismiss: (() -> ())?
    
    private let backgroundView: UIView = {
        let backgrounView = UIView()
        backgrounView.backgroundColor = .black
        backgrounView.alpha = 0
        return backgrounView
    }()
    
    private let alertView: UIView = {
       let alert = UIView()
        alert.backgroundColor = .white
        alert.layer.masksToBounds = true
        alert.layer.cornerRadius = 11
        return alert
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "illustMondaysallySymbolPopup")
        return imageView
    }()
    
    private var myTargetView: UIView?
    
    open func showAlert(with title: String, message: String, on viewController: UIViewController) {
        guard let targetView = viewController.view else {
            return
        }
        myTargetView = targetView
        
        backgroundView.frame = targetView.bounds
        targetView.addSubview(backgroundView)
        targetView.addSubview(imageView)
        targetView.addSubview(alertView)
        
        self.alertView.frame = CGRect(x: 60, y: -300, width: targetView.frame.size.width - 120, height: 150)
        
        self.imageView.frame = CGRect(x: (targetView.frame.size.width - 100)/2, y: -300, width: 100, height: 50)
        
        let titleLabel = UILabel(frame: CGRect(x:0, y:0, width: alertView.frame.size.width, height: 100))
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        self.alertView.addSubview(titleLabel)
        
//        let messageLabel = UILabel(frame: CGRect(x:0, y:80, width: alertView.frame.size.width, height: 170))
//        messageLabel.numberOfLines = 0
//        messageLabel.text = message
//        messageLabel.textAlignment = .center
//        self.alertView.addSubview(messageLabel)
        
        let button = UIButton(frame: CGRect(x:0, y:alertView.frame.size.height - 50, width: alertView.frame.size.width, height: 50))
        button.setTitle("확인", for: .normal)
        button.backgroundColor = #colorLiteral(red: 1, green: 0.4705882353, blue: 0.3058823529, alpha: 1)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        self.alertView.addSubview(button)
        
        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundView.alpha = Constants.backgroundAlphaTo
        } , completion: { done in
            if done {
                UIView.animate(withDuration: 0.25, animations: {
                    self.alertView.center = targetView.center
                    self.imageView.frame = CGRect(x: (targetView.frame.size.width - 100)/2, y: targetView.frame.midY - 125, width: 100, height: 50)
                })
            }
            
        })
    }
    
    @objc open func dismissAlert(){
        
        guard let targetView = myTargetView else {
            return
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            self.alertView.frame = CGRect(x: 60, y: -300, width: targetView.frame.size.width - 120, height: 300)
            self.imageView.frame = CGRect(x: (targetView.frame.size.width - 100)/2, y: -300, width: 100, height: 50)
        } , completion: { done in
            if done {
                UIView.animate(withDuration: 0.25, animations: {
                    self.backgroundView.alpha = 0
                }, completion: { done in
                    if done {
                        self.imageView.removeFromSuperview()
                        self.alertView.removeFromSuperview()
                        self.backgroundView.removeFromSuperview()
                        self.didDismiss?()
                        
                    }
                    
                })
            }
            
        })
    }
    
}
