//
//  SallyAlert.swift
//  MondaySally
//
//  Created by meng on 2021/07/12.
//

import UIKit

open class SallyNotificationAlert {
    static let shared = SallyNotificationAlert()
    var didDismiss: (() -> ())?
    var selectedYes: (() -> ())?
    
    private let backgroundView: UIView = {
        let backgrounView = UIView()
        backgrounView.backgroundColor = .black
        backgrounView.alpha = 0.6
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
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont(name: "NotoSansCJKkr-Regular", size: 14)
        return titleLabel
    }()
    
    private let messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 2
        messageLabel.font = UIFont(name: "NotoSanskr-Light", size: 13)
        messageLabel.tintColor = #colorLiteral(red: 0.5490196078, green: 0.5490196078, blue: 0.5490196078, alpha: 1)
        return messageLabel
    }()
    
    private let yesButton: UIButton = {
        let button = UIButton()
        button.setTitle("예", for: .normal)
        button.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Medium", size: 15)
        button.backgroundColor = #colorLiteral(red: 1, green: 0.4705882353, blue: 0.3058823529, alpha: 1)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        return button
    }()
    
    private let noButton: UIButton = {
        let button = UIButton()
        button.setTitle("아니요", for: .normal)
        button.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Medium", size: 15)
        button.backgroundColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        return button
    }()
    
    func showAlert(with title: String) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.backgroundView.frame = window.frame
        self.backgroundView.center = window.center
        self.alertView.addSubview(titleLabel)
        self.alertView.addSubview(yesButton)
        UIApplication.shared.windows.first?.addSubview(self.backgroundView)
        UIApplication.shared.windows.first?.addSubview(self.imageView)
        UIApplication.shared.windows.first?.addSubview(self.alertView)
        
        self.imageView.frame = CGRect(x: (window.frame.size.width - 100)/2, y: window.frame.midY - 125, width: 100, height: 50)
        self.alertView.frame = CGRect(x: 30, y: 0, width: window.frame.size.width - 120, height: 150)
        self.alertView.center = backgroundView.center

        self.titleLabel.frame = CGRect(x:0, y:0, width: alertView.frame.size.width, height: 100)
        self.titleLabel.text = title
        
        yesButton.frame = CGRect(x:0, y:alertView.frame.size.height - 50, width: alertView.frame.size.width, height: 50)
        yesButton.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        
        
        let multipleValue = CGFloat(0.7)
        alertView.transform = CGAffineTransform(translationX: 0, y: 0).scaledBy(x: multipleValue, y: 1.0)
        imageView.transform = CGAffineTransform(translationX: 0, y: 0).scaledBy(x: multipleValue, y: 1.0)
        alertView.alpha = 0
        imageView.alpha = 0
        
        
        
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            guard let self = self else { return print("self 뜯기 문제!") }
            self.alertView.transform = CGAffineTransform.identity
            self.imageView.transform = CGAffineTransform.identity
            self.alertView.alpha = 1
            self.imageView.alpha = 1
        })
    }
    
    @objc open func dismissAlert(){
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            guard let self = self else { return print("self 뜯기 문제!") }
            let multipleValue = CGFloat(0.7)
            self.alertView.transform = CGAffineTransform(translationX: 0, y: 0).scaledBy(x: multipleValue, y: 1.0)
            self.imageView.transform = CGAffineTransform(translationX: 0, y: 0).scaledBy(x: multipleValue, y: 1.0)
            self.alertView.alpha = 0
            self.imageView.alpha = 0
        }, completion: { [weak self] _ in
            guard let self = self else { return print("self 뜯기 문제!") }
            self.alertView.transform = CGAffineTransform.identity
            self.imageView.transform = CGAffineTransform.identity
            self.didDismiss?()
            self.imageView.removeFromSuperview()
            self.yesButton.removeTarget(nil, action: nil, for: .allEvents)
            for view in self.alertView.subviews{
                view.removeFromSuperview()
            }
            self.alertView.removeFromSuperview()
            self.backgroundView.removeFromSuperview()
        })
    }
    
    //타이틀, 메세지가 있는 Yes , No 알람창
    func showQuestionAlert(with title: String, message: String, messageLine: Int = 1) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.backgroundView.frame = window.frame
        self.backgroundView.center = window.center
        self.alertView.addSubview(titleLabel)
        self.alertView.addSubview(messageLabel)
        self.alertView.addSubview(yesButton)
        self.alertView.addSubview(noButton)
        UIApplication.shared.windows.first?.addSubview(self.backgroundView)
        UIApplication.shared.windows.first?.addSubview(self.imageView)
        UIApplication.shared.windows.first?.addSubview(self.alertView)
        
    
        if messageLine == 1{
            self.imageView.frame = CGRect(x: (window.frame.size.width - 100)/2, y: window.frame.midY - 125, width: 100, height: 50)
            self.alertView.frame = CGRect(x: 30, y: 0, width: window.frame.size.width - 120, height: 150)
            self.alertView.center = backgroundView.center
            self.titleLabel.frame = CGRect(x:0, y:20, width: alertView.frame.size.width, height: 40)
            self.messageLabel.frame = CGRect(x:0, y:45, width: alertView.frame.size.width, height: 40)
        }else{
            self.imageView.frame = CGRect(x: (window.frame.size.width - 100)/2, y: window.frame.midY - 140, width: 100, height: 50)
            self.alertView.frame = CGRect(x: 30, y: 0, width: window.frame.size.width - 120, height: 180)
            self.alertView.center = backgroundView.center
            self.titleLabel.frame = CGRect(x:0, y:25, width: alertView.frame.size.width, height: 40)
            self.messageLabel.frame = CGRect(x:0, y:45, width: alertView.frame.size.width, height: 80)
        }

        self.titleLabel.text = title
        self.messageLabel.text = message
        
        yesButton.frame = CGRect(x:alertView.frame.size.width/2 , y:alertView.frame.size.height - 50, width: alertView.frame.size.width/2, height: 50)
        yesButton.addTarget(self, action: #selector(yesAlert), for: .touchUpInside)
        
        noButton.frame = CGRect(x: 0 , y:alertView.frame.size.height - 50, width: alertView.frame.size.width/2, height: 50)
        noButton.addTarget(self, action: #selector(noAlert), for: .touchUpInside)
        
        let multipleValue = CGFloat(0.7)
        alertView.transform = CGAffineTransform(translationX: 0, y: 0).scaledBy(x: multipleValue, y: 1.0)
        imageView.transform = CGAffineTransform(translationX: 0, y: 0).scaledBy(x: multipleValue, y: 1.0)
        alertView.alpha = 0
        imageView.alpha = 0
        
        
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            guard let self = self else { return print("self 뜯기 문제!") }
            self.alertView.transform = CGAffineTransform.identity
            self.imageView.transform = CGAffineTransform.identity
            self.alertView.alpha = 1
            self.imageView.alpha = 1
        })
    }
    
    
    //타이틀만 있는 Yes , No 알람창
    func showQuestionAlert(with title: String) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.backgroundView.frame = window.frame
        self.backgroundView.center = window.center
        self.alertView.addSubview(titleLabel)
        self.alertView.addSubview(yesButton)
        self.alertView.addSubview(noButton)
        UIApplication.shared.windows.first?.addSubview(self.backgroundView)
        UIApplication.shared.windows.first?.addSubview(self.imageView)
        UIApplication.shared.windows.first?.addSubview(self.alertView)
        
        self.imageView.frame = CGRect(x: (window.frame.size.width - 100)/2, y: window.frame.midY - 125, width: 100, height: 50)
        self.alertView.frame = CGRect(x: 30, y: 0, width: window.frame.size.width - 120, height: 150)
        self.alertView.center = backgroundView.center

        self.titleLabel.frame = CGRect(x:0, y:0, width: alertView.frame.size.width, height: 100)
        self.titleLabel.text = title
        
        yesButton.frame = CGRect(x:alertView.frame.size.width/2 , y:alertView.frame.size.height - 50, width: alertView.frame.size.width/2, height: 50)
        yesButton.addTarget(self, action: #selector(yesAlert), for: .touchUpInside)
        
        noButton.frame = CGRect(x: 0 , y:alertView.frame.size.height - 50, width: alertView.frame.size.width/2, height: 50)
        noButton.addTarget(self, action: #selector(noAlert), for: .touchUpInside)
        
        let multipleValue = CGFloat(0.7)
        alertView.transform = CGAffineTransform(translationX: 0, y: 0).scaledBy(x: multipleValue, y: 1.0)
        imageView.transform = CGAffineTransform(translationX: 0, y: 0).scaledBy(x: multipleValue, y: 1.0)
        alertView.alpha = 0
        imageView.alpha = 0
        
        
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            guard let self = self else { return print("self 뜯기 문제!") }
            self.alertView.transform = CGAffineTransform.identity
            self.imageView.transform = CGAffineTransform.identity
            self.alertView.alpha = 1
            self.imageView.alpha = 1
        })
    }
    
    
    //확인 눌렀을 때
    @objc open func yesAlert(){
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            guard let self = self else { return print("self 뜯기 문제!") }
            let multipleValue = CGFloat(0.7)
            self.alertView.transform = CGAffineTransform(translationX: 0, y: 0).scaledBy(x: multipleValue, y: 1.0)
            self.imageView.transform = CGAffineTransform(translationX: 0, y: 0).scaledBy(x: multipleValue, y: 1.0)
            self.alertView.alpha = 0
            self.imageView.alpha = 0
        }, completion: { [weak self] _ in
            guard let self = self else { return print("self 뜯기 문제!") }
            self.alertView.transform = CGAffineTransform.identity
            self.imageView.transform = CGAffineTransform.identity
            self.selectedYes?()
            self.yesButton.removeTarget(nil, action: nil, for: .allEvents)
            self.noButton.removeTarget(nil, action: nil, for: .allEvents)
            self.imageView.removeFromSuperview()
            for view in self.alertView.subviews{
                view.removeFromSuperview()
            }
            self.alertView.removeFromSuperview()
            self.backgroundView.removeFromSuperview()
        })
    }
    
    //취소 눌렀을 때
    @objc open func noAlert(){
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            guard let self = self else { return print("self 뜯기 문제!") }
            let multipleValue = CGFloat(0.7)
            self.alertView.transform = CGAffineTransform(translationX: 0, y: 0).scaledBy(x: multipleValue, y: 1.0)
            self.imageView.transform = CGAffineTransform(translationX: 0, y: 0).scaledBy(x: multipleValue, y: 1.0)
            self.alertView.alpha = 0
            self.imageView.alpha = 0
        }, completion: { [weak self] _ in
            guard let self = self else { return print("self 뜯기 문제!") }
            self.alertView.transform = CGAffineTransform.identity
            self.imageView.transform = CGAffineTransform.identity
            self.imageView.removeFromSuperview()
            self.yesButton.removeTarget(nil, action: nil, for: .allEvents)
            self.noButton.removeTarget(nil, action: nil, for: .allEvents)
            for view in self.alertView.subviews{
                view.removeFromSuperview()
            }
            self.alertView.removeFromSuperview()
            self.backgroundView.removeFromSuperview()
        })
    }
    
    
}
