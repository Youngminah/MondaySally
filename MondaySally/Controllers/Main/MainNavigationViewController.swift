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
            
        self.navigationBar.backIndicatorImage = UIImage(named: "icChevronLeftGray")
        self.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "icChevronLeftGray")
        self.navigationItem.backBarButtonItem?.title = " "
        self.navigationItem.backButtonTitle = " "
        self.navigationBar.backItem?.backButtonTitle = " "
        self.navigationBar.layoutIfNeeded()
    }
}
