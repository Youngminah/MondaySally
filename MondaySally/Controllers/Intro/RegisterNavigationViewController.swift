//
//  RegisterNavigationViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/01.
//

import UIKit

class RegisterNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.applyFontAndSize()
        //self.setupStyle()
        self.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationBar.layoutIfNeeded()

    }
    
    private func setupStyle() {
        UINavigationBar.clearShadow()
        self.navigationBar.layer.applyShadow(color: .gray, alpha: 0.3, x: 0, y: 0, blur: 12)
    }

}


