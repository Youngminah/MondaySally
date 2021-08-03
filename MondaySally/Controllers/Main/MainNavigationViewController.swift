//
//  MainNavigationViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/03.
//

import UIKit

class MainNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.applyFontAndSize()
        //self.navigationBar.setBackgroundImage(UIImage(), for:.default)
//        var backImage = UIImage(named: "icChevronLeftGray")
//        backImage = resizeImage(image: backImage!, newWidth: 20)
//        self.navigationBar.backIndicatorImage = backImage
//        self.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.setBackBtnTarget(target: self, action: #selector(dismissBackButton))
        if #available(iOS 14.0, *) {
            self.navigationItem.backBarButtonItem?.menu = nil
        }
        self.navigationItem.backBarButtonItem?.title = " "
        self.navigationItem.backButtonTitle = " "
        self.navigationBar.backItem?.backButtonTitle = " "
        self.navigationBar.layoutIfNeeded()
    }
    
    @objc func dismissBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setBackBtnTarget(target: AnyObject?, action: Selector) {
        var backImg: UIImage = UIImage(named: "icChevronLeftGray")!
        let leftPadding: CGFloat = 10
        let adjustSizeForBetterHorizontalAlignment: CGSize = CGSize(width: backImg.size.width + leftPadding, height: backImg.size.height)

        UIGraphicsBeginImageContextWithOptions(adjustSizeForBetterHorizontalAlignment, false, 0)
        backImg.draw(at: CGPoint(x: leftPadding, y: 0))
        backImg = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        self.navigationBar.backIndicatorImage = backImg
        self.navigationBar.backIndicatorTransitionMaskImage = backImg

        let backBtn: UIBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: target, action: action)
        self.navigationItem.backBarButtonItem = backBtn
    }
}

