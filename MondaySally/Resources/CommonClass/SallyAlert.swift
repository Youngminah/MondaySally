//
//  SallyAlert.swift
//  MondaySally
//
//  Created by meng on 2021/07/17.
//

//import UIKit
//
//import UIKit
//
//open class SallyAlert {
//    static let shared = SallyAlert()
//    var didDismiss: (() -> ())?
//
//    private let backgroundView: UIView = {
//        let backgrounView = UIView()
//        backgrounView.backgroundColor = .black
//        backgrounView.alpha = 0.6
//        return backgrounView
//    }()
//
//    private let alertView: UIView = {
//       let alert = UIView()
//        alert.backgroundColor = .white
//        alert.layer.masksToBounds = true
//        alert.layer.cornerRadius = 11
//        return alert
//    }()
//
//    private let imageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = #imageLiteral(resourceName: "illustMondaysallySymbolPopup")
//        return imageView
//    }()
//
//    private let titleLabel: UILabel = {
//        let titleLabel = UILabel()
//        titleLabel.textAlignment = .center
//        titleLabel.numberOfLines = 2
//        titleLabel.font = UIFont(name: "NotoSansCJKkr-Regular", size: 14)
//        return titleLabel
//    }()
//
//    private let messageLabel: UILabel = {
//        let titleLabel = UILabel()
//        titleLabel.textAlignment = .center
//        titleLabel.numberOfLines = 2
//        titleLabel.font = UIFont(name: "NotoSansCJKkr-Regular", size: 14)
//        return titleLabel
//    }()
//
//    private let button: UIButton = {
//        let button = UIButton()
//        button.setTitle("확인", for: .normal)
//        button.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Medium", size: 15)
//        button.backgroundColor = #colorLiteral(red: 1, green: 0.4705882353, blue: 0.3058823529, alpha: 1)
//        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
//        return button
//    }()
//
//    func showAlert(with title: String, message: String) {
//
//        let window = UIWindow(frame: UIScreen.main.bounds)
//        self.backgroundView.frame = window.frame
//        self.backgroundView.center = window.center
//        self.alertView.addSubview(titleLabel)
//        self.alertView.addSubview(button)
//        UIApplication.shared.windows.first?.addSubview(self.backgroundView)
//        UIApplication.shared.windows.first?.addSubview(self.imageView)
//        UIApplication.shared.windows.first?.addSubview(self.alertView)
//
//        self.imageView.frame = CGRect(x: (window.frame.size.width - 100)/2, y: window.frame.midY - 125, width: 100, height: 50)
//        self.alertView.frame = CGRect(x: 30, y: 0, width: window.frame.size.width - 120, height: 150)
//        self.alertView.center = backgroundView.center
//
//        self.titleLabel.frame = CGRect(x:0, y:0, width: alertView.frame.size.width, height: 100)
//        self.titleLabel.text = title
//
//
////        messageLabel = UILabel(frame: CGRect(x:0, y:80, width: alertView.frame.size.width, height: 170))
////        messageLabel.text = message
////        self.alertView.addSubview(messageLabel)
//
//        button.frame = CGRect(x:0, y:alertView.frame.size.height - 50, width: alertView.frame.size.width, height: 50)
//        button.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
//
//        let multipleValue = CGFloat(0.7)
//        alertView.transform = CGAffineTransform(translationX: 0, y: 0).scaledBy(x: multipleValue, y: 1.0)
//        imageView.transform = CGAffineTransform(translationX: 0, y: 0).scaledBy(x: multipleValue, y: 1.0)
//        alertView.alpha = 0
//        imageView.alpha = 0
//
//
//
//        UIView.animate(withDuration: 0.1, animations: { [weak self] in
//            guard let self = self else { return print("self 뜯기 문제!") }
//            self.alertView.transform = CGAffineTransform.identity
//            self.imageView.transform = CGAffineTransform.identity
//            self.alertView.alpha = 1
//            self.imageView.alpha = 1
//        })
//    }
//
//    @objc open func dismissAlert(){
//        UIView.animate(withDuration: 0.1, animations: { [weak self] in
//            guard let self = self else { return print("self 뜯기 문제!") }
//            let multipleValue = CGFloat(0.7)
//            self.alertView.transform = CGAffineTransform(translationX: 0, y: 0).scaledBy(x: multipleValue, y: 1.0)
//            self.imageView.transform = CGAffineTransform(translationX: 0, y: 0).scaledBy(x: multipleValue, y: 1.0)
//            self.alertView.alpha = 0
//            self.imageView.alpha = 0
//        }, completion: { [weak self] _ in
//            guard let self = self else { return print("self 뜯기 문제!") }
//            self.alertView.transform = CGAffineTransform.identity
//            self.imageView.transform = CGAffineTransform.identity
//            self.didDismiss?()
//            self.imageView.removeFromSuperview()
//            self.alertView.removeFromSuperview()
//            self.backgroundView.removeFromSuperview()
//        })
//    }
//
//}
