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
        self.setUp()
    }
    
    private func setUp(){
        self.navigationBar.applyFontAndSize()
        self.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationBar.layoutIfNeeded()
    }
}


